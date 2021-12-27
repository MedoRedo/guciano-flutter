import 'package:floor/floor.dart';
import 'package:guciano_flutter/models/cart_item.dart';

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
