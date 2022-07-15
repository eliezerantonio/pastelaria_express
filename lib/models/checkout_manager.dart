import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pastelariaexpress/imports.dart';

import 'cart/cart_manager.dart';
import 'order/order.dart';
import 'product/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout(
      {String location,
      String pay,
      String obs,
      dynamic img,
      String timeDelivery,
      UserModel user,
      Function onStockFail,
      Function onSuccess}) async {
    loading = true;

    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading = false;
      return;
    }

    final orderId = await _getOrderId();
    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();
    final id = cartManager.items[0].product.adminId;

    order.save(
        idAdmin: id.toString().replaceAll(")", ""),
        obsa: obs,
        pay: pay,
        user: user,
        img: img);

    onSuccess(order);
    loading = false;
    
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(ref);
        final orderId = doc.data()['current'] as int;
        transaction.update(ref, {'current': orderId + 1});

        //  result.resolve(true);
        return {'orderId': orderId};
      }, timeout: const Duration(seconds: 10));

      return result['orderId'];
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar numero do pedido');
    }
  }

  Future<void> _decrementStock() {
    //1. Ler todos os estoques
    //2. Decemento localmente os estoques
    //3.salvar dos estoques no firebase

    //lendo produtos mais atualizados para decrementar
    return firestore.runTransaction(
      (transaction) async {
        try {
          final List<Product> productsToUpdate = [];
          final List<Product> productsWithoutStock = [];
          for (final cartProduct in cartManager.items) {
            Product product;
            if (productsToUpdate
                .any((element) => element.id == cartProduct.productId)) {
              product = productsToUpdate
                  .firstWhere((element) => element.id == cartProduct.productId);
            } else {
              final doc = await transaction
                  .get(firestore.doc('products/${cartProduct.productId}'));

              product = Product.fromDocument(doc);
            }
            cartProduct.product = product;

            //verificando se tem estoque soficiente

          }
        } catch (e) {
          debugPrint(" Transacao falhou $e");
        }
      },
    );
  }
}
