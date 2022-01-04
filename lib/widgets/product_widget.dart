import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/product_item.dart';
import 'package:guciano_flutter/pages/item_details_page.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key, required this.item}) : super(key: key);
  final ProductItem item;

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          //  Navigator.of(context).pushNamed(ItemDetailsPage.tag);
          Navigator.of(context).push(MaterialPageRoute(builder: (ctxDummy) {
            ProductItem item = widget.item;
            return ItemDetailsPage(
                id: item.itemId,
                name: item.name,
                imageUrl: item.imgPath,
                price: 1.0 * item.price,
                rating: double.parse(item.rating),
                description: "gameed awi");
          }));
          //   Navigator.of(context).pushNamed('/AddIdeaRoute',arguments: );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
              color: Colors.white10,
              child: Row(children: [
                Container(
                  height: 65.0,
                  width: 65.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(widget.item.imgPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                              ),
                            ),
                            Text(
                              widget.item.rating.substring(0, 3),
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                const Spacer(),
                Text(
                  "${(widget.item.price)} EGP".padRight(9),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF19A15E)),
                ),
              ])),
        ));
  }
}
