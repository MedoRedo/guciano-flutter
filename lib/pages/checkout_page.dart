import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:guciano_flutter/models/cart_item.dart';
import 'package:guciano_flutter/models/order.dart';
import 'package:guciano_flutter/models/user_profile.dart';
import 'package:guciano_flutter/providers/cart_provider.dart';
import 'package:guciano_flutter/providers/home_page_provider.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';
import 'package:guciano_flutter/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  static String tag = 'checkout-page';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider cartProvider;
  late HomePageProvider homeProvider;
  final userRepo = UserRepo();

  Delivery? _deliveryMethod = Delivery.kiosk;
  Payment? _paymentMethod = Payment.cash;

  late Future<UserProfile> data;

  CardFieldInputDetails? _card;

  static const double bottomSheetHeight = 150.0;

  @override
  void initState() {
    data = userRepo.getUserProfile();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartProvider = Provider.of<CartProvider>(context);
    homeProvider = Provider.of<HomePageProvider>(context);
  }

  void placeOrder(Delivery delivery, Payment payment) async {
    // place order here ....
    final paymentMethod = await Stripe.instance
        .createPaymentMethod(const PaymentMethodParams.card());
    // stripe.Stripe.instance.confirmPayment(paymentIntentClientSecret, data)

    var cartItems = await cartProvider.getAllItems();
    if (kDebugMode) {
      print(cartItems);
    }
    List<CartItem> cartItemsList = [];
    cartItems.forEach((key, value) {
      cartItemsList.add(value);
    });

    userRepo
        .placeOrder(cartItemsList, _deliveryMethod!, _paymentMethod!)
        .then((value) {
      // Go to previous orders page.
      homeProvider.selectTab(2);
      Navigator.pop(context);
    });
  }

  // payViaNewCard(BuildContext context) async {
  //   CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
  //   // ProgressDialog dialog = new ProgressDialog(context);
  //   // dialog.style(message: 'Please wait...');
  //   // await dialog.show();
  //   var response = await StripeService.payWithNewCard(amount: cartProvider.totalPrice.toString(), currency: 'USD');
  //   // await dialog.hide();
  //   Scaffold.of(context).showSnackBar(SnackBar(
  //     content: Text(response.message),
  //     duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
  //   ));
  // }

  Widget getPaymentSummary(UserProfile user) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
        child: Container(
            height: bottomSheetHeight,
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              TextField(
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  hintText: "Extra Notes",
                  prefixIcon: Icon(
                    Icons.edit,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        _deliveryMethod == Delivery.dorm
                            ? (cartProvider.totalPrice +
                                    20 -
                                    user.availableBalance)
                                .toString()
                            : (cartProvider.totalPrice - user.availableBalance)
                                .toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      const Text(
                        "Delivery to dorms charges 20 EGP",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    child: const Text(
                      "Place Order",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      placeOrder(_deliveryMethod!, _paymentMethod!);
                    },
                  ),
                ],
              )
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: data,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScreen();
        }
        UserProfile user = snapshot.data!;

        return Scaffold(
            appBar: AppBar(
              elevation: 0.1,
              title: const Text("Checkout"),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.fromLTRB(16.0, 0, 16.0, bottomSheetHeight),
              child: ListView(
                children: [
                  const SizedBox(height: 16.0),
                  const Text("Pickup Method",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 16.0),
                  RadioListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pickup at Kiosk'),
                        Image.asset(
                          "assets/ic_kiosk.png",
                          width: 40,
                          height: 40,
                        )
                      ],
                    ),
                    contentPadding: EdgeInsets.zero,
                    value: Delivery.kiosk,
                    groupValue: _deliveryMethod,
                    onChanged: (Delivery? value) {
                      setState(() {
                        _deliveryMethod = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery to Dorm (20 EGP)'),
                        Image.asset(
                          "assets/ic_dorm.png",
                          width: 40,
                          height: 40,
                        )
                      ],
                    ),
                    contentPadding: EdgeInsets.zero,
                    value: Delivery.dorm,
                    groupValue: _deliveryMethod,
                    onChanged: (Delivery? value) {
                      setState(() {
                        _deliveryMethod = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Payment Method",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 16.0),
                  RadioListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cash'),
                        Image.asset(
                          "assets/ic_cash.png",
                          width: 40,
                          height: 40,
                        )
                      ],
                    ),
                    contentPadding: EdgeInsets.zero,
                    value: Payment.cash,
                    groupValue: _paymentMethod,
                    onChanged: (Payment? value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Debit / Credit Card'),
                        Image.asset(
                          "assets/ic_credit_card.png",
                          width: 40,
                          height: 40,
                        )
                      ],
                    ),
                    contentPadding: EdgeInsets.zero,
                    value: Payment.creditCard,
                    groupValue: _paymentMethod,
                    onChanged: (Payment? value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _paymentMethod == Payment.creditCard
                      ? Column(
                          children: [
                            CardField(onCardChanged: (card) {
                              if (kDebugMode) {
                                print(card);
                              }
                            }),
                            const SizedBox(height: 16.0),
                          ],
                        )
                      : const SizedBox.shrink(),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Available Balance: ${user.availableBalance} EGP",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text("Address: Dorm ${user.dormId}"),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            bottomSheet: getPaymentSummary(user));
      },
    );
  }
}
