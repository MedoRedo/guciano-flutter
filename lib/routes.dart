import 'package:flutter/cupertino.dart';
import 'package:guciano_flutter/pages/cart_page.dart';
import 'package:guciano_flutter/pages/checkout_page.dart';
import 'package:guciano_flutter/pages/home_page.dart';
import 'package:guciano_flutter/pages/login_page.dart';
import 'package:guciano_flutter/pages/prev_orders_page.dart';

final routes = <String, WidgetBuilder>{
  LoginPage.tag: (context) => const LoginPage(),
  HomePage.tag: (context) => const HomePage(),
  PrevOrdersPage.tag: (context) => const PrevOrdersPage(),
  CartPage.tag: (context) => const CartPage(),
  CheckoutPage.tag: (context) => const CheckoutPage()
};
