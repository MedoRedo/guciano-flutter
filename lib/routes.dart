import 'package:flutter/cupertino.dart';
import 'package:guciano_flutter/pages/cart_page.dart';
import 'package:guciano_flutter/pages/checkout.dart';

import 'package:guciano_flutter/pages/home_page.dart';
import 'package:guciano_flutter/pages/login_page.dart';
import 'package:guciano_flutter/pages/payment_page.dart';
import 'package:guciano_flutter/pages/prev_orders_page.dart';

final routes = <String, WidgetBuilder>{
  LoginPage.tag: (context) => LoginPage(),
  HomePage.tag: (context) => HomePage(),
  PrevOrdersPage.tag: (context) => PrevOrdersPage(),
  PaymentPage.tag: (context) => PaymentPage(),
  CartPage.tag: (context) => CartPage(),
};
