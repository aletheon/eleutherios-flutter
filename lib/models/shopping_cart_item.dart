class ShoppingCartItem {
  final String shoppingCartItemId;
  final String shoppingCartId; // shopping cart this item belongs to
  final String shoppingCartUid; // owner or superuser of the shopping cart
  final String
      forumId; // forum this service is associated to or being added from
  final String forumUid; // owner or superuser of the forum
  final String memberId; // member adding item to cart
  final String memberUid;
  final String serviceId; // service being added to cart
  final String serviceUid;
  final int quantity; // number of these service items added to cart
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCartItem({
    required this.shoppingCartItemId,
    required this.shoppingCartId,
    required this.shoppingCartUid,
    required this.forumId,
    required this.forumUid,
    required this.memberId,
    required this.memberUid,
    required this.serviceId,
    required this.serviceUid,
    required this.quantity,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCartItem copyWith({
    String? shoppingCartItemId,
    String? shoppingCartId,
    String? shoppingCartUid,
    String? forumId,
    String? forumUid,
    String? memberId,
    String? memberUid,
    String? serviceId,
    String? serviceUid,
    int? quantity,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCartItem(
      shoppingCartItemId: shoppingCartItemId ?? this.shoppingCartItemId,
      shoppingCartId: shoppingCartId ?? this.shoppingCartId,
      shoppingCartUid: shoppingCartUid ?? this.shoppingCartUid,
      forumId: forumId ?? this.forumId,
      forumUid: forumUid ?? this.forumUid,
      memberId: memberId ?? this.memberId,
      memberUid: memberUid ?? this.memberUid,
      serviceId: serviceId ?? this.serviceId,
      serviceUid: serviceUid ?? this.serviceUid,
      quantity: quantity ?? this.quantity,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartItemId': shoppingCartItemId,
      'shoppingCartId': shoppingCartId,
      'shoppingCartUid': shoppingCartUid,
      'forumId': forumId,
      'forumUid': forumUid,
      'memberId': memberId,
      'memberUid': memberUid,
      'serviceId': serviceId,
      'serviceUid': serviceUid,
      'quantity': quantity,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ShoppingCartItem.fromMap(Map<String, dynamic> map) {
    return ShoppingCartItem(
      shoppingCartItemId: map['shoppingCartItemId'] as String,
      shoppingCartId: map['shoppingCartId'] as String,
      shoppingCartUid: map['shoppingCartUid'] as String,
      forumId: map['forumId'] as String,
      forumUid: map['forumUid'] as String,
      memberId: map['memberId'] as String,
      memberUid: map['memberUid'] as String,
      serviceId: map['serviceId'] as String,
      serviceUid: map['serviceUid'] as String,
      quantity: map['quantity'] as int,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ShoppingCartItem(shoppingCartItemId: $shoppingCartItemId, shoppingCartId: $shoppingCartId, shoppingCartUid: $shoppingCartUid, forumId: $forumId, forumUid: $forumUid, memberId: $memberId, memberUid: $memberUid, serviceId: $serviceId, serviceUid: $serviceUid, quantity: $quantity, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCartItem other) {
    if (identical(this, other)) return true;

    return other.shoppingCartItemId == shoppingCartItemId &&
        other.shoppingCartId == shoppingCartId &&
        other.shoppingCartUid == shoppingCartUid &&
        other.forumId == forumId &&
        other.forumUid == forumUid &&
        other.memberId == memberId &&
        other.memberUid == memberUid &&
        other.serviceId == serviceId &&
        other.serviceUid == serviceUid &&
        other.quantity == quantity &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return shoppingCartItemId.hashCode ^
        shoppingCartId.hashCode ^
        shoppingCartUid.hashCode ^
        forumId.hashCode ^
        forumUid.hashCode ^
        memberId.hashCode ^
        memberUid.hashCode ^
        serviceId.hashCode ^
        serviceUid.hashCode ^
        quantity.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
