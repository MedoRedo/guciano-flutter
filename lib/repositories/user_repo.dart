import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guciano_flutter/models/order.dart';
import 'package:guciano_flutter/models/order_item.dart';
import 'package:guciano_flutter/models/user.dart';

class UserRepo {
  late final CollectionReference users;
  final String userId;
  UserRepo({required this.userId}) {
    users = FirebaseFirestore.instance.collection('users');
  }

  Future<User> getUserProfile() async {
    DocumentSnapshot documentSnapshot = await users.doc(userId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return User.fromJson(data);
  }

  Future<List<Order>> getPreviousOrders() async {
    List<Order> orders = [];
    QuerySnapshot querySnapshot =
        await users.doc(userId).collection('orders').get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      orders.add(Order.fromJson(data));
    });

    return orders;
  }

  Future<List<OrderItem>> getOrderDetails(String orderId) async {
    List<OrderItem> items = [];
    QuerySnapshot querySnapshot = await users
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .collection('items')
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      items.add(OrderItem.fromJson(data));
    });

    return items;
  }

//   Future<void> main() async {
//   // Obtain science-fiction movies
//   List<QueryDocumentSnapshot<Movie>> movies = await moviesRef
//       .where('genre', isEqualTo: 'Sci-fi')
//       .get()
//       .then((snapshot) => snapshot.docs);

//   // Add a movie
//   await moviesRef.add(
//     Movie(
//       title: 'Star Wars: A New Hope (Episode IV)',
//       genre: 'Sci-fi'
//     ),
//   );

//   // Get a movie with the id 42
//   Movie movie42 = await moviesRef.doc('42').get().then((snapshot) => snapshot.data()!);
// }

  // final moviesRef = FirebaseFirestore.instance.collection('movies').withConverter<Movie>(
  //     fromFirestore: (snapshot, _) => Movie.fromJson(snapshot.data()!),
  //     toFirestore: (movie, _) => movie.toJson(),
  //   );
}
/**
 * {is_dorm_student: true, dorm_id: 1, name: Hussein El Feky, phone_number: +201224777905, available_balance: 10}
 */
