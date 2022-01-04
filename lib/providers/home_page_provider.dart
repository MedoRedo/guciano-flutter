import 'package:flutter/cupertino.dart';

class HomePageProvider with ChangeNotifier {
  int selectedIndex = 0;

  void chooseTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
