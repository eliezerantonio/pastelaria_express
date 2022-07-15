import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pastelariaexpress/models/pastryshop/pastryshop.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

import '../cart/cart_manager.dart';
import '../cart/cart_product.dart';
import '../user/user_model.dart';

enum Status {
  canceled,
  accomplished,
  confirmed,
  done,

  delivered,
}

class Order {
  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;

    status = Status.accomplished;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    orderId = doc.id;
    items = (data['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();
    price = data['price'] as num;
    userId = data['user'] as String;

    date = data['date'] as Timestamp;
    obs = data['obs'] as String;

    status = Status.values[data['status'] as int];
    location = data['location'] as String;
    userName = data['userName'] as String;
    pointPrice = data['pointPrice'] as num;
    pay = data['pay'] as String;
    adminId = data['adminId'] as String;
    transfer = data['transfer'] as String;
    phone = data['phone'] as String;
    firestore.doc('pastryshops/$adminId').snapshots().listen((doc) {
      pastryshop = Pastryshop.fromDocument(doc);
    });
  }

  final FirebaseFirestore firestore = FirebaseFirestore?.instance;
  DocumentReference get firestoreRef =>
      firestore.collection('orders').doc(orderId);
  firebase_storage.Reference get storageRef =>
      firebase_storage.FirebaseStorage.instance.ref("transfers");

  Future<void> save({
    String idAdmin,
    num serviceChargeManager,
    String pay,
    UserModel user,
    dynamic img,
    String timeDeliverya,
    String obsa,
    num deliveryPrice,
  }) async {
    try {
      transfer = "";
      if (img != null) {
        transfer = await uploadImge(img);
      }
      firestore.collection('orders').doc(orderId).set({
        //tranformando em mapa
        'items': items.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'obs': obsa,
        'pay': pay,
        'timeDelivery': timeDeliverya,
        'serviceChargeManager': serviceChargeManager,
        'deliveryPrice': deliveryPrice,
        'phone': user.phone,
        "userName": user.name,
        'adminId': idAdmin.replaceAll("(", ""),
        'user': userId,
        'transfer': transfer,
        'status': status.index,
        'date': Timestamp.now()
      });
    } catch (e, exception) {
      print("============> $e, $exception");
    }
  }

  Function() get back {
    return status.index >= Status.confirmed.index
        ? () {
            status = Status.values[status.index - 1];
            firestoreRef.update({'status': status.index});
          }
        : null;
  }

  Function() get advance {
    return status.index <= Status.done.index
        ? () {
            status = Status.values[status.index + 1];

            firestoreRef.update({'status': status.index});
          }
        : null;
  }

  void cancel() {
    status = Status.canceled;
    firestoreRef.update({'status': status.index});
  }

  void updateFromDocument(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    status = Status.values[data['status'] as int];
  }

  String orderId;
  List<CartProduct> items = [];
  num price;
  String userId;
  String adminId;
  Pastryshop pastryshop = Pastryshop();

  Status status;
  String location;
  String obs;
  num pointPrice;
  String pay;
  String timeDelivery;
  Timestamp date;
  String phone;
  String userName;
  num deliveryPrice;
  String transfer;
  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

//buscar enumerador das constantes
  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.accomplished:
        return 'Realizado';
      case Status.confirmed:
        return 'Confirmado';
      case Status.done:
        return 'Preparado';

      case Status.delivered:
        return "Entregue";
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId,  status: $status, date: $date}';
  }

  Future<String> uploadImge(img) async {
    firebase_storage.UploadTask task =
        storageRef.child(const Uuid().v1()).putFile(img as File);
    firebase_storage.TaskSnapshot snapshot = await task;

    final String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
