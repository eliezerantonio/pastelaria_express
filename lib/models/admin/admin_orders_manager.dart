import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../order/order.dart';
import '../user/user_model.dart';

class AdminOrdersManager extends ChangeNotifier {
  final List<Order> _orders = [];
  List<Status> statusFilter = [
    Status.accomplished,
    Status.done,
    Status.confirmed,
    Status.delivered
  ];

  UserModel userFilter;
  UserModel user;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription _subscription;

  Future<void> updateAdmin({bool adminEnable, UserModel user}) async {
    this.user = user;

    //clear orders
    _orders.clear();
    //remover o lstener quando fechar a app
    _subscription?.cancel();

    if (adminEnable != null && user != null) {
      //buscar pedidos

      _listenToOrders();
    }
  }

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    if (userFilter != null) {
      output =
          output.where((element) => element.userId == userFilter.id).toList();
    }
    return output
        .where((element) => statusFilter.contains(element.status))
        .toList();
  }

  void _listenToOrders() {
    //bucar pedidos do usuario logado
    _subscription = firestore
        .collection('orders')
        .where("adminId", isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      for (final change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(Order.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:
            final modOrder = _orders.firstWhere(
                (element) => element.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);

            break;
          case DocumentChangeType.removed:
            debugPrint("Deu problema muito serio!!!");
            break;
        }
      }
      notifyListeners();
    });
  }

  void setUserFilter(UserModel user) {
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter({Status status, bool enabled}) {
    if (enabled) {
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    //remover o lstener quando fechar a app
    _subscription?.cancel();
  }
}
