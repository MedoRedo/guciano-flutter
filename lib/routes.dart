import 'package:flutter/cupertino.dart';
import 'package:guciano_flutter/ui/home_page.dart';
import 'package:guciano_flutter/ui/login_page.dart';
import 'package:guciano_flutter/ui/prev_orders_page.dart';

final routes = <String, WidgetBuilder>{
  LoginPage.tag: (context) => LoginPage(),
  HomePage.tag: (context) => HomePage(),
  PrevOrders.tag: (context) => PrevOrders(),
};
