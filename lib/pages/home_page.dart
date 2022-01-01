import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/navigation_page.dart';
import 'package:guciano_flutter/pages/menu_page.dart';
import 'package:guciano_flutter/pages/prev_orders_page.dart';
import 'package:guciano_flutter/pages/profile_page.dart';
import 'package:guciano_flutter/utils/local_notification_service.dart';
import 'package:guciano_flutter/utils/tokens.dart';

import 'cart_page.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<NavigationPage> navigationPages = [
    NavigationPage(title: 'Guciano', widget: MenuPage()),
    NavigationPage(title: 'My Orders', widget: PrevOrdersPage()),
    NavigationPage(title: 'Cart', widget: CartPage()),
    NavigationPage(title: 'Profile', widget: ProfilePage()),
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
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
