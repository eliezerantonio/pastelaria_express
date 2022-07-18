import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../imports.dart';
import 'order.dart';

class OrdersManager extends ChangeNotifier {
  OrdersManager();
  UserModel user;
  List<Order> orders = [];
  

  var formatter = DateFormat('yyyy-MM-dd');
  var monthFormatter = DateFormat('yyyy-MM');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription _subscription;

  void updateUser(UserModel user) {
    this.user = user;
    //clear orders
    orders.clear();
    //remover o lstener quando fechar a app
    _subscription?.cancel();

    if (user != null) {
      //buscar pedidos
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    try {
      //bucar pedidos do usuario logado
      _subscription = firestore
          .collection('orders')
          .where('user', isEqualTo: user.id)
          .snapshots()
          .listen((event) {
        orders.clear();

        for (final doc in event.docs) {
          orders.add(Order.fromDocument(doc));
        }

        notifyListeners();
      });
    } catch (error) {
      notifyListeners();
    }
  }

  num get totalAccumulated {
    num value = 0;
    for (int i = 0; i < orders.length; i++) {
      value = orders[i].price * 0.05;
    }
    return value;
  }

  num get totalAccumulatedPastryshot {
    num value = 0;
    for (int i = 0; i < orders.length; i++) {
      value = orders[i].price * 0.95;
    }
    return value;
  }

  void getOrders(String adminId) {
    try {
      //bucar pedidos do usuario logado
      _subscription = firestore
          .collection('orders')
          .where('adminId', isEqualTo: adminId)
          .snapshots()
          .listen((event) {
        orders.clear();

        for (final doc in event.docs) {
          orders.add(Order.fromDocument(doc));
        }

        notifyListeners();
      });
    } catch (error) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    //remover o lstener quando fechar a app
    _subscription?.cancel();
  }
}
