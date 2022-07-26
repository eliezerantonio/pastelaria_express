import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:pastelariaexpress/models/pastryshop/pastryshop.dart';

import '../user/user_manager.dart';

class PastryshopManager with ChangeNotifier {
  List<Pastryshop> pastryshops = [];
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

  void increment(Pastryshop pastryshop) {
    pastryshops = pastryshops.map((element) {
      if (element.id != pastryshop.id) return element;

      element.likes += 1;

      return element;
    }).toList();
    notifyListeners();
  }

  void decrement(Pastryshop pastryshop) {
    pastryshops = pastryshops.map((element) {
      if (element.id != pastryshop.id) return element;

      element.dislikes += 1;

      return element;
    }).toList();
    notifyListeners();
  }

  Future delete(Pastryshop pastryshop) async {
    try {
      pastryshops.removeWhere((element) => element.id == pastryshop.id);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loadAllShops() async {
    final snapshot = await firestore
        .collection("pastryshops")
        .orderBy("likes", descending: true)
        .get();
    pastryshops.clear();
    pastryshops = snapshot.docs.map((d) => Pastryshop.fromDocument(d)).toList();
    notifyListeners();
  }

  Future<void> loadShop(String adminId) async {
    final snapshot = await firestore
        .collection("pastryshops")
        .where("adminId", isEqualTo: adminId)
        .get();
    pastryshops.clear();
    pastryshops = snapshot.docs.map((d) => Pastryshop.fromDocument(d)).toList();
  }

  void update(Pastryshop pastryshop) {
    pastryshops.removeWhere((p) => p.id == pastryshop.id);
    pastryshops.add(pastryshop);
    notifyListeners();
  }
}
