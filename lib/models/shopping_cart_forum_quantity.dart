class ShoppingCartForumQuantity {
  final String shoppingCartId;
  final String uid; // owner or superuser of this shopping cart
  final String forumId;
  final int quantity;
  ShoppingCartForumQuantity({
    required this.shoppingCartId,
    required this.uid,
    required this.forumId,
    required this.quantity,
  });

  ShoppingCartForumQuantity copyWith({
    String? shoppingCartId,
    String? uid,
    String? forumId,
    int? quantity,
  }) {
    return ShoppingCartForumQuantity(
      shoppingCartId: shoppingCartId ?? this.shoppingCartId,
      uid: uid ?? this.uid,
      forumId: forumId ?? this.forumId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartId': shoppingCartId,
      'uid': uid,
      'forumId': forumId,
      'quantity': quantity,
    };
  }

  factory ShoppingCartForumQuantity.fromMap(Map<String, dynamic> map) {
    return ShoppingCartForumQuantity(
      shoppingCartId: map['shoppingCartId'] as String,
      uid: map['uid'] as String,
      forumId: map['forumId'] as String,
      quantity: map['quantity'] as int,
    );
  }

  @override
  String toString() =>
      'ShoppingCartForumQuantity(shoppingCartId: $shoppingCartId, uid: $uid, forumId: $forumId, quantity: $quantity)';

  @override
  bool operator ==(covariant ShoppingCartForumQuantity other) {
    if (identical(this, other)) return true;

    return other.shoppingCartId == shoppingCartId &&
        other.uid == uid &&
        other.forumId == forumId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode =>
      shoppingCartId.hashCode ^
      uid.hashCode ^
      forumId.hashCode ^
      quantity.hashCode;
}
