class Item {
  String imgPath;
  String name;
  int price;
  String itemId;
  Item(
      {required this.imgPath,
      required this.name,
      required this.price,
      required this.itemId});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        imgPath: json['image'],
        name: json['name'],
        price: json['price'],
        itemId: json['id']);
  }
}
