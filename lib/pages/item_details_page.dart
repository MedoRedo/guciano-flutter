import 'package:flutter/material.dart';
import 'package:guciano_flutter/widgets/counter_widget.dart';

class ItemDetailsPage extends StatefulWidget {
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final String description;

  const ItemDetailsPage({
    Key? key,
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
  int count = 0;
  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      if (count > 0) count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.imageUrl,
            color: Colors.black38,
            colorBlendMode: BlendMode.darken,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Icon(
                  Icons.star,
                  color: Colors.yellow[700],
                ),
              ),
              Text(
                widget.rating.toString(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Counter(
                    count: count, increment: increment, decrement: decrement),
                Text(
                  'L.E. ${widget.price}',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.description),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart),
              label: Text('Add to Cart'),
            ),
          )
        ],
      ),
    );
  }
}
