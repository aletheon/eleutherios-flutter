import 'package:flutter/foundation.dart';

class Manager {
  final String managerId;
  final String policyId;
  final String policyUid;
  final String serviceId;
  final String serviceUid;
  final bool selected;
  final List<String> permissions;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Manager({
    required this.managerId,
    required this.policyId,
    required this.policyUid,
    required this.serviceId,
    required this.serviceUid,
    required this.selected,
    required this.permissions,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Manager copyWith({
    String? managerId,
    String? policyId,
    String? policyUid,
    String? serviceId,
    String? serviceUid,
    bool? selected,
    List<String>? permissions,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Manager(
      managerId: managerId ?? this.managerId,
      policyId: policyId ?? this.policyId,
      policyUid: policyUid ?? this.policyUid,
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
      'managerId': managerId,
      'policyId': policyId,
      'policyUid': policyUid,
      'serviceId': serviceId,
      'serviceUid': serviceUid,
      'selected': selected,
      'permissions': permissions,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Manager.fromMap(Map<String, dynamic> map) {
    return Manager(
      managerId: map['managerId'] as String,
      policyId: map['policyId'] as String,
      policyUid: map['policyUid'] as String,
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
    return 'Manager(managerId: $managerId, policyId: $policyId, policyUid: $policyUid, serviceId: $serviceId, serviceUid: $serviceUid, selected: $selected, permissions: $permissions, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Manager other) {
    if (identical(this, other)) return true;

    return other.managerId == managerId &&
        other.policyId == policyId &&
        other.policyUid == policyUid &&
        other.serviceId == serviceId &&
        other.serviceUid == serviceUid &&
        other.selected == selected &&
        listEquals(other.permissions, permissions) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return managerId.hashCode ^
        policyId.hashCode ^
        policyUid.hashCode ^
        serviceId.hashCode ^
        serviceUid.hashCode ^
        selected.hashCode ^
        permissions.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
