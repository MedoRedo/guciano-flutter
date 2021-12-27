import 'package:flutter/cupertino.dart';
import 'package:guciano_flutter/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  // CartItem c1 = CartItem(
  //     id: "0",
  //     name: 'Coffee',
  //     price: 30,
  //     count: 3,
  //     image:
  //         "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_small_cup_of_coffee.JPG/1200px-A_small_cup_of_coffee.JPG");
  List<CartItem> cartItems = [
    CartItem(
        id: "0",
        name: 'Coffee',
        price: 30,
        count: 3,
        image:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_small_cup_of_coffee.JPG/1200px-A_small_cup_of_coffee.JPG"),
    CartItem(
        id: "0",
        name: 'Coffee',
        price: 30,
        count: 3,
        image:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_small_cup_of_coffee.JPG/1200px-A_small_cup_of_coffee.JPG")
  ];

  void addItem(cartItem) {
    cartItems.add(cartItem);
    notifyListeners();
  }

  List<CartItem> getAllItems() {
    return cartItems;
  }

  void removeItem() {
    // cartItems.remove()
  }

  // Future<void> getUserProfile() async {
  //   user = await _userRepo.getUserProfile();
  //   notifyListeners();
  // }
}
