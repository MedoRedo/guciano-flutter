import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guciano_flutter/models/order.dart';
import 'package:guciano_flutter/models/order_item.dart';
import 'package:guciano_flutter/models/user_profile.dart';

class UserRepo {
  late final CollectionReference users;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User get currentUser => firebaseAuth.currentUser!;

  UserRepo() {
    users = FirebaseFirestore.instance.collection('users');
  }

  Future<UserProfile> getUserProfile() async {
    DocumentSnapshot documentSnapshot = await users.doc(currentUser.uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    data['email'] = currentUser.email;
    return UserProfile.fromJson(data);
  }

  Future<List<Order>> getPreviousOrders() async {
    List<Order> orders = [];
    QuerySnapshot querySnapshot =
        await users.doc(currentUser.uid).collection('orders').get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      orders.add(Order.fromJson(data));
    }

    return orders;
  }

  Future<List<OrderItem>> getOrderDetails(String orderId) async {
    List<OrderItem> items = [];
    QuerySnapshot querySnapshot = await users
        .doc(currentUser.uid)
        .collection('orders')
        .doc(orderId)
        .collection('items')
        .get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      items.add(OrderItem.fromJson(data));
    }

    return items;
  }
}
