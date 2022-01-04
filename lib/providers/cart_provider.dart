import 'package:flutter/material.dart';
import 'package:guciano_flutter/database/database.dart';
import 'package:guciano_flutter/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> cartItems = {};
  late AppDatabase database;
  bool _initializedDB = false;
  double _totalPrice = 0;

  double get totalPrice => _totalPrice;

  Future<void> getDatabase() async {
    if (!_initializedDB) {
      database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      _initializedDB = true;
    }
  }

  Future<Map<String, CartItem>> getAllItems() async {
    await getDatabase();
    final cartItemDao = database.cartItemDao;

    _totalPrice = 0;
    Map<String, CartItem> ret = {};
    List<CartItem> arr = await cartItemDao.findAllItems();
    for (var cartItem in arr) {
      ret[cartItem.id] = cartItem;
      _totalPrice += cartItem.price * cartItem.count;
    }
    cartItems = ret;
    notifyListeners();
    return cartItems;
  }

  Future<void> deleteAllItems() async {
    cartItems = {};
    _totalPrice = 0;
    final cartItemDao = database.cartItemDao;
    await cartItemDao.deleteAllItems();
    notifyListeners();
  }

  Future<void> addItem(CartItem cartItem) async {
    await getDatabase();
    String id = cartItem.id;
    if (cartItems[id] != null) {
      cartItem.count = cartItem.count + cartItems[id]!.count;
      await removeItem(id);
      await addItem(cartItem);
    } else {
      cartItems[cartItem.id] = cartItem;
      print(cartItem.price);
      _totalPrice += cartItem.price * cartItem.count;
      final cartItemDao = database.cartItemDao;
      await cartItemDao.insertItem(cartItem);
    }
    notifyListeners();
  }

  Future<void> removeItem(id) async {
    CartItem? cartItem = cartItems[id];
    _totalPrice -= cartItems[id]!.count * cartItems[id]!.price;
    cartItems.remove(id);
    final cartItemDao = database.cartItemDao;
    await cartItemDao.deleteItem(cartItem!);

    notifyListeners();
  }

  // Future<void> updateItem(cartItem) async {
  //   String id = cartItem.id;
  //   cartItems[id] = id;
  //   _totalPrice += cartItems[id]!.price;

  //   CartItem? cartItem = cartItems[id];
  //   final cartItemDao = database.cartItemDao;
  //   await cartItemDao.updateItem(cartItem!);
  //   notifyListeners();
  // }

  Future<void> incItem(id) async {
    cartItems[id]!.count++;
    _totalPrice += cartItems[id]!.price;

    CartItem? cartItem = cartItems[id];
    final cartItemDao = database.cartItemDao;
    await cartItemDao.updateItem(cartItem!);
    notifyListeners();
  }

  Future<void> decItem(id) async {
    if (cartItems[id]!.count == 1) {
      await removeItem(id);
    } else {
      _totalPrice -= cartItems[id]!.price;
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
