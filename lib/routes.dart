import 'package:flutter/cupertino.dart';
import 'package:guciano_flutter/ui/home_page.dart';
import 'package:guciano_flutter/ui/login_page.dart';
import 'package:guciano_flutter/ui/payment_page.dart';
import 'package:guciano_flutter/ui/prev_orders_page.dart';

final routes = <String, WidgetBuilder>{
  LoginPage.tag: (context) => LoginPage(),
  HomePage.tag: (context) => HomePage(),
  PrevOrdersPage.tag: (context) => PrevOrdersPage(),
  PaymentPage.tag: (context) => PaymentPage(),
};
