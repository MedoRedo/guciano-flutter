import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/cart_item.dart';
import 'package:guciano_flutter/providers/cart_provider.dart';
import 'package:guciano_flutter/utils/images.dart';
import 'package:guciano_flutter/widgets/counter_widget.dart';
import 'package:provider/provider.dart';

class ItemDetailsPage extends StatefulWidget {
  static String tag = "item-page";
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final String description;
  final String id;

  const ItemDetailsPage({
    Key? key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.description,
  }) : super(key: key);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  int count = 1;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      if (count > 1) count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      FadeInImage(
        width: double.infinity,
        height: 350,
        image: NetworkImage(widget.imageUrl),
        placeholder: const AssetImage(Images.placeholderImage),
        imageErrorBuilder: (context, exception, stackTrace) {
          return Image.asset(
            Images.placeholderImage,
            height: 350,
          );
        },
        fit: BoxFit.cover,
      ),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow[700],
                  ),
                ),
                Text(
                  widget.rating.toString(),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Counter(
                    count: count, increment: increment, decrement: decrement),
                Text(
                  '${widget.price} EGP',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF19A15E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(widget.description),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  CartItem cartItem = CartItem(
                      id: widget.id,
                      name: widget.name,
                      price: widget.price,
                      count: count,
                      image: widget.imageUrl);
                  cartProvider.addItem(cartItem);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Item added to Cart"),
                  ));
                  Navigator.of(context).pop();
                },

                // Ahmed add to the cart
                // add to provider here
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ])),
    ]));
  }
}
