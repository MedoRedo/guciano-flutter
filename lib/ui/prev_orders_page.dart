import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/order.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';

class PrevOrders extends StatefulWidget {
  static String tag = 'prev-orders-page';

  @override
  _PrevOrdersState createState() => _PrevOrdersState();
}

class _PrevOrdersState extends State<PrevOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text("Previous Orders"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      ),
      body: FutureBuilder(
        future: UserRepo(userId: FirebaseAuth.instance.currentUser!.uid)
            .getPreviousOrders(),
        builder: (context, AsyncSnapshot<List<Order>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Text(snapshot.data![index].paymentOption.toString());
                },
              ),
            );
          }
        },
      ),
      // bottomNavigationBar: makeBottom,
    );
  }
}
