class Tag {
  final String tagId;
  final String uid;
  final String tag;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Tag({
    required this.tagId,
    required this.uid,
    required this.tag,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Tag copyWith({
    String? tagId,
    String? uid,
    String? tag,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Tag(
      tagId: tagId ?? this.tagId,
      uid: uid ?? this.uid,
      tag: tag ?? this.tag,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tagId': tagId,
      'uid': uid,
      'tag': tag,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      tagId: map['tagId'] as String,
      uid: map['uid'] as String,
      tag: map['tag'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Tag(tagId: $tagId, uid: $uid, tag: $tag, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Tag other) {
    if (identical(this, other)) return true;

    return other.tagId == tagId &&
        other.uid == uid &&
        other.tag == tag &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return tagId.hashCode ^
        uid.hashCode ^
        tag.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
