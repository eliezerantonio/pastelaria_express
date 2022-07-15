import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import '../../imports.dart';

class Pastryshop with ChangeNotifier {
  String id;
  String name;
  List<String> images = [];
  String adminId;
  int likes = 0;
  int dislikes = 0;
  String ibam;
  String description;
  bool deleted = false;
  List classifiers = [];
  List<dynamic> newImages = [];

  Pastryshop(
      {this.id,
      this.name,
      this.description,
      this.adminId,
      this.ibam,
      this.deleted,
      this.images});

  Pastryshop.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    id = doc.id;
    name = data["name"] as String;
    ibam = data["ibam"] as String;
    deleted = data["deleted"] as bool;
    images = List<String>.from(data['images'] as List<dynamic>) ?? [];

    likes = data["likes"] as num;
    dislikes = data["dislikes"] as num;
    adminId = data["adminId"] as String;
    classifiers = List<String>.from(data['classifiers'] as List<dynamic>) ?? [];
    description = data["description"] as String;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('pastryshops/$id');

  firebase_storage.Reference get storageRef =>
      firebase_storage.FirebaseStorage.instance.ref("pastryshops").child(id);
  UserManager user = UserManager();

  Future<void> like() {
    firestore.collection("pastryshops").doc(id).update({'likes': likes + 1});
    saveClassifier("like");
  }

  Future<void> dislike() {
    firestore
        .collection("pastryshops")
        .doc(id)
        .update({'dislikes': dislikes + 1});
    saveClassifier("dislike");
  }

  void saveClassifier(String action) {
    firestore.collection("pastryshops").doc(id).update({
      'classifiers': classifiers = [(user.user.id)]
    });
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> save(
    String adminId,
  ) async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'adminId': adminId,
      'ibam': ibam,
      'deleted': false,
      'classifiers': classifiers,
      'likes': likes,
      'dislikes': dislikes,
    };

    if (id == null) {
      final doc = await firestore.collection('pastryshops').add(data);
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

    await firestoreRef.update({'images': updateImages});
    images = updateImages;
    loading = false;
  }

  void delete() {
    firestoreRef.update({'deleted': true});
  }

  Pastryshop clone() {
    return Pastryshop(
        id: id,
        name: name,
        description: description,
        images: List.from(images),
        deleted: deleted,
        adminId: adminId,
        ibam: ibam);
  }
}
