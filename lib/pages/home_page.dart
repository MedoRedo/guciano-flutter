import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guciano_flutter/pages/cart_page.dart';
import 'package:guciano_flutter/pages/payment_page.dart';
import 'package:guciano_flutter/pages/prev_orders_page.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prevOrdersBtn = Padding(
      padding: EdgeInsets.zero,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(PrevOrdersPage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightGreen,
        child: Text('Previous Orders', style: TextStyle(color: Colors.white)),
      ),
    );

    final paymentBtn = Padding(
      padding: EdgeInsets.zero,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(PaymentPage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightGreen,
        child: Text('Payment Screen', style: TextStyle(color: Colors.white)),
      ),
    );

    final CartBtn = Padding(
      padding: EdgeInsets.zero,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(CartPage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightGreen,
        child: Text('Cart Screen', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 24.0),
          prevOrdersBtn,
          paymentBtn,
          CartBtn,
        ],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}
