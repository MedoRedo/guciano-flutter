import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/category.dart';

class catListItem extends StatefulWidget {
  const catListItem({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  _catListItemState createState() => _catListItemState();
}

class _catListItemState extends State<catListItem>
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
      padding: const EdgeInsets.only(top: 16, right: 16),
      color: Colors.white10,
      height: 40,
      child: Row(
        children: [
          Column(
            children: [
              Text(
                cat.name,
              ),
              CircleAvatar(
                  radius: 34, backgroundImage: NetworkImage(cat.imgPath)),
            ],
          ),
        ],
      ),
    );
  }
}
