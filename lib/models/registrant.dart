import 'package:flutter/foundation.dart';

class Registrant {
  final String registrantId;
  final String forumId;
  final String forumUid;
  final String serviceId;
  final String serviceUid;
  final bool selected;
  final List<String> permissions;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Registrant({
    required this.registrantId,
    required this.forumId,
    required this.forumUid,
    required this.serviceId,
    required this.serviceUid,
    required this.selected,
    required this.permissions,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Registrant copyWith({
    String? registrantId,
    String? forumId,
    String? forumUid,
    String? serviceId,
    String? serviceUid,
    bool? selected,
    List<String>? permissions,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Registrant(
      registrantId: registrantId ?? this.registrantId,
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
      'registrantId': registrantId,
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

  factory Registrant.fromMap(Map<String, dynamic> map) {
    return Registrant(
      registrantId: map['registrantId'] as String,
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
    return 'Registrant(registrantId: $registrantId, forumId: $forumId, forumUid: $forumUid, serviceId: $serviceId, serviceUid: $serviceUid, selected: $selected, permissions: $permissions, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Registrant other) {
    if (identical(this, other)) return true;

    return other.registrantId == registrantId &&
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
    return registrantId.hashCode ^
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
