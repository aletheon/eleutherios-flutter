// Manager permission managed by the policy owner e.g.
// - Edit Policy
// - Create Rule
// - Delete Rule
// - Add Manager
// - Remove Manager
// - Add Consumer
// - Remove Consumer

class ManagerPermission {
  final String permissionId;
  final String name;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ManagerPermission({
    required this.permissionId,
    required this.name,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ManagerPermission copyWith({
    String? permissionId,
    String? name,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ManagerPermission(
      permissionId: permissionId ?? this.permissionId,
      name: name ?? this.name,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'permissionId': permissionId,
      'name': name,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ManagerPermission.fromMap(Map<String, dynamic> map) {
    return ManagerPermission(
      permissionId: map['permissionId'] as String,
      name: map['name'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ManagerPermission(permissionId: $permissionId, name: $name, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ManagerPermission other) {
    if (identical(this, other)) return true;

    return other.permissionId == permissionId &&
        other.name == name &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return permissionId.hashCode ^
        name.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
