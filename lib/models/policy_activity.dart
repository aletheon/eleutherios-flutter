// A policy that the currently logged in user is serving in
class PolicyActivity {
  final String policyActivityId;
  final String uid;
  final String policyId;
  final String policyUid;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  PolicyActivity({
    required this.policyActivityId,
    required this.uid,
    required this.policyId,
    required this.policyUid,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  PolicyActivity copyWith({
    String? policyActivityId,
    String? uid,
    String? policyId,
    String? policyUid,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return PolicyActivity(
      policyActivityId: policyActivityId ?? this.policyActivityId,
      uid: uid ?? this.uid,
      policyId: policyId ?? this.policyId,
      policyUid: policyUid ?? this.policyUid,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'policyActivityId': policyActivityId,
      'uid': uid,
      'policyId': policyId,
      'policyUid': policyUid,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory PolicyActivity.fromMap(Map<String, dynamic> map) {
    return PolicyActivity(
      policyActivityId: map['policyActivityId'] as String,
      uid: map['uid'] as String,
      policyId: map['policyId'] as String,
      policyUid: map['policyUid'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'PolicyActivity(policyActivityId: $policyActivityId, uid: $uid, policyId: $policyId, policyUid: $policyUid, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant PolicyActivity other) {
    if (identical(this, other)) return true;

    return other.policyActivityId == policyActivityId &&
        other.uid == uid &&
        other.policyId == policyId &&
        other.policyUid == policyUid &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return policyActivityId.hashCode ^
        uid.hashCode ^
        policyId.hashCode ^
        policyUid.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
