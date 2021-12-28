class ProductItem {
  String imgPath;
  String name;
  int price;
  String itemId;
  ProductItem(
      {required this.imgPath,
      required this.name,
      required this.price,
      required this.itemId});

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
        imgPath: json['image'],
        name: json['name'],
        price: json['price'],
        itemId: json['id']);
  }
}
