import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/order.dart';
import 'package:guciano_flutter/models/order_item.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';

class PrevOrders extends StatefulWidget {
  static String tag = 'prev-orders-page';

  @override
  _PrevOrdersState createState() => _PrevOrdersState();
}

class _PrevOrdersState extends State<PrevOrders> {
  late UserRepo ur;

  @override
  void initState() {
    ur = UserRepo(userId: FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text("Previous Orders"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      ),
      body: FutureBuilder(
        future: UserRepo(userId: FirebaseAuth.instance.currentUser!.uid)
            .getPreviousOrders(),
        builder: (context, AsyncSnapshot<List<Order>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var orders = snapshot.data!.toList();
            orders.sort((order1, order2) =>
                order1.timeStamp.compareTo(order2.timeStamp));

            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    Order order = orders[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ExpansionTile(
                          leading: order.paymentOption == Payment.cash
                              ? Image(image: AssetImage("assets/ic_cash.png"))
                              : Image(
                                  image:
                                      AssetImage("assets/ic_credit_card.png")),
                          trailing: order.deliveryOption == Delivery.dorm
                              ? Image(image: AssetImage("assets/ic_dorm.png"))
                              : Image(image: AssetImage("assets/ic_kiosk.png")),
                          title: Text("Order ${order.orderNumber}"),
                          subtitle: Text(
                              "Total Price ${order.totalPrice} EGP\nOrdered at ${order.timeStamp.year}/${order.timeStamp.month}/${order.timeStamp.day} ${order.timeStamp.hour}:${order.timeStamp.minute}"),
                          children: [
                            FutureBuilder(
                                future: ur.getOrderDetails(order.id),
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
