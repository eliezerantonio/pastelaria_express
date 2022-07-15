import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:pastelariaexpress/models/pastryshop/pastryshop.dart';

import '../user/user_manager.dart';

class PastryshopManager with ChangeNotifier {
  List<Pastryshop> pastryshops = [];
  StreamSubscription _subscription;
  PastryshopManager();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void checkUser({UserManager userManager}) {
    if (userManager.adminEnabled) {
      loadShop(userManager.user.id);
      print(":estou");
    } else {
      loadAllShops();
      print(":Aqui");
    }
  }

  Future<void> loadAllShops() async {
    _subscription = firestore
        .collection("pastryshops")
        .orderBy("likes", descending: true)
        .snapshots()
        .listen((event) {
      pastryshops.clear();

      for (final doc in event.docs) {
        pastryshops.add(Pastryshop.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  Future<void> loadShop(String adminId) async {
    _subscription = firestore
        .collection("pastryshops")
        .where("adminId", isEqualTo: adminId)
        .snapshots()
        .listen((event) {
      pastryshops.clear();

      for (final doc in event.docs) {
        pastryshops.add(Pastryshop.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  void update(Pastryshop pastryshop) {
    pastryshops.removeWhere((p) => p.id == pastryshop.id);
    pastryshops.add(pastryshop);
    notifyListeners();
  }

  void delete(Pastryshop pastryshop) {
    pastryshop.delete();
    pastryshops.removeWhere((p) => p.id == pastryshop.id);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
