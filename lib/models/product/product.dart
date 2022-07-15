import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:pastelariaexpress/models/pastryshop/pastryshop.dart';

import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product({
    this.id,
    this.name,
    this.adminId,
    this.description,
    this.images,
    this.price,
    this.deleted = false,
  }) {
    images = images ?? [];
  }

  Product.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    try {
      id = doc.id;
      name = data['name'] as String;
      adminId = data['adminId'] as String;
      description = data['description'] as String;
      images = List<String>.from(data['images'] as List<dynamic>);
      deleted = (data['deleted'] ?? false) as bool;
      price = data["price"] as num;
      firestore.doc('pastryshops/$adminId').snapshots().listen((doc) {
        pastryshop = Pastryshop.fromDocument(doc);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String id;
  String name;
  String description;
  String adminId;
  List<String> images;
  num price;
  bool deleted = false;
  int quantity = 1;
  Pastryshop pastryshop = Pastryshop();

  List<dynamic> newImages;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('products/$id');

  firebase_storage.Reference get storageRef =>
      firebase_storage.FirebaseStorage.instance.ref("products").child(id);

  Future<void> save(
    String adminId,
  ) async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'adminId': adminId,
      'price': price,
      'deleted': deleted
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    //IMAGES  [ URL1,URL2,URL3 ]
    //NEWIMAGES [ URL1,URL2,URL3 , FILE1, FILE2]
    //UPDATE  [URL2,URL3]

    //MANDA FILE1 PRO STORAGE-> FURL1
    // MANDA FILE2 PRO STORAGE FULR2
    //EXCLUI [URL1]

    //add
    final List<String> updateImages = [];
    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        firebase_storage.UploadTask task =
            storageRef.child(const Uuid().v1()).putFile(newImage as File);
        firebase_storage.TaskSnapshot snapshot = await task;

        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }
    //remove
    for (final image in images) {
      if (!newImages.contains(image) && image.contains('firebase')) {
        try {
          final ref = storage.ref(image);
          await ref.delete();
        } catch (e) {
          debugPrint("Falha ao deletar $image");
        }
      }
    }

    await firestoreRef.update({'images': updateImages});
    images = updateImages;
    loading = false;
  }
void delete() {
    firestoreRef.update({'deleted': true});
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      price: price,
      deleted: deleted,
    );
  }

  
  void increment() {
    quantity++;

    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  //preco total
  num get totalPrice => price * quantity;
  Future<bool> reset() async {
    quantity = 0;
    return true;
  }

  @override
  String toString() {
    return 'Product{id: $id, adminId: $adminId , name: $name, description: '
        '$description, images: $images, sizes: , newImages: $newImages}';
  }
}
