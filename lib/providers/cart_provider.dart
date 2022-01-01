import 'package:flutter/material.dart';
import 'package:guciano_flutter/database/database.dart';
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
  // Future<void> getDatabase() async {
  //   database =
  //       await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  // }

  Map<String, CartItem> cartItems = Map();
  late AppDatabase database;
  double totalPrice = 0;

  Future<void> getDatabase() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  CartProvider() {
    // getDatabase().then((value) {
    //   database = value;
    //   // var c1 = CartItem(
    //   //     id: "QB1YZpuLmaRyWB8QzOuU",
    //   //     name: 'chicken crepe',
    //   //     price: 30,
    //   //     count: 3,
    //   //     image: "https://storage.googleapis.com/bites-v1/7kcw67sr4.jpeg");
    //   // var c2 = CartItem(
    //   //     id: "QdklajfdhasnjkB1YZpuLmaRyWB8QzOuU",
    //   //     name: 'chicken crepe',
    //   //     price: 30,
    //   //     count: 2,
    //   //     image: "https://storage.googleapis.com/bites-v1/7kcw67sr4.jpeg");
    //   // addItem(c1);
    //   // addItem(c2);
    // });
  }

  Future<Map<String, CartItem>> getAllItems() async {
    await getDatabase();
    final cartItemDao = database.cartItemDao;

    totalPrice = 0;
    Map<String, CartItem> ret = new Map();
    List<CartItem> arr = await cartItemDao.findAllItems();
    for (var cartItem in arr) {
      ret[cartItem.id] = cartItem;
      totalPrice += cartItem.price * cartItem.count;
    }
    notifyListeners();
    // cartItems = ret;
    return cartItems;
  }

  Future<void> addItem(CartItem cartItem) async {
    cartItems[cartItem.id] = cartItem;
    totalPrice += cartItem.price;
    final cartItemDao = database.cartItemDao;
    await cartItemDao.insertItem(cartItem);
    notifyListeners();
  }

  Future<void> removeItem(id) async {
    CartItem? cartItem = cartItems[id];
    final cartItemDao = database.cartItemDao;
    await cartItemDao.deleteItem(cartItem!);
    cartItems.remove(id);
    totalPrice -= cartItems[id]!.count * cartItems[id]!.price;

    notifyListeners();
  }

  Future<void> incItem(id) async {
    cartItems[id]!.count++;
    totalPrice += cartItems[id]!.price;

    CartItem? cartItem = cartItems[id];
    final cartItemDao = database.cartItemDao;
    await cartItemDao.updateItem(cartItem!);
    notifyListeners();
  }

  Future<void> decItem(id) async {
    print(id);
    if (cartItems[id]!.count == 1) {
      removeItem(id);
    } else {
      totalPrice -= cartItems[id]!.price;
      cartItems[id]!.count--;
      CartItem? cartItem = cartItems[id];
      final cartItemDao = database.cartItemDao;
      await cartItemDao.updateItem(cartItem!);
    }
    notifyListeners();
  }

  // Future<void> getUserProfile() async {
  //   user = await _userRepo.getUserProfile();
  //   notifyListeners();
  // }
}
