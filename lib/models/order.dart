class Order {
  String id;
  Delivery deliveryOption;
  Payment paymentOption;
  int itemsCount;
  DateTime timeStamp;
  num totalPrice;

  Order({
    required this.id,
    required this.deliveryOption,
    required this.paymentOption,
    required this.itemsCount,
    required this.timeStamp,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      deliveryOption:
          json['delivery_option'] == 'dorm' ? Delivery.dorm : Delivery.kiosk,
      paymentOption: json['payment_option'] == 'credit_card'
          ? Payment.creditCard
          : Payment.cash,
      itemsCount: json['items_count'],
      timeStamp: DateTime.parse(json['timestamp'].toDate().toString()),
      totalPrice: double.parse((json['total_price'].toString())),
    );
  }
}

enum Delivery { dorm, kiosk }

enum Payment { cash, creditCard }
