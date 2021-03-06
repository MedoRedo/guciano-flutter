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

  final TextEditingController notesController = TextEditingController();

  late Future<UserProfile> data;
  CardFieldInputDetails? _card;

  static const double bottomSheetHeight = 192.0;

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

  void proceedWithOrder(
      Delivery delivery, Payment payment, num usedBalance, String notes) async {
    if (payment == Payment.cash) {
      placeOrder(delivery, payment, usedBalance, notes);
    } else {
      if (_card?.complete == true) {
        payViaCard(context, delivery, payment, usedBalance, notes);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter missing card details."),
        ));
        return;
      }
    }

    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 16),
              child: const Text("Payment under process")),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void placeOrder(
      Delivery delivery, Payment payment, num usedBalance, String notes) async {
    var cartItems = await cartProvider.getAllItems();
    if (kDebugMode) {
      print(cartItems);
    }
    List<CartItem> cartItemsList = [];
    cartItems.forEach((key, value) {
      cartItemsList.add(value);
    });

    userRepo
        .placeOrder(cartItemsList, _deliveryMethod!, _paymentMethod!,
            usedBalance, notes)
        .then((value) async {
      if (value == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Created order successfully."),
        ));

        await cartProvider.deleteAllItems();

        // Go to previous orders page.
        homeProvider.selectTab(1);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to create order. Please try again."),
        ));

        // Close the progress dialog.
        Navigator.pop(context);
      }
    });
  }

  payViaCard(BuildContext context, Delivery delivery, Payment payment,
      num usedBalance, String notes) async {
    // Place the order on success.
    placeOrder(delivery, payment, usedBalance, notes);
  }

  Widget getPaymentSummary(UserProfile user) {
    num subtotal = cartProvider.totalPrice;
    num deliveryFees = _deliveryMethod == Delivery.dorm ? 20 : 0;
    num totalPrice = subtotal + deliveryFees;

    num usedBalance = (user.availableBalance <= totalPrice)
        ? user.availableBalance
        : totalPrice;
    totalPrice -= usedBalance;

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
                controller: notesController,
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
                    children: const [
                      Text(
                        "Subtotal",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Delivery Fees",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Used Balance",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$subtotal EGP",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$deliveryFees EGP",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$usedBalance EGP",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalPrice EGP",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: const Text(
                      "Place Order",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      proceedWithOrder(_deliveryMethod!, _paymentMethod!,
                          usedBalance, notesController.value.text);
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
                  Visibility(
                      visible: _paymentMethod == Payment.creditCard,
                      child: CardField(onCardChanged: (card) {
                        _card = card;
                      })),
                  const SizedBox(height: 16.0),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text("Available Balance: ${user.availableBalance} EGP"),
                  const SizedBox(height: 6.0),
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
