class Category {
  String imgPath;
  String name;
  String categoryId;
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        imgPath: json['image'], name: json['name'], categoryId: json['id']);
  }
  Category(
      {required this.imgPath, required this.name, required this.categoryId});
}
