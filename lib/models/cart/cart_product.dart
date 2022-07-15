import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../product/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this.product) {
    productId = getProduct.id;
    quantity = product.quantity;
    userId = product.adminId;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    id = document.id;
    productId = data['pid'] as String;
    quantity = data['quantity'] as int;
    firestore.doc('products/$productId').snapshots().listen((doc) {
      product = Product.fromDocument(doc);
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;

    fixedPrice = map['fixedPrice'] as num;

    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
      },
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String id;
  String productId;
  int quantity = 0;
  String size;

  num fixedPrice;
  Product product = Product();
  String userId;

  Product get getProduct => product;

  //preco unitario
  num get unitPrice {
    if (getProduct == null) return 0;
    return product.price ?? 0;
  }

  //preco total
  num get totalPrice => unitPrice * quantity;

  //para carrinho
  Map<String, dynamic> toCartItemMap() {
    return {'pid': productId, 'quantity': quantity, 'size': size};
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'fixedPrice': fixedPrice ?? unitPrice
    };
  }

  //se e empilhavel
  bool stackable(Product product) {
    return product.id == productId;
  }

  void increment() {
    quantity++;

    notifyListeners();
  }

  void decrement() {
    quantity--;

    notifyListeners();
  }

  

  @override
  String toString() {
    return 'CartProduct{ _product: $product}';
  }
}
