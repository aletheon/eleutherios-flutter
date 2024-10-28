class ShoppingCartServiceQuantity {
  final String shoppingCartId;
  final String uid; // owner or superuser of this shopping cart
  final String forumId;
  final String serviceId;
  final int quantity;
  ShoppingCartServiceQuantity({
    required this.shoppingCartId,
    required this.uid,
    required this.forumId,
    required this.serviceId,
    required this.quantity,
  });

  ShoppingCartServiceQuantity copyWith({
    String? shoppingCartId,
    String? uid,
    String? forumId,
    String? serviceId,
    int? quantity,
  }) {
    return ShoppingCartServiceQuantity(
      shoppingCartId: shoppingCartId ?? this.shoppingCartId,
      uid: uid ?? this.uid,
      forumId: forumId ?? this.forumId,
      serviceId: serviceId ?? this.serviceId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartId': shoppingCartId,
      'uid': uid,
      'forumId': forumId,
      'serviceId': serviceId,
      'quantity': quantity,
    };
  }

  factory ShoppingCartServiceQuantity.fromMap(Map<String, dynamic> map) {
    return ShoppingCartServiceQuantity(
      shoppingCartId: map['shoppingCartId'] as String,
      uid: map['uid'] as String,
      forumId: map['forumId'] as String,
      serviceId: map['serviceId'] as String,
      quantity: map['quantity'] as int,
    );
  }

  @override
  String toString() {
    return 'ShoppingCartServiceQuantity(shoppingCartId: $shoppingCartId, uid: $uid, forumId: $forumId, serviceId: $serviceId, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant ShoppingCartServiceQuantity other) {
    if (identical(this, other)) return true;

    return other.shoppingCartId == shoppingCartId &&
        other.uid == uid &&
        other.forumId == forumId &&
        other.serviceId == serviceId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return shoppingCartId.hashCode ^
        uid.hashCode ^
        forumId.hashCode ^
        serviceId.hashCode ^
        quantity.hashCode;
  }
}
