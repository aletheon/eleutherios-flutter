class Category {
  final String categoryId;
  final String uid; // owner or superuser of category
  final String name;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Category({
    required this.categoryId,
    required this.uid,
    required this.name,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Category copyWith({
    String? categoryId,
    String? uid,
    String? name,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'uid': uid,
      'name': name,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'] as String,
      uid: map['uid'] as String,
      name: map['name'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Category(categoryId: $categoryId, uid: $uid, name: $name, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.categoryId == categoryId &&
        other.uid == uid &&
        other.name == name &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return categoryId.hashCode ^
        uid.hashCode ^
        name.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
