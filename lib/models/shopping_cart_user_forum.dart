class ShoppingCartUserForum {
  final String
      shoppingCartUserForumId; // combined key of UserId and ForumId e.g. USERID-12345_FORUMID-67890
  final String forumId; // forum this cart is associated to
  final String forumUid; // owner or superuser of the forum
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCartUserForum({
    required this.shoppingCartUserForumId,
    required this.forumId,
    required this.forumUid,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCartUserForum copyWith({
    String? shoppingCartUserForumId,
    String? forumId,
    String? forumUid,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCartUserForum(
      shoppingCartUserForumId:
          shoppingCartUserForumId ?? this.shoppingCartUserForumId,
      forumId: forumId ?? this.forumId,
      forumUid: forumUid ?? this.forumUid,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartUserForumId': shoppingCartUserForumId,
      'forumId': forumId,
      'forumUid': forumUid,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ShoppingCartUserForum.fromMap(Map<String, dynamic> map) {
    return ShoppingCartUserForum(
      shoppingCartUserForumId: map['shoppingCartUserForumId'] as String,
      forumId: map['forumId'] as String,
      forumUid: map['forumUid'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ShoppingCartUserForum(shoppingCartUserForumId: $shoppingCartUserForumId, forumId: $forumId, forumUid: $forumUid, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCartUserForum other) {
    if (identical(this, other)) return true;

    return other.shoppingCartUserForumId == shoppingCartUserForumId &&
        other.forumId == forumId &&
        other.forumUid == forumUid &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return shoppingCartUserForumId.hashCode ^
        forumId.hashCode ^
        forumUid.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
