// database.dart

// required package imports
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/cart_item.dart';
import 'cart_item_dao.dart';

part '../database/database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [CartItem])
abstract class AppDatabase extends FloorDatabase {
  CartItemDao get cartItemDao;
}
