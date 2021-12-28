class Order {
  String id;
  int orderNumber;
  Delivery deliveryOption;
  Payment paymentOption;
  OrderStatus orderStatus;
  int itemsCount;
  DateTime timeStamp;
  num totalPrice;

  Order({
    required this.id,
    required this.orderNumber,
    required this.deliveryOption,
    required this.paymentOption,
    required this.orderStatus,
    required this.itemsCount,
    required this.timeStamp,
    required this.totalPrice,
  });

  static OrderStatus mapToOrderStatus(String orderStatus) {
    switch (orderStatus) {
      case 'in_progress':
        return OrderStatus.inProgress;
      case 'delivering':
        return OrderStatus.delivering;
      case 'done':
        return OrderStatus.done;
      default:
        throw UnsupportedError('$orderStatus is unsupported.');
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['order_number'],
      deliveryOption:
          json['delivery_option'] == 'dorm' ? Delivery.dorm : Delivery.kiosk,
      paymentOption: json['payment_option'] == 'credit_card'
          ? Payment.creditCard
          : Payment.cash,
      orderStatus: mapToOrderStatus(json['order_status']),
      itemsCount: json['items_count'],
      timeStamp: DateTime.parse(json['timestamp'].toDate().toString()),
      totalPrice: double.parse((json['total_price'].toString())),
    );
  }
}

enum Delivery { dorm, kiosk }

enum Payment { cash, creditCard }

enum OrderStatus { inProgress, delivering, done }
