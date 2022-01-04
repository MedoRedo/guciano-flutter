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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
            width: 40,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor: theme.colorScheme.secondary,
              ),
              child: const Icon(
                Icons.remove,
                color: Colors.white,
              ),
              onPressed: (count == 0) ? null : decrement,
            )),
        SizedBox(
          width: 50,
          child: Text(
            count.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        SizedBox(
            width: 40,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor: theme.primaryColor,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: increment,
            )),
      ],
    );
  }
}
