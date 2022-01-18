import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:guciano_flutter/pages/home_page.dart';
import 'package:guciano_flutter/pages/login_page.dart';
import 'package:guciano_flutter/providers/cart_provider.dart';
import 'package:guciano_flutter/providers/home_page_provider.dart';
import 'package:guciano_flutter/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe.
  Stripe.publishableKey = "pk_test_TYooMQauvdEDq54NiTphI7jx";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const MyApp(auth: false));
    } else {
      runApp(const MyApp(auth: true));
    }
  });
}

class MyApp extends StatelessWidget {
  final bool auth;

  const MyApp({Key? key, required this.auth}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => HomePageProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: MaterialApp(
          title: 'Guciano',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: auth ? const HomePage() : const LoginPage(),
          routes: routes,
        ),
      ),
    );
  }
}
