// A forum that the currently logged in user is serving in
class Activity {
  final String activityId;
  final String activityType;
  final String uid;
  final String policyForumId;
  final String policyForumUid;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Activity({
    required this.activityId,
    required this.activityType,
    required this.uid,
    required this.policyForumId,
    required this.policyForumUid,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Activity copyWith({
    String? activityId,
    String? activityType,
    String? uid,
    String? policyForumId,
    String? policyForumUid,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Activity(
      activityId: activityId ?? this.activityId,
      activityType: activityType ?? this.activityType,
      uid: uid ?? this.uid,
      policyForumId: policyForumId ?? this.policyForumId,
      policyForumUid: policyForumUid ?? this.policyForumUid,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activityId': activityId,
      'activityType': activityType,
      'uid': uid,
      'policyForumId': policyForumId,
      'policyForumUid': policyForumUid,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      activityId: map['activityId'] as String,
      activityType: map['activityType'] as String,
      uid: map['uid'] as String,
      policyForumId: map['policyForumId'] as String,
      policyForumUid: map['policyForumUid'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Activity(activityId: $activityId, activityType: $activityType, uid: $uid, policyForumId: $policyForumId, policyForumUid: $policyForumUid, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Activity other) {
    if (identical(this, other)) return true;

    return other.activityId == activityId &&
        other.activityType == activityType &&
        other.uid == uid &&
        other.policyForumId == policyForumId &&
        other.policyForumUid == policyForumUid &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return activityId.hashCode ^
        activityType.hashCode ^
        uid.hashCode ^
        policyForumId.hashCode ^
        policyForumUid.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
