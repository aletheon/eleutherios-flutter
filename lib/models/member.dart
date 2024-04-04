import 'package:flutter/foundation.dart';

class Member {
  final String memberId;
  final String forumId;
  final String forumUid;
  final String serviceId;
  final String serviceUid;
  final bool selected;
  final List<String> permissions;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Member({
    required this.memberId,
    required this.forumId,
    required this.forumUid,
    required this.serviceId,
    required this.serviceUid,
    required this.selected,
    required this.permissions,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Member copyWith({
    String? memberId,
    String? forumId, // forum this member is associated to
    String? forumUid, // owner or superuser of the forum
    String? serviceId, // service associated to this member
    String? serviceUid, // owner or superuser of the service
    bool? selected,
    List<String>? permissions,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Member(
      memberId: memberId ?? this.memberId,
      forumId: forumId ?? this.forumId,
      forumUid: forumUid ?? this.forumUid,
      serviceId: serviceId ?? this.serviceId,
      serviceUid: serviceUid ?? this.serviceUid,
      selected: selected ?? this.selected,
      permissions: permissions ?? this.permissions,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'memberId': memberId,
      'forumId': forumId,
      'forumUid': forumUid,
      'serviceId': serviceId,
      'serviceUid': serviceUid,
      'selected': selected,
      'permissions': permissions,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      memberId: map['memberId'] as String,
      forumId: map['forumId'] as String,
      forumUid: map['forumUid'] as String,
      serviceId: map['serviceId'] as String,
      serviceUid: map['serviceUid'] as String,
      selected: map['selected'] as bool,
      permissions: List<String>.from(map['permissions']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Member(memberId: $memberId, forumId: $forumId, forumUid: $forumUid, serviceId: $serviceId, serviceUid: $serviceUid, selected: $selected, permissions: $permissions, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Member other) {
    if (identical(this, other)) return true;

    return other.memberId == memberId &&
        other.forumId == forumId &&
        other.forumUid == forumUid &&
        other.serviceId == serviceId &&
        other.serviceUid == serviceUid &&
        other.selected == selected &&
        listEquals(other.permissions, permissions) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return memberId.hashCode ^
        forumId.hashCode ^
        forumUid.hashCode ^
        serviceId.hashCode ^
        serviceUid.hashCode ^
        selected.hashCode ^
        permissions.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
