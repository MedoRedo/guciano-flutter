import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guciano_flutter/assets/categories.dart';
import 'package:guciano_flutter/models/category.dart';
import 'package:guciano_flutter/models/product_item.dart';
import 'package:guciano_flutter/repositories/categories_repo.dart';
import 'package:guciano_flutter/widgets/loadingScreen.dart';

import '../widgets/catListItem.dart';
import '../widgets/listItem.dart';

class Menu extends StatefulWidget {
  // final List<Category> catList;

  const Menu({
    Key? key,
  }) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _initialized = false;
  bool _error = false;

  late List<Category> cat;
  late List<ProductItem> items;
  late Category currCat;
  void getCategories() async {
    try {
      cat = await CategoriesRepo().getCategories();
      currCat = cat[0];
      items = await CategoriesRepo().getCategoryItems(currCat.categoryId);
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void getItems(catId) async {
    items = await CategoriesRepo().getCategoryItems(catId);
  }

  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Categories",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          Expanded(
              child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: cat.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            currCat = cat[index];
                            getItems(currCat.categoryId);
                          });
                        },
                        child: catListItem(
                          category: cat[index],
                        ));
                  })),
          Text(
            currCat.name,
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Expanded(
            flex: 4,
            child: FutureBuilder<List<ProductItem>>(
              future: CategoriesRepo().getCategoryItems(currCat.categoryId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ProductItem>> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {},
                            child: listItem(
                              item: items[index],
                            ));
                      });
                }

                return LoadingScreen();
              },
            ),
          ),
        ]));
  }
}
