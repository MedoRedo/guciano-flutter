import 'package:flutter/material.dart';

import 'package:floor/floor.dart';

@entity
class CartItem {
  @primaryKey
  String id;

  String name;

  double price;

  int count;

  String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.count,
    required this.image,
  });
}

@dao
abstract class CartItemDao {
  @Query('SELECT * FROM CartItem')
  Future<List<CartItem>> findAllItems();

  @Query('SELECT * FROM CartItem WHERE id = :id')
  Future<CartItem?> findItemById(int id);

  @insert
  Future<void> insertItem(CartItem item);

  @Query('DELETE FROM CartItem')
  Future<void> deleteAllItems();

  @update
  Future<int> updateItem(CartItem item);

  @delete
  Future<int> deleteItem(CartItem item);
}
