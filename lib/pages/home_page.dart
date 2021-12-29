import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/navigation_page.dart';
import 'package:guciano_flutter/pages/MenuScreen.dart';
import 'package:guciano_flutter/pages/prev_orders_page.dart';
import 'package:guciano_flutter/pages/profile_page.dart';

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

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<NavigationPage> navigationPages = [
    NavigationPage(
      title: 'Guciano',
      widget: Menu(),
      //  style: optionStyle,
      //   )
    ),
    NavigationPage(title: 'My Orders', widget: PrevOrdersPage()),
    NavigationPage(
        title: 'Cart',
        widget: const Text(
          'Cart',
          style: optionStyle,
        )),
    NavigationPage(title: 'Profile', widget: ProfilePage()),
  ];

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
