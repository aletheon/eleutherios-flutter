import 'package:flutter/foundation.dart';

class RuleMember {
  final String ruleMemberId;
  final String ruleId;
  final String ruleUid;
  final String serviceId;
  final String serviceUid;
  final bool selected;
  final List<String> permissions;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  RuleMember({
    required this.ruleMemberId,
    required this.ruleId,
    required this.ruleUid,
    required this.serviceId,
    required this.serviceUid,
    required this.selected,
    required this.permissions,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  RuleMember copyWith({
    String? ruleMemberId,
    String? ruleId,
    String? ruleUid,
    String? serviceId,
    String? serviceUid,
    bool? selected,
    List<String>? permissions,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return RuleMember(
      ruleMemberId: ruleMemberId ?? this.ruleMemberId,
      ruleId: ruleId ?? this.ruleId,
      ruleUid: ruleUid ?? this.ruleUid,
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
      'ruleMemberId': ruleMemberId,
      'ruleId': ruleId,
      'ruleUid': ruleUid,
      'serviceId': serviceId,
      'serviceUid': serviceUid,
      'selected': selected,
      'permissions': permissions,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory RuleMember.fromMap(Map<String, dynamic> map) {
    return RuleMember(
      ruleMemberId: map['ruleMemberId'] as String,
      ruleId: map['ruleId'] as String,
      ruleUid: map['ruleUid'] as String,
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
    return 'RuleMember(ruleMemberId: $ruleMemberId, ruleId: $ruleId, ruleUid: $ruleUid, serviceId: $serviceId, serviceUid: $serviceUid, selected: $selected, permissions: $permissions, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant RuleMember other) {
    if (identical(this, other)) return true;

    return other.ruleMemberId == ruleMemberId &&
        other.ruleId == ruleId &&
        other.ruleUid == ruleUid &&
        other.serviceId == serviceId &&
        other.serviceUid == serviceUid &&
        other.selected == selected &&
        listEquals(other.permissions, permissions) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return ruleMemberId.hashCode ^
        ruleId.hashCode ^
        ruleUid.hashCode ^
        serviceId.hashCode ^
        serviceUid.hashCode ^
        selected.hashCode ^
        permissions.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
