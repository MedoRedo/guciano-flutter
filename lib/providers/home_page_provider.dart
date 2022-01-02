import 'package:flutter/cupertino.dart';
import 'package:guciano_flutter/models/navigation_page.dart';

class HomePageProvider with ChangeNotifier {
  int selectedIndex = 0;

  void chooseTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
