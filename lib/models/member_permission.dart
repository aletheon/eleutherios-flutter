// Member permission managed by the forum owner e.g.
// - Edit Forum
// - Add Forum (implies adding sub-forum to forum)
// - Remove Forum (implies removing sub-forum from forum)
// - Add Member (implies adding a service to the forum)
// - Remove Member (implies removing service from forum)

class MemberPermission {
  final String permissionId;
  final String name;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  MemberPermission({
    required this.permissionId,
    required this.name,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  MemberPermission copyWith({
    String? permissionId,
    String? name,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return MemberPermission(
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

  factory MemberPermission.fromMap(Map<String, dynamic> map) {
    return MemberPermission(
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
    return 'MemberPermission(permissionId: $permissionId, name: $name, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant MemberPermission other) {
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
