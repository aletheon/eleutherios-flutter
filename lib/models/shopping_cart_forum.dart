import 'package:flutter/foundation.dart';

class ShoppingCartForum {
  final String shoppingCartForumId; // primary key
  final String shoppingCartUserId; // foreign key
  final String
      forumId; // forum user has been given permission to add items to cart
  final List<String>
      members; // potential members (i.e. services) that will serve in this rule
  final List<String> services; // copy of member services for redundancy sake

  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCartForum({
    required this.shoppingCartForumId,
    required this.shoppingCartUserId,
    required this.forumId,
    required this.members,
    required this.services,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCartForum copyWith({
    String? shoppingCartForumId,
    String? shoppingCartUserId,
    String? forumId,
    List<String>? members,
    List<String>? services,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCartForum(
      shoppingCartForumId: shoppingCartForumId ?? this.shoppingCartForumId,
      shoppingCartUserId: shoppingCartUserId ?? this.shoppingCartUserId,
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
    return 'ShoppingCartForum(shoppingCartForumId: $shoppingCartForumId, shoppingCartUserId: $shoppingCartUserId, forumId: $forumId, members: $members, services: $services, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCartForum other) {
    if (identical(this, other)) return true;

    return other.shoppingCartForumId == shoppingCartForumId &&
        other.shoppingCartUserId == shoppingCartUserId &&
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
        forumId.hashCode ^
        members.hashCode ^
        services.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
