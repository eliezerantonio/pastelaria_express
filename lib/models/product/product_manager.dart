import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../user/user_manager.dart';
import 'product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    loadProducts();
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Product> allProducts = [];
  List<Product> allProductsHome = [];

  UserManager userManager;
  String id = '';
  bool isLoading = false;

  String _search = '';
  //get
  String get search => _search;

  //set
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];
    if (search.isEmpty) {
      filteredProducts.addAll(allProductsHome);
    } else {
      filteredProducts.addAll(allProductsHome
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }
    return filteredProducts;
  }

  //buscar todos produtos para admin
  Future<void> loadAllProducts(
      {UserManager userManager, String adminId}) async {
    try {
      if (userManager != null) {
        print("Buscar admin");
        loadAllProductsAdmin(adminId: userManager.user?.id ?? "");
      } else {
        print("Buscar user");
        loadAllProductsUser(adminId: adminId);
      }
    } catch (e) {
      print("Error to get products $e");
    }
  }

  Future<void> loadAllProductsAdmin({@required String adminId}) async {
    isLoading = true;
    final QuerySnapshot snapProducts = await firestore
        .collection("products")
        .where('adminId', isEqualTo: adminId)
        .where('deleted', isEqualTo: false)
        .get();
    allProducts.clear();
    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllProductsUser({@required String adminId}) async {
    isLoading = true;
    id = adminId;

    final QuerySnapshot snapProducts = await firestore
        .collection("products")
        .where('adminId', isEqualTo: adminId)
        .where('deleted', isEqualTo: false)
        .get();
    allProducts.clear();
    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    isLoading = true;

    final QuerySnapshot snapProducts = await firestore
        .collection("products")
        .where('deleted', isEqualTo: false)
        .get();
    allProductsHome.clear();
    allProductsHome =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
    isLoading = false;
    notifyListeners();
  }

  Product findProductById(String id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Product product) {
    allProducts.removeWhere((p) => p.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    allProducts.clear();
  }
}
