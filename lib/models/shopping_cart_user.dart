class ShoppingCartUser {
  final String shoppingCartUserId; // primary key
  final String uid;
  final String
      cartUid; // owner of the cart user has permission to add items too
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCartUser({
    required this.shoppingCartUserId,
    required this.uid,
    required this.cartUid,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCartUser copyWith({
    String? shoppingCartUserId,
    String? uid,
    String? cartUid,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCartUser(
      shoppingCartUserId: shoppingCartUserId ?? this.shoppingCartUserId,
      uid: uid ?? this.uid,
      cartUid: cartUid ?? this.cartUid,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartUserId': shoppingCartUserId,
      'uid': uid,
      'cartUid': cartUid,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ShoppingCartUser.fromMap(Map<String, dynamic> map) {
    return ShoppingCartUser(
      shoppingCartUserId: map['shoppingCartUserId'] as String,
      uid: map['uid'] as String,
      cartUid: map['cartUid'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ShoppingCartUser(shoppingCartUserId: $shoppingCartUserId, uid: $uid, cartUid: $cartUid, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCartUser other) {
    if (identical(this, other)) return true;

    return other.shoppingCartUserId == shoppingCartUserId &&
        other.uid == uid &&
        other.cartUid == cartUid &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return shoppingCartUserId.hashCode ^
        uid.hashCode ^
        cartUid.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
