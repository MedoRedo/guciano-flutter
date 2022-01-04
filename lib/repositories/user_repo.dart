import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:guciano_flutter/models/cart_item.dart';
import 'package:guciano_flutter/models/order.dart';
import 'package:guciano_flutter/models/order_item.dart';
import 'package:guciano_flutter/models/user_profile.dart';
import 'package:http/http.dart' as http;

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

  Future<int> placeOrder(List<CartItem> items, Delivery deliveryOption,
      Payment paymentOption, num usedBalance, String notes) async {
    var order = {
      'delivery_option': deliveryOption == Delivery.dorm ? 'dorm' : 'kiosk',
      'payment_option': paymentOption == Payment.cash ? 'cash' : 'credit_card',
      'used_balance': usedBalance,
      'extra_notes': notes,
      'items': items,
    };

    Uri url = Uri.parse(
        'https://us-central1-guciano-42a33.cloudfunctions.net/createOrder');
    http.Response response = await http.post(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(
          <String, dynamic>{
            'userId': currentUser.uid,
            'order': order,
          },
        ));

    if (kDebugMode) {
      print("Order status: ${response.statusCode}");
      print("createOrder response body: ${response.body}");
    }

    return response.statusCode;
  }
}
