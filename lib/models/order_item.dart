class OrderItem {
  String id;
  int count;
  String imgUrl;
  String name;
  double price;

  OrderItem({
    required this.id,
    required this.count,
    required this.imgUrl,
    required this.name,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      count: json['count'],
      imgUrl: json['image'],
      name: json['name'],
      price: json['price'],
    );
  }
}
