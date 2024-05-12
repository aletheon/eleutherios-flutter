// A forum that the currently logged in user is serving in
class ForumActivity {
  final String forumActivityId;
  final String uid;
  final String forumId;
  final String forumUid;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  ForumActivity({
    required this.forumActivityId,
    required this.uid,
    required this.forumId,
    required this.forumUid,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  ForumActivity copyWith({
    String? forumActivityId,
    String? uid,
    String? forumId,
    String? forumUid,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return ForumActivity(
      forumActivityId: forumActivityId ?? this.forumActivityId,
      uid: uid ?? this.uid,
      forumId: forumId ?? this.forumId,
      forumUid: forumUid ?? this.forumUid,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forumActivityId': forumActivityId,
      'uid': uid,
      'forumId': forumId,
      'forumUid': forumUid,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory ForumActivity.fromMap(Map<String, dynamic> map) {
    return ForumActivity(
      forumActivityId: map['forumActivityId'] as String,
      uid: map['uid'] as String,
      forumId: map['forumId'] as String,
      forumUid: map['forumUid'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'ForumActivity(forumActivityId: $forumActivityId, uid: $uid, forumId: $forumId, forumUid: $forumUid, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant ForumActivity other) {
    if (identical(this, other)) return true;

    return other.forumActivityId == forumActivityId &&
        other.uid == uid &&
        other.forumId == forumId &&
        other.forumUid == forumUid &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return forumActivityId.hashCode ^
        uid.hashCode ^
        forumId.hashCode ^
        forumUid.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
