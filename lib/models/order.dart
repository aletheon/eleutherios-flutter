class Order {
  final String orderId;
  final String uid; // owner or superuser of this order
  final String paymentMethod; // e.g. Stripe, Paypal etc
  final String orderStatus;
  final DateTime orderDate;
  final double totalCost;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Order({
    required this.orderId,
    required this.uid,
    required this.paymentMethod,
    required this.orderStatus,
    required this.orderDate,
    required this.totalCost,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Order copyWith({
    String? orderId,
    String? uid,
    String? paymentMethod,
    String? shippingAddressId,
    String? billingAddressId,
    String? orderStatus,
    DateTime? orderDate,
    double? totalCost,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      uid: uid ?? this.uid,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      totalCost: totalCost ?? this.totalCost,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'uid': uid,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
      'orderDate': orderDate.millisecondsSinceEpoch,
      'totalCost': totalCost,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] as String,
      uid: map['uid'] as String,
      paymentMethod: map['paymentMethod'] as String,
      orderStatus: map['orderStatus'] as String,
      orderDate: DateTime.fromMillisecondsSinceEpoch(map['orderDate'] as int),
      totalCost: map['totalCost'] as double,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Order(orderId: $orderId, uid: $uid, paymentMethod: $paymentMethod, orderStatus: $orderStatus, orderDate: $orderDate, totalCost: $totalCost, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.uid == uid &&
        other.paymentMethod == paymentMethod &&
        other.orderStatus == orderStatus &&
        other.orderDate == orderDate &&
        other.totalCost == totalCost &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        uid.hashCode ^
        paymentMethod.hashCode ^
        orderStatus.hashCode ^
        orderDate.hashCode ^
        totalCost.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
