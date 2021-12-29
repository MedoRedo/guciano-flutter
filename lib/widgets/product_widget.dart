import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/product_item.dart';

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
      onTap: () {},
      child: Container(
        color: Colors.white10,
        child: Row(
          children: [
            Container(
              height: 65.0,
              width: 65.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Text(
                      widget.item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("details")
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
