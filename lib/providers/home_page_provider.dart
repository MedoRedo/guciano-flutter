import 'package:flutter/cupertino.dart';

class HomePageProvider with ChangeNotifier {
  int selectedIndex = 0;

  void selectTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
