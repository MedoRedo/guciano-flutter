import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/category.dart';
import 'package:guciano_flutter/utils/images.dart';

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
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: FadeInImage(
                  width: 70,
                  height: 70,
                  image: NetworkImage(cat.imgPath),
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
