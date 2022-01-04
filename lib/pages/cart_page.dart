import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/cart_item.dart';
import 'package:guciano_flutter/pages/checkout_page.dart';
import 'package:guciano_flutter/pages/empty_cart_page.dart';
import 'package:guciano_flutter/providers/cart_provider.dart';
import 'package:guciano_flutter/providers/home_page_provider.dart';
import 'package:guciano_flutter/utils/images.dart';
import 'package:guciano_flutter/widgets/counter_widget.dart';
import 'package:guciano_flutter/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  static String tag = 'cart-page';

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartProvider cartProvider;
  late HomePageProvider homeProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartProvider = Provider.of<CartProvider>(context);
    homeProvider = Provider.of<HomePageProvider>(context);
  }

  Widget renderAddList() {
    return FutureBuilder<Map<String, CartItem>>(
        future: cartProvider.getAllItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LoadingScreen();
          var cartItems = snapshot.data!;
          var keys = cartItems.keys.toList();

          if (keys.isEmpty) return const EmptyCartPage();
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                height: 16,
                color: Colors.transparent,
              );
            },
            primary: false,
            shrinkWrap: true,
            itemCount: keys.length,
            itemBuilder: (BuildContext context, int index) {
              CartItem? cartItem = cartItems[keys[index]];
              return Hero(
                tag: 'detail_food$index',
                child: Card(
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage(
                          width: 50,
                          height: 50,
                          image: NetworkImage(cartItem!.image),
                          placeholder:
                              const AssetImage(Images.placeholderImage),
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cartItem.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      cartProvider.removeItem(cartItem.id);
                                    },
                                  ),
                                ],
                              ),
                              Row(children: [
                                Text(
                                  '${cartItem.price * cartItem.count} EGP',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF19A15E)),
                                ),
                                const Spacer(),
                                Counter(
                                    count: cartItem.count,
                                    increment: () {
                                      cartProvider.incItem(cartItem.id);
                                    },
                                    decrement: () {
                                      cartProvider.decItem(cartItem.id);
                                    }),
                                const SizedBox(width: 16)
                              ])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget getNonEmptyCartButtons() {
    return Row(children: [
      Expanded(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.cyan),
        onPressed: () {
          homeProvider.selectTab(0);
        },
        child: const Text('Add Items', style: TextStyle(color: Colors.white)),
      )),
      const SizedBox(width: 16),
      Expanded(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.green),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CheckoutPage()));
        },
        child: const Text('Checkout', style: TextStyle(color: Colors.white)),
      ))
    ]);
  }

  Widget getEmptyCartButtons() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.cyan),
          onPressed: () {
            homeProvider.selectTab(0);
          },
          child: const Text('Add Items', style: TextStyle(color: Colors.white)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: renderAddList(),
        ),
        bottomSheet: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0)),
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: cartProvider.cartItems.isNotEmpty
                    ? getNonEmptyCartButtons()
                    : getEmptyCartButtons())));
  }
}
