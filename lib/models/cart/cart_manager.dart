import 'package:cloud_firestore/cloud_firestore.dart';

import '../../imports.dart';
import '../product/product.dart';
import 'cart_product.dart';

class CartManager extends ChangeNotifier {
  CartManager() {
    onItemUpdate();
  }
  List<CartProduct> items = [];

  UserModel user;

  num productsPrice = 0.0;
  num _serviceCharge = 0.0;

  bool _received = false;

  // ignore: unnecessary_getters_setters
  bool get received => _received;

  // ignore: unnecessary_getters_setters
  set received(bool value) {
    _received = value;
    notifyListeners();
  }

  num get totalPrice {
    num price = 0.0;
    price = productsPrice + (serviceCharge ?? 0);

    return price;
  }

  num get serviceCharge {
    _serviceCharge = received ? 1000 : 0.0;

    return _serviceCharge;
  }
//  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool _loading = false;

  // ignore: unnecessary_getters_setters
  bool get loading => _loading;

  // ignore: unnecessary_getters_setters
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    if (user != null) {
      //carregar carrinho
      _loadCartItems();
    }
  }

  //adicionar carrinho

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment(); //incrementar se ja tem no carrinho

    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(onItemUpdate);
      items.add(cartProduct);

      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.id);
      onItemUpdate();
    }

    notifyListeners();
  }

//remover
  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(onItemUpdate);
    notifyListeners();
  }

//atualizar
  void onItemUpdate() {
    try {
      productsPrice = 0.0;
      for (int i = 0; i < items.length; i++) {
        final cartProduct = items[i];

        if (cartProduct.quantity < 1) {
          removeOfCart(cartProduct);
          i--;
          continue;
        }

        productsPrice += cartProduct.totalPrice;

        _updateCartProduct(cartProduct);
      }
    } catch (e) {
      debugPrint("${e.toString()} qtd do produto sujou");
    }
  }

  //carregar itens
  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.get();
    items = cartSnap.docs
        .map((d) => CartProduct.fromDocument(d)..addListener(onItemUpdate))
        .toList();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) {
      user.cartReference
          .doc(cartProduct.id)
          .update(cartProduct.toCartItemMap());
    }
    notifyListeners();
  }

  //funcao limpar carrinho
  void clear() {
    for (final cartProduct in items) {
      user.cartReference.doc(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }
}
