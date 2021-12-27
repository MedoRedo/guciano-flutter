import 'package:floor/floor.dart';

@entity
class CartItem {
  @primaryKey
  String id;

  String name;

  double price;

  int count;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.count,
  });
}
