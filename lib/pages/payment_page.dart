import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';

class PaymentPage extends StatefulWidget {
  static String tag = 'payment-page';

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentMethodId = "null";
  String _errorMessage = "";
  final _stripePayment = FlutterStripePayment();
  var _isNativePayAvailable = false;

  @override
  void initState() {
    super.initState();
    _stripePayment.setStripeSettings(
        "pk_test_51KAlG9FOctDiDXCo0Eg1FSNfvAC6Bql8JRgVjkWP4YeEYxsOQ5d2CRHQWJBuP4cAg0sEwoKOkXqmGVIl70L48X0r00z5ygLppg",
        "{STRIPE_APPLE_PAY_MERCHANTID}");
    _stripePayment.onCancel = () {
      print("the payment form was cancelled");
    };
    checkIfAppleOrGooglePayIsAvailable();
  }

  void checkIfAppleOrGooglePayIsAvailable() async {
    var available = await _stripePayment.isNativePayAvailable();
    setState(() {
      _isNativePayAvailable = available;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stripe App Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _paymentMethodId != "null"
                  ? Text(
                      "Payment Method Returned is $_paymentMethodId",
                      textAlign: TextAlign.center,
                    )
                  : Container(
                      child: Text(_errorMessage),
                    ),
              ElevatedButton(
                child: Text("Create a Card Payment Method"),
                onPressed: () async {
                  var paymentResponse = await _stripePayment.addPaymentMethod();
                  setState(() {
                    if (paymentResponse.status ==
                        PaymentResponseStatus.succeeded) {
                      _paymentMethodId = paymentResponse.paymentMethodId!;
                    } else {
                      _errorMessage = paymentResponse.errorMessage!;
                    }
                  });
                },
              ),
              ElevatedButton(
                child: Text(
                    "Get ${Platform.isIOS ? "Apple" : Platform.isAndroid ? "Google" : Platform.isFuchsia ? "Fuchsia" : "Native"} Pay Token"),
                onPressed: !_isNativePayAvailable
                    ? null
                    : () async {
                        var paymentItem = PaymentItem(
                            label: 'Am Saed Shawerma', amount: 24.99);
                        var taxItem =
                            PaymentItem(label: 'Sales Tax', amount: 5.87);
                        var shippingItem =
                            PaymentItem(label: 'Shipping', amount: 5.99);
                        var stripeToken =
                            await _stripePayment.getPaymentMethodFromNativePay(
                                countryCode: "EG",
                                currencyCode: "EGP",
                                paymentNetworks: [
                                  PaymentNetwork.visa,
                                  PaymentNetwork.mastercard,
                                  PaymentNetwork.amex,
                                  PaymentNetwork.discover,
                                  PaymentNetwork.chinaUnionPay
                                ],
                                merchantName: "Am Saed",
                                isPending: false,
                                paymentItems: [
                                  paymentItem,
                                  shippingItem,
                                  taxItem
                                ]);
                        print(
                            "Stripe Payment Token from Apple Pay: $stripeToken");
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
}
