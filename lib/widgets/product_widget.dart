import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/product_item.dart';
import 'package:guciano_flutter/pages/item_details_page.dart';
import 'package:guciano_flutter/utils/images.dart';

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
                description: "Experience the good taste.");
          }));
          //   Navigator.of(context).pushNamed('/AddIdeaRoute',arguments: );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Container(
              color: Colors.white10,
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage(
                    width: 65,
                    height: 65,
                    image: NetworkImage(widget.item.imgPath),
                    placeholder: const AssetImage(Images.placeholderImage),
                    imageErrorBuilder: (context, exception, stackTrace) {
                      return Image.asset(
                        Images.placeholderImage,
                        width: 50,
                        height: 50,
                      );
                    },
                    fit: BoxFit.cover,
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
                                fontWeight: FontWeight.w500,
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
