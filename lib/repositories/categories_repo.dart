import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guciano_flutter/models/category.dart';
import 'package:guciano_flutter/models/product_item.dart';

class categories_repo {
  late final CollectionReference categories;
  categories_repo() {
    categories = FirebaseFirestore.instance.collection('categories');
  }

  Future<List<Category>> getCategories() async {
    List<Category> ans = [];
    QuerySnapshot querySnapshot = await categories.get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> category = doc.data() as Map<String, dynamic>;
      category['id'] = doc.id;
      ans.add(Category.fromJson(category));
    }
    return ans;
  }

  Future<List<Item>> getCategoryItems(categoryId) async {
    List<Item> ans = [];
    QuerySnapshot querySnapshot =
        await categories.doc(categoryId).collection('items').get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> item = doc.data() as Map<String, dynamic>;
      item['id'] = doc.id;
      ans.add(Item.fromJson(item));
    }
    return ans;
  }
}
