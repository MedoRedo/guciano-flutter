import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/cart_item.dart';
import 'package:guciano_flutter/providers/CartProvider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static String tag = 'Cart-page';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  void deleteItem(index) {
    print("Item should be deleted " + index.toString());
  }

  void incItem(index) {
    print("Item should be incremented " + index.toString());
  }

  void decItem(index) {
    print("Item should be decremented " + index.toString());
  }

  Widget renderAddList(cartItems) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (BuildContext context, int index) {
        CartItem oneItem = cartItems[index];
        Color primaryColor = Theme.of(context).primaryColor;
        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            // if you wanna go to item details
            onTap: () {},
            child: Hero(
              tag: 'detail_food$index',
              child: Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(oneItem.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(oneItem.name),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    deleteItem(index);
                                  },
                                ),
                              ],
                            ),
                            Text('\$${oneItem.price}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  color: Colors.black,
                                  onPressed: () {
                                    decItem(index);
                                  },
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
                                    oneItem.count.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  color: primaryColor,
                                  onPressed: () {
                                    incItem(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.getAllItems();

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Order Cart'),
        ),
        body: Container(
          height: size.height * 0.20 * cartItems.length,
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: this.renderAddList(cartItems),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 35.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.cyan,
                ),
                child: Text(
                  'CHECKOUT',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
