import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  String userId = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'tokens': FieldValue.arrayUnion([token]),
  });
}

Future<void> removeTokenFromDatabase(String userId) async {
  String? token = await FirebaseMessaging.instance.getToken();
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'tokens': FieldValue.arrayRemove([token])
  });
}
