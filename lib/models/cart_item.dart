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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price * count,
      'count': count,
      'image': image,
    };
  }
}
