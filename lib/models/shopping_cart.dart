import 'package:flutter/foundation.dart';

class ShoppingCart {
  final String shoppingCartId;
  final String uid; // owner or superuser of this shopping cart
  final List<String> services; // copy of item services for redundancy sake
  final List<String> items; // items (i.e. services) stored in this cart
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCart({
    required this.shoppingCartId,
    required this.uid,
    required this.services,
    required this.items,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCart copyWith({
    String? shoppingCartId,
    String? uid,
    List<String>? services,
    List<String>? items,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCart(
      shoppingCartId: shoppingCartId ?? this.shoppingCartId,
      uid: uid ?? this.uid,
      services: services ?? this.services,
      items: items ?? this.items,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartId': shoppingCartId,
      'uid': uid,
      'services': services,
      'items': items,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ShoppingCart.fromMap(Map<String, dynamic> map) {
    return ShoppingCart(
      shoppingCartId: map['shoppingCartId'] as String,
      uid: map['uid'] as String,
      services: List<String>.from(map['services']),
      items: List<String>.from(map['items']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ShoppingCart(shoppingCartId: $shoppingCartId, uid: $uid, services: $services, items: $items, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCart other) {
    if (identical(this, other)) return true;

    return other.shoppingCartId == shoppingCartId &&
        other.uid == uid &&
        listEquals(other.services, services) &&
        listEquals(other.items, items) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return shoppingCartId.hashCode ^
        uid.hashCode ^
        services.hashCode ^
        items.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
