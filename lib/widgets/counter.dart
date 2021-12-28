import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final int count;
  final VoidCallback increment, decrement;

  const Counter({
    Key? key,
    required this.count,
    required this.increment,
    required this.decrement,
  }) : super(key: key);

  void add() {}
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.remove),
          color: Colors.black,
          onPressed: (count == 0) ? null : decrement,
        ),
        Container(
          color: primaryColor,
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 3.0,
            horizontal: 12.0,
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          color: primaryColor,
          onPressed: increment,
        ),
      ],
    );
  }
}
