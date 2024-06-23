class ShoppingCart {
  final String shoppingCartId;
  final String uid; // owner or superuser of this shopping cart
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCart({
    required this.shoppingCartId,
    required this.uid,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCart copyWith({
    String? shoppingCartId,
    String? uid,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCart(
      shoppingCartId: shoppingCartId ?? this.shoppingCartId,
      uid: uid ?? this.uid,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartId': shoppingCartId,
      'uid': uid,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ShoppingCart.fromMap(Map<String, dynamic> map) {
    return ShoppingCart(
      shoppingCartId: map['shoppingCartId'] as String,
      uid: map['uid'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ShoppingCart(shoppingCartId: $shoppingCartId, uid: $uid, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCart other) {
    if (identical(this, other)) return true;

    return other.shoppingCartId == shoppingCartId &&
        other.uid == uid &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return shoppingCartId.hashCode ^
        uid.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
