import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import '../../imports.dart';

class Pastryshop with ChangeNotifier {
  String id;
  String name;
  String image;
  String adminId;
  int likes = 0;
  int dislikes = 0;
  String ibam;
  String description;
  bool deleted = false;
  List classifiers = [];

  Pastryshop(
      {this.id,
      this.name,
      this.description,
      this.adminId,
      this.ibam,
      this.deleted,
      this.image});

  Pastryshop.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    id = doc.id;
    name = data["name"] as String ?? "";
    ibam = data["ibam"] as String;
    deleted = data["deleted"] as bool;
    image = data['image'] as String;

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

  Future<void> like() async {
    firestore.collection("pastryshops").doc(id).update({'likes': likes + 1});
    saveClassifier("like");
  }

  Future<void> dislike() async {
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
    dynamic file,
  ) async {
    loading = true;
    if (file != null) {
      image = await uploadImge(file);
    }
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'adminId': adminId,
      'ibam': ibam,
      'image': image,
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
        image: image,
        deleted: deleted,
        adminId: adminId,
        ibam: ibam);
  }

  Future<String> uploadImge(img) async {
    firebase_storage.UploadTask task =
        storageRef.child(const Uuid().v1()).putFile(img as File);
    firebase_storage.TaskSnapshot snapshot = await task;

    final String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
