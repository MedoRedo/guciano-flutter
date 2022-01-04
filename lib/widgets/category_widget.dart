import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/category.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget>
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
    Category cat = widget.category;
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      color: Colors.white10,
      height: 40,
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                  radius: 34, backgroundImage: NetworkImage(cat.imgPath)),
              const SizedBox(height: 6),
              Text(
                cat.name,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
