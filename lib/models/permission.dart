// Forum permission managed by the forum owner e.g.
// - Edit Forum
// - Add Service (implies adding other services to forum)
// - Create Service (implies remove own service)
// - Delete Service (implies remove other services serving in forum)
// - Create Forum (implies remove own forum)
// - Delete Forum (implies remove other service forums)
// - Create Post (implies delete own post)
// - Delete Post (implies delete other services posts)

class Permission {
  final String permissionId;
  final String name;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Permission({
    required this.permissionId,
    required this.name,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Permission copyWith({
    String? permissionId,
    String? name,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Permission(
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

  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(
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
    return 'Permission(permissionId: $permissionId, name: $name, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Permission other) {
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
