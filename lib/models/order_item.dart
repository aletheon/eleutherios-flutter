class OrderItem {
  final String orderItemId;
  final String orderId; // foreign key reference to order
  final String
      serviceId; // foreign key reference to service or item being purchased
  final int quantity;
  final double priceAtPurchase;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  OrderItem({
    required this.orderItemId,
    required this.orderId,
    required this.serviceId,
    required this.quantity,
    required this.priceAtPurchase,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  OrderItem copyWith({
    String? orderItemId,
    String? orderId,
    String? serviceId,
    int? quantity,
    double? priceAtPurchase,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return OrderItem(
      orderItemId: orderItemId ?? this.orderItemId,
      orderId: orderId ?? this.orderId,
      serviceId: serviceId ?? this.serviceId,
      quantity: quantity ?? this.quantity,
      priceAtPurchase: priceAtPurchase ?? this.priceAtPurchase,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderItemId': orderItemId,
      'orderId': orderId,
      'serviceId': serviceId,
      'quantity': quantity,
      'priceAtPurchase': priceAtPurchase,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      orderItemId: map['orderItemId'] as String,
      orderId: map['orderId'] as String,
      serviceId: map['serviceId'] as String,
      quantity: map['quantity'] as int,
      priceAtPurchase: map['priceAtPurchase'] as double,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'OrderItem(orderItemId: $orderItemId, orderId: $orderId, serviceId: $serviceId, quantity: $quantity, priceAtPurchase: $priceAtPurchase, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant OrderItem other) {
    if (identical(this, other)) return true;

    return other.orderItemId == orderItemId &&
        other.orderId == orderId &&
        other.serviceId == serviceId &&
        other.quantity == quantity &&
        other.priceAtPurchase == priceAtPurchase &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return orderItemId.hashCode ^
        orderId.hashCode ^
        serviceId.hashCode ^
        quantity.hashCode ^
        priceAtPurchase.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
