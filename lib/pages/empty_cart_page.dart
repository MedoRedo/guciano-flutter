import 'package:flutter/material.dart';
import 'package:guciano_flutter/utils/images.dart';

class EmptyCartPage extends StatelessWidget {
  const EmptyCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: 250,
        child: Image.asset(Images.emptyCart),
      ),
      const SizedBox(height: 40),
      const SizedBox(
        width: double.infinity,
        child: Text(
          "Oh-oh! Cart is empty.",
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 40)
    ]);
  }
}
