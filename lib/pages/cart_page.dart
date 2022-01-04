import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/cart_item.dart';
import 'package:guciano_flutter/pages/checkout_page.dart';
import 'package:guciano_flutter/pages/empty_cart_page.dart';
import 'package:guciano_flutter/providers/cart_provider.dart';
import 'package:guciano_flutter/providers/home_page_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  static String tag = 'cart-page';

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget renderAddList() {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return FutureBuilder<Map<String, CartItem>>(
        future: cartProvider.getAllItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var cartItems = snapshot.data!;
          var keys = cartItems.keys.toList();
          // return CircleAvatar();
          if (keys.isEmpty) return EmptyCartPage();
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: keys.length,
            itemBuilder: (BuildContext context, int index) {
              // CartItem oneItem = cartItems[keys[index]];
              CartItem? oneItem = cartItems[keys[index]];
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
                                image: NetworkImage(oneItem!.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(oneItem.name),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          cartProvider.removeItem(oneItem.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  Text('\$${oneItem.price * oneItem.count}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        color: Colors.black,
                                        onPressed: () {
                                          cartProvider.decItem(oneItem.id);
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
                                          cartProvider.incItem(oneItem.id);
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
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    final provider = Provider.of<HomePageProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10),
        child: Column(
          children: <Widget>[
            Text(
              "Items",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            renderAddList(),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            // padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
            width: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey,
            ),
            child: TextButton(
              child: Text(
                "Add Items".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                provider.chooseTap(0);
              },
            ),
          ),
          Container(
            // padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
            width: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.cyan,
            ),
            child: TextButton(
              child: Text(
                "Checkout".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CheckoutPage(totalPrice: cartProvider.totalPrice)));
              },
            ),
          ),
        ],
      ),
    );
  }
}

//         Container(
//           height: size.height * 0.20 * cartItems.length,
//           color: Colors.white,
//           padding: const EdgeInsets.all(10.0),
//           margin: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Column(
//             children: <Widget>[
//               Expanded(
//                 child: this.renderAddList(cartItems, cartProvider),
//               ),
//               Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 15.0,
//                     horizontal: 35.0,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     color: Colors.cyan,
//                   ),
//                   child: Row(
//                     children: [
//                       TextButton(
//                         onPressed: () {},
//                         child: Text(
//                           'Add more Items',
//                           style: TextStyle(
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       TextButton(
//                         style: ButtonStyle(
//                           foregroundColor:
//                               MaterialStateProperty.all<Color>(Colors.blue),
//                         ),
//                         onPressed: () {},
//                         child: Text(
//                           'CHECKOUT',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ))
//             ],
//           ),
//         ));
//   }
// }
