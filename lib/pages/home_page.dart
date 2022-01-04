import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/navigation_page.dart';
import 'package:guciano_flutter/pages/menu_page.dart';
import 'package:guciano_flutter/pages/prev_orders_page.dart';
import 'package:guciano_flutter/pages/profile_page.dart';
import 'package:guciano_flutter/providers/home_page_provider.dart';
import 'package:guciano_flutter/utils/local_notification_service.dart';
import 'package:guciano_flutter/utils/tokens.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<NavigationPage> navigationPages = [
    NavigationPage(title: 'Guciano', widget: const MenuPage()),
    NavigationPage(title: 'My Orders', widget: const PrevOrdersPage()),
    NavigationPage(title: 'Cart', widget: const CartPage()),
    NavigationPage(title: 'Profile', widget: const ProfilePage()),
  ];

  @override
  void initState() {
    LocalNotificationService.initialize(context);

    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });

    // Get the token each time the application loads
    // Save the initial token to the database
    FirebaseMessaging.instance
        .getToken()
        .then((token) => saveTokenToDatabase(token!));

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context);
    int _selectedIndex = provider.selectedIndex;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text(navigationPages[_selectedIndex].title),
      ),
      body: Center(child: navigationPages[_selectedIndex].widget),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: provider.chooseTap,
        selectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
