import 'package:flutter/foundation.dart';

class ShoppingCartForum {
  final String shoppingCartForumId; // primary key
  final String shoppingCartUserId; // foreign key
  final String
      forumId; // forum user has been given permission to add items to cart
  final List<String> services; // copy of member services for redundancy sake
  final List<String>
      members; // potential members (i.e. services) that will serve in this rule
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCartForum({
    required this.shoppingCartForumId,
    required this.shoppingCartUserId,
    required this.forumId,
    required this.services,
    required this.members,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCartForum copyWith({
    String? shoppingCartForumId,
    String? shoppingCartUserId,
    String? forumId,
    List<String>? services,
    List<String>? members,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCartForum(
      shoppingCartForumId: shoppingCartForumId ?? this.shoppingCartForumId,
      shoppingCartUserId: shoppingCartUserId ?? this.shoppingCartUserId,
      forumId: forumId ?? this.forumId,
      services: services ?? this.services,
      members: members ?? this.members,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartForumId': shoppingCartForumId,
      'shoppingCartUserId': shoppingCartUserId,
      'forumId': forumId,
      'services': services,
      'members': members,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ShoppingCartForum.fromMap(Map<String, dynamic> map) {
    return ShoppingCartForum(
      shoppingCartForumId: map['shoppingCartForumId'] as String,
      shoppingCartUserId: map['shoppingCartUserId'] as String,
      forumId: map['forumId'] as String,
      services: List<String>.from(map['services']),
      members: List<String>.from(map['members']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ShoppingCartForum(shoppingCartForumId: $shoppingCartForumId, shoppingCartUserId: $shoppingCartUserId, forumId: $forumId, services: $services, members: $members, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCartForum other) {
    if (identical(this, other)) return true;

    return other.shoppingCartForumId == shoppingCartForumId &&
        other.shoppingCartUserId == shoppingCartUserId &&
        other.forumId == forumId &&
        listEquals(other.services, services) &&
        listEquals(other.members, members) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return shoppingCartForumId.hashCode ^
        shoppingCartUserId.hashCode ^
        forumId.hashCode ^
        services.hashCode ^
        members.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
