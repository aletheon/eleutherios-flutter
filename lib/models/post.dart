class Post {
  final String postId;
  final String forumId;
  final String forumUid;
  final String registrantId;
  final String serviceId;
  final String serviceUid;
  final String message;
  final String messageLowercase;
  final String image;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Post({
    required this.postId,
    required this.forumId,
    required this.forumUid,
    required this.registrantId,
    required this.serviceId,
    required this.serviceUid,
    required this.message,
    required this.messageLowercase,
    required this.image,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Post copyWith({
    String? postId,
    String? forumId,
    String? forumUid,
    String? registrantId,
    String? serviceId,
    String? serviceUid,
    String? message,
    String? messageLowercase,
    String? image,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Post(
      postId: postId ?? this.postId,
      forumId: forumId ?? this.forumId,
      forumUid: forumUid ?? this.forumUid,
      registrantId: registrantId ?? this.registrantId,
      serviceId: serviceId ?? this.serviceId,
      serviceUid: serviceUid ?? this.serviceUid,
      message: message ?? this.message,
      messageLowercase: messageLowercase ?? this.messageLowercase,
      image: image ?? this.image,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'forumId': forumId,
      'forumUid': forumUid,
      'registrantId': registrantId,
      'serviceId': serviceId,
      'serviceUid': serviceUid,
      'message': message,
      'messageLowercase': messageLowercase,
      'image': image,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'] as String,
      forumId: map['forumId'] as String,
      forumUid: map['forumUid'] as String,
      registrantId: map['registrantId'] as String,
      serviceId: map['serviceId'] as String,
      serviceUid: map['serviceUid'] as String,
      message: map['message'] as String,
      messageLowercase: map['messageLowercase'] as String,
      image: map['image'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Post(postId: $postId, forumId: $forumId, forumUid: $forumUid, registrantId: $registrantId, serviceId: $serviceId, serviceUid: $serviceUid, message: $message, messageLowercase: $messageLowercase, image: $image, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.postId == postId &&
        other.forumId == forumId &&
        other.forumUid == forumUid &&
        other.registrantId == registrantId &&
        other.serviceId == serviceId &&
        other.serviceUid == serviceUid &&
        other.message == message &&
        other.messageLowercase == messageLowercase &&
        other.image == image &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        forumId.hashCode ^
        forumUid.hashCode ^
        registrantId.hashCode ^
        serviceId.hashCode ^
        serviceUid.hashCode ^
        message.hashCode ^
        messageLowercase.hashCode ^
        image.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
