import 'package:flutter/material.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({Key? key}) : super(key: key);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final url = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.network(
            url,
            color: Colors.black38,
            colorBlendMode: BlendMode.darken,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
