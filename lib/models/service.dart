import 'package:flutter/foundation.dart';

// Abstract representation of energy or a person, place or thing.
class Service {
  final String serviceId;
  final String uid;
  final String title;
  final String titleLowercase;
  final String description;
  final String image;
  final String banner;
  final bool public;
  final List<String> tags;
  final List<String> policies;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Service({
    required this.serviceId,
    required this.uid,
    required this.title,
    required this.titleLowercase,
    required this.description,
    required this.image,
    required this.banner,
    required this.public,
    required this.tags,
    required this.policies,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Service copyWith({
    String? serviceId,
    String? uid,
    String? title,
    String? titleLowercase,
    String? description,
    String? image,
    String? banner,
    bool? public,
    List<String>? tags,
    List<String>? policies,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Service(
      serviceId: serviceId ?? this.serviceId,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      titleLowercase: titleLowercase ?? this.titleLowercase,
      description: description ?? this.description,
      image: image ?? this.image,
      banner: banner ?? this.banner,
      public: public ?? this.public,
      tags: tags ?? this.tags,
      policies: policies ?? this.policies,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serviceId': serviceId,
      'uid': uid,
      'title': title,
      'titleLowercase': titleLowercase,
      'description': description,
      'image': image,
      'banner': banner,
      'public': public,
      'tags': tags,
      'policies': policies,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      serviceId: map['serviceId'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      titleLowercase: map['titleLowercase'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      banner: map['banner'] as String,
      public: map['public'] as bool,
      tags: List<String>.from(map['tags']),
      policies: List<String>.from(map['policies']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Service(serviceId: $serviceId, uid: $uid, title: $title, titleLowercase: $titleLowercase, description: $description, image: $image, banner: $banner, public: $public, tags: $tags, policies: $policies, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Service other) {
    if (identical(this, other)) return true;

    return other.serviceId == serviceId &&
        other.uid == uid &&
        other.title == title &&
        other.titleLowercase == titleLowercase &&
        other.description == description &&
        other.image == image &&
        other.banner == banner &&
        other.public == public &&
        listEquals(other.tags, tags) &&
        listEquals(other.policies, policies) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return serviceId.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        titleLowercase.hashCode ^
        description.hashCode ^
        image.hashCode ^
        banner.hashCode ^
        public.hashCode ^
        tags.hashCode ^
        policies.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
