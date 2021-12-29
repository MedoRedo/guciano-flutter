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
  // List<CartItem> cartItems = [
  //   CartItem(
  //       id: "0",
  //       name: 'Coffee',
  //       price: 30,
  //       count: 3,
  //       image:
  //           "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_small_cup_of_coffee.JPG/1200px-A_small_cup_of_coffee.JPG"),
  //   CartItem(
  //       id: "0",
  //       name: 'Coffee',
  //       price: 30,
  //       count: 3,
  //       image:
  //           "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_small_cup_of_coffee.JPG/1200px-A_small_cup_of_coffee.JPG")
  // ];

  Map<String, CartItem> cartItems = {
    'QB1YZpuLmaRyWB8QzOuU': CartItem(
        id: "QB1YZpuLmaRyWB8QzOuU",
        name: 'chicken crepe',
        price: 30,
        count: 3,
        image: "https://storage.googleapis.com/bites-v1/7kcw67sr4.jpeg"),
    'QB1YZpuLmaRyWBddd8QzOuU': CartItem(
        id: "QB1YZpuLmaRyWBddd8QzOuU",
        name: 'chicken crepe',
        price: 30,
        count: 6,
        image: "https://storage.googleapis.com/bites-v1/7kcw67sr4.jpeg"),
    'QB1YZpuLdddmaRyWB8QzOuU': CartItem(
        id: "QB1YZpuLdddmaRyWB8QzOuU",
        name: 'chicken crepe',
        price: 30,
        count: 1,
        image: "https://storage.googleapis.com/bites-v1/7kcw67sr4.jpeg")
  };

  double totalPrice = 10;
  // cartItems['QB1YZpuLmaRyWB8QzOuU'] = CartItem(
  //       id: "QB1YZpuLmaRyWB8QzOuU",
  //       name: 'chicken crepe',
  //       price: 30,
  //       count: 3,
  //       image:
  //           "https://storage.googleapis.com/bites-v1/7kcw67sr4.jpeg");
  void addItem(CartItem cartItem) {
    cartItems[cartItem.id] = cartItem;
    totalPrice += cartItem.price;
    notifyListeners();
  }

  Map<String, CartItem> getAllItems() {
    return cartItems;
  }

  void removeItem(id) {
    cartItems.remove(id);
    totalPrice -= cartItems[id]!.count * cartItems[id]!.price;
    notifyListeners();
  }

  void incItem(id) {
    cartItems[id]!.count++;
    totalPrice += cartItems[id]!.price;
    print(id);
    notifyListeners();
  }

  void decItem(id) {
    if (cartItems[id]!.count == 1)
      removeItem(id);
    else
      cartItems[id]!.count--;
    totalPrice -= cartItems[id]!.price;
    notifyListeners();
  }

  // Future<void> getUserProfile() async {
  //   user = await _userRepo.getUserProfile();
  //   notifyListeners();
  // }
}
