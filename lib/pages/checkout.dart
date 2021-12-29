import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/cart_item.dart';
import 'package:guciano_flutter/models/user_profile.dart';
import 'package:guciano_flutter/pages/home_page.dart';
import 'package:guciano_flutter/providers/CartProvider.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  static String tag = 'checkout-page';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final authRepo;
  late final userRepo;

  late Future<UserProfile> data;

  @override
  void initState() {
    userRepo = UserRepo();
    data = userRepo.getUserProfile();
    super.initState();
  }

  void placeOrder() {
    // place order here ....
    Navigator.of(context).pushNamed(HomePage.tag);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return FutureBuilder<UserProfile>(
      future: data,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        UserProfile user = snapshot.data!;

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 130),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Shipping Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(
                    //     Icons.edit,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 10.0),
                ListTile(
                  title: Text(
                    user.name,
                    style: TextStyle(
//                    fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: Text("Your dorm is : " + user.dormId.toString()),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Payment Method",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Card(
                    elevation: 4.0,
                    child: Text("Hussien add you payment here")),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          bottomSheet: Card(
            elevation: 4.0,
            child: Container(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Coupon Code",
                          prefixIcon: Icon(
                            Icons.redeem,
                            color: Theme.of(context).accentColor,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        maxLines: 1,
                        // controller: _couponlControl,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              cartProvider.totalPrice.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            Text(
                              "Delivery charges included",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                        width: 150.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.cyan,
                        ),
                        child: TextButton(
                          child: Text(
                            "Place Order",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            placeOrder();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              height: 130,
            ),
          ),
        );
      },
    );
  }
}
