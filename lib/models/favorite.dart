// A service that a user has liked
class Favorite {
  final String favoriteId;
  final String uid;
  final String serviceId;
  final String serviceUid;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Favorite({
    required this.favoriteId,
    required this.uid,
    required this.serviceId,
    required this.serviceUid,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Favorite copyWith({
    String? favoriteId,
    String? uid,
    String? serviceId,
    String? serviceUid,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Favorite(
      favoriteId: favoriteId ?? this.favoriteId,
      uid: uid ?? this.uid,
      serviceId: serviceId ?? this.serviceId,
      serviceUid: serviceUid ?? this.serviceUid,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'favoriteId': favoriteId,
      'uid': uid,
      'serviceId': serviceId,
      'serviceUid': serviceUid,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      favoriteId: map['favoriteId'] as String,
      uid: map['uid'] as String,
      serviceId: map['serviceId'] as String,
      serviceUid: map['serviceUid'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Favorite(favoriteId: $favoriteId, uid: $uid, serviceId: $serviceId, serviceUid: $serviceUid, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Favorite other) {
    if (identical(this, other)) return true;

    return other.favoriteId == favoriteId &&
        other.uid == uid &&
        other.serviceId == serviceId &&
        other.serviceUid == serviceUid &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return favoriteId.hashCode ^
        uid.hashCode ^
        serviceId.hashCode ^
        serviceUid.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
