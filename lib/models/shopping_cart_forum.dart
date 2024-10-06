import 'package:flutter/foundation.dart';

class ShoppingCartForum {
  final String shoppingCartForumId; // primary key
  final String shoppingCartUserId; // foreign key
  final String uid; // owner of shopping cart forum (not the same as cartUid)
  final String cartUid; // owner of the cart
  final String
      forumId; // forum user has been given permission to add items to cart
  final List<String>
      members; // members (i.e. services) that will serve in this forum
  final List<String> services; // list of member services for redundancy sake
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCartForum({
    required this.shoppingCartForumId,
    required this.shoppingCartUserId,
    required this.uid,
    required this.cartUid,
    required this.forumId,
    required this.members,
    required this.services,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCartForum copyWith({
    String? shoppingCartForumId,
    String? shoppingCartUserId,
    String? uid,
    String? cartUid,
    String? forumId,
    List<String>? members,
    List<String>? services,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCartForum(
      shoppingCartForumId: shoppingCartForumId ?? this.shoppingCartForumId,
      shoppingCartUserId: shoppingCartUserId ?? this.shoppingCartUserId,
      uid: uid ?? this.uid,
      cartUid: cartUid ?? this.cartUid,
      forumId: forumId ?? this.forumId,
      members: members ?? this.members,
      services: services ?? this.services,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartForumId': shoppingCartForumId,
      'shoppingCartUserId': shoppingCartUserId,
      'uid': uid,
      'cartUid': cartUid,
      'forumId': forumId,
      'members': members,
      'services': services,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ShoppingCartForum.fromMap(Map<String, dynamic> map) {
    return ShoppingCartForum(
      shoppingCartForumId: map['shoppingCartForumId'] as String,
      shoppingCartUserId: map['shoppingCartUserId'] as String,
      uid: map['uid'] as String,
      cartUid: map['cartUid'] as String,
      forumId: map['forumId'] as String,
      members: List<String>.from(map['members']),
      services: List<String>.from(map['services']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ShoppingCartForum(shoppingCartForumId: $shoppingCartForumId, shoppingCartUserId: $shoppingCartUserId, uid: $uid, cartUid: $cartUid, forumId: $forumId, members: $members, services: $services, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCartForum other) {
    if (identical(this, other)) return true;

    return other.shoppingCartForumId == shoppingCartForumId &&
        other.shoppingCartUserId == shoppingCartUserId &&
        other.uid == uid &&
        other.cartUid == cartUid &&
        other.forumId == forumId &&
        listEquals(other.members, members) &&
        listEquals(other.services, services) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return shoppingCartForumId.hashCode ^
        shoppingCartUserId.hashCode ^
        uid.hashCode ^
        cartUid.hashCode ^
        forumId.hashCode ^
        members.hashCode ^
        services.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
