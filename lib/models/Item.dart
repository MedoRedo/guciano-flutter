class Item {
  String imgPath;
  String name;
  int price;
  String itemId;
  double rating;
  int ratingNum;
  Item(
      {required this.imgPath,
      required this.name,
      required this.price,
      required this.itemId,
      required this.rating,
      required this.ratingNum});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        imgPath: json['image'],
        name: json['name'],
        price: json['price'],
        itemId: json['id'],
        rating: json['rating'] == null ? 5 : json['rating'],
        ratingNum: json['ratingNum'] == null ? 0 : json['ratingNum']);
  }
}
