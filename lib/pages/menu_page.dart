import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/category.dart';
import 'package:guciano_flutter/models/product_item.dart';
import 'package:guciano_flutter/repositories/categories_repo.dart';
import 'package:guciano_flutter/widgets/loading_screen.dart';

import '../widgets/category_widget.dart';
import '../widgets/product_widget.dart';

class MenuPage extends StatefulWidget {
  // final List<Category> catList;

  const MenuPage({
    Key? key,
  }) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _initialized = false;
  bool _error = false;

  late List<Category> cat;
  late List<ProductItem> items;
  late Category currCat;

  CategoriesRepo categoriesRepo = CategoriesRepo();

  Future<void> getCategories() async {
    try {
      cat = await categoriesRepo.getCategories();
      currCat = cat[0];
      getItems(currCat.categoryId);
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
    items = await categoriesRepo.getCategoryItems(catId);
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_initialized
        ? LoadingScreen()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Categories",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                        clipBehavior: Clip.none,
                        physics: const BouncingScrollPhysics(),
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
                              child: CategoryWidget(
                                category: cat[index],
                              ));
                        }))),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currCat.name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                )),
            Expanded(
              flex: 4,
              child: FutureBuilder<List<ProductItem>>(
                future: categoriesRepo.getCategoryItems(currCat.categoryId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProductItem>> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong.");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductWidget(
                            item: items[index],
                          );
                        });
                  }

                  return LoadingScreen();
                },
              ),
            ),
          ]);
  }
}
