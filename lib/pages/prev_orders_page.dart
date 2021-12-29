import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/order.dart';
import 'package:guciano_flutter/models/order_item.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';

class PrevOrdersPage extends StatefulWidget {
  static String tag = 'prev-orders-page';

  @override
  _PrevOrdersPageState createState() => _PrevOrdersPageState();
}

class _PrevOrdersPageState extends State<PrevOrdersPage> {
  late UserRepo userRepo;

  @override
  void initState() {
    userRepo = UserRepo();
    super.initState();
  }

  Widget getDeliveryOptionImage(Delivery delivery) {
    switch (delivery) {
      case Delivery.kiosk:
        return const Image(
          image: AssetImage("assets/ic_kiosk.png"),
          height: 24,
        );
      case Delivery.dorm:
        return const Image(
          image: AssetImage("assets/ic_dorm.png"),
          height: 24,
        );
    }
  }

  Widget getDeliveryOptionText(Delivery delivery) {
    switch (delivery) {
      case Delivery.kiosk:
        return const Text("Kiosk");
      case Delivery.dorm:
        return const Text("Dorm");
    }
  }

  Widget getPaymentOptionImage(Payment payment) {
    switch (payment) {
      case Payment.cash:
        return const Image(
          image: AssetImage("assets/ic_cash.png"),
          height: 24,
        );
      case Payment.creditCard:
        return const Image(
          image: AssetImage("assets/ic_credit_card.png"),
          height: 24,
        );
    }
  }

  Widget getPaymentOptionText(Payment payment) {
    switch (payment) {
      case Payment.cash:
        return const Text("Cash");
      case Payment.creditCard:
        return const Text("Credit Card");
    }
  }

  Widget getOrderStatusImage(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.inProgress:
        return const Image(
          image: AssetImage("assets/ic_cooking.png"),
          height: 24,
        );
      case OrderStatus.delivering:
        return const Image(
          image: AssetImage("assets/ic_delivery.png"),
          height: 24,
        );
      case OrderStatus.done:
        return const Image(
          image: AssetImage("assets/ic_done.png"),
          height: 24,
        );
    }
  }

  Widget getOrderStatusText(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.inProgress:
        return const Text("In Progress");
      case OrderStatus.delivering:
        return const Text("Delivering");
      case OrderStatus.done:
        return const Text("Done");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: userRepo.getPreviousOrders(),
        builder: (context, AsyncSnapshot<List<Order>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var orders = snapshot.data!.toList();
            orders.sort((order1, order2) =>
                order1.timeStamp.compareTo(order2.timeStamp));

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    Order order = orders[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: ExpansionTile(
                          title: Column(children: [
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Order ${order.orderNumber}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                          subtitle: Column(children: [
                            SizedBox(height: 8),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Image(
                                        image: AssetImage("assets/ic_time.png"),
                                        height: 24,
                                      ),
                                      SizedBox(width: 3),
                                      Text(order.getOrderTimestampFormatted())
                                    ],
                                  ),
                                  Text(
                                    "${order.totalPrice} EGP",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF19A15E)),
                                  ),
                                ]),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    getDeliveryOptionImage(
                                        order.deliveryOption),
                                    SizedBox(width: 3),
                                    getDeliveryOptionText(order.deliveryOption),
                                  ],
                                ),
                                Row(
                                  children: [
                                    getPaymentOptionImage(order.paymentOption),
                                    SizedBox(width: 3),
                                    getPaymentOptionText(order.paymentOption),
                                  ],
                                ),
                                Row(
                                  children: [
                                    getOrderStatusImage(order.orderStatus),
                                    SizedBox(width: 3),
                                    getOrderStatusText(order.orderStatus),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                          ]),
                          children: [
                            FutureBuilder(
                                future: userRepo.getOrderDetails(order.id),
                                builder: (context,
                                    AsyncSnapshot<List<OrderItem>> snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemCount: snapshot.data!.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          OrderItem orderItem =
                                              snapshot.data![index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 25.0,
                                                backgroundImage: NetworkImage(
                                                    orderItem.imgUrl),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                              title: Text(orderItem.name),
                                              subtitle: Text(
                                                  "${orderItem.price} EGP"),
                                              trailing: Text(
                                                  "×${orderItem.count}",
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      color:
                                                          Color(0xFF808080))),
                                            ),
                                          );
                                        });
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    print(snapshot.error.toString());
                                    return Center(
                                      child: Text("Error occurred."),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
