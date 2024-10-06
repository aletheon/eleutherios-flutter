class ShoppingCartMember {
  final String shoppingCartMemberId; // primary key
  final String shoppingCartForumId; // foreign key
  final String forumId;
  final String
      memberId; // member user has been given permission to add items to cart
  final String serviceId;
  final String serviceUid;
  final bool selected;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ShoppingCartMember({
    required this.shoppingCartMemberId,
    required this.shoppingCartForumId,
    required this.forumId,
    required this.memberId,
    required this.serviceId,
    required this.serviceUid,
    required this.selected,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ShoppingCartMember copyWith({
    String? shoppingCartMemberId,
    String? shoppingCartForumId,
    String? forumId,
    String? memberId,
    String? serviceId,
    String? serviceUid,
    bool? selected,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ShoppingCartMember(
      shoppingCartMemberId: shoppingCartMemberId ?? this.shoppingCartMemberId,
      shoppingCartForumId: shoppingCartForumId ?? this.shoppingCartForumId,
      forumId: forumId ?? this.forumId,
      memberId: memberId ?? this.memberId,
      serviceId: serviceId ?? this.serviceId,
      serviceUid: serviceUid ?? this.serviceUid,
      selected: selected ?? this.selected,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shoppingCartMemberId': shoppingCartMemberId,
      'shoppingCartForumId': shoppingCartForumId,
      'forumId': forumId,
      'memberId': memberId,
      'serviceId': serviceId,
      'serviceUid': serviceUid,
      'selected': selected,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ShoppingCartMember.fromMap(Map<String, dynamic> map) {
    return ShoppingCartMember(
      shoppingCartMemberId: map['shoppingCartMemberId'] as String,
      shoppingCartForumId: map['shoppingCartForumId'] as String,
      forumId: map['forumId'] as String,
      memberId: map['memberId'] as String,
      serviceId: map['serviceId'] as String,
      serviceUid: map['serviceUid'] as String,
      selected: map['selected'] as bool,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ShoppingCartMember(shoppingCartMemberId: $shoppingCartMemberId, shoppingCartForumId: $shoppingCartForumId, memberId: $memberId, forumId: $forumId, serviceId: $serviceId, serviceUid: $serviceUid, selected: $selected, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ShoppingCartMember other) {
    if (identical(this, other)) return true;

    return other.shoppingCartMemberId == shoppingCartMemberId &&
        other.shoppingCartForumId == shoppingCartForumId &&
        other.forumId == forumId &&
        other.memberId == memberId &&
        other.serviceId == serviceId &&
        other.serviceUid == serviceUid &&
        other.selected == selected &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return shoppingCartMemberId.hashCode ^
        shoppingCartForumId.hashCode ^
        forumId.hashCode ^
        memberId.hashCode ^
        serviceId.hashCode ^
        serviceUid.hashCode ^
        selected.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
