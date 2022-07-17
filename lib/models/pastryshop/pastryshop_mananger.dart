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

  void delete(Pastryshop pastryshop) {
    pastryshop.delete();
    pastryshops.removeWhere((p) => p.id == pastryshop.id);
    notifyListeners();
  }
}
