import 'package:flutter/foundation.dart';

// Abstract representation of a collective policy or rule based system managed by all services
class Policy {
  final String policyId;
  final String uid; // owner or superuser of the policy
  final String title;
  final String titleLowercase;
  final String description;
  final String image;
  final String imageFileType;
  final String imageFileName;
  final String banner;
  final String bannerFileType;
  final String bannerFileName;
  final bool public; // visibility of policy
  final List<String> tags;
  final List<String> services; // copy of manager services for redundancy sake
  final List<String> managers; // managers (i.e. services) managing this policy
  final List<String> consumers; // services consuming this policy
  final List<String> rules; // rules associated with the policy
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Policy({
    required this.policyId,
    required this.uid,
    required this.title,
    required this.titleLowercase,
    required this.description,
    required this.image,
    required this.imageFileType,
    required this.imageFileName,
    required this.banner,
    required this.bannerFileType,
    required this.bannerFileName,
    required this.public,
    required this.tags,
    required this.services,
    required this.managers,
    required this.consumers,
    required this.rules,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Policy copyWith({
    String? policyId,
    String? uid,
    String? title,
    String? titleLowercase,
    String? description,
    String? image,
    String? imageFileType,
    String? imageFileName,
    String? banner,
    String? bannerFileType,
    String? bannerFileName,
    bool? public,
    List<String>? tags,
    List<String>? services,
    List<String>? managers,
    List<String>? consumers,
    List<String>? rules,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Policy(
      policyId: policyId ?? this.policyId,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      titleLowercase: titleLowercase ?? this.titleLowercase,
      description: description ?? this.description,
      image: image ?? this.image,
      imageFileType: imageFileType ?? this.imageFileType,
      imageFileName: imageFileName ?? this.imageFileName,
      banner: banner ?? this.banner,
      bannerFileType: bannerFileType ?? this.bannerFileType,
      bannerFileName: bannerFileName ?? this.bannerFileName,
      public: public ?? this.public,
      tags: tags ?? this.tags,
      services: services ?? this.services,
      managers: managers ?? this.managers,
      consumers: consumers ?? this.consumers,
      rules: rules ?? this.rules,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'policyId': policyId,
      'uid': uid,
      'title': title,
      'titleLowercase': titleLowercase,
      'description': description,
      'image': image,
      'imageFileType': imageFileType,
      'imageFileName': imageFileName,
      'banner': banner,
      'bannerFileType': bannerFileType,
      'bannerFileName': bannerFileName,
      'public': public,
      'tags': tags,
      'services': services,
      'managers': managers,
      'consumers': consumers,
      'rules': rules,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Policy.fromMap(Map<String, dynamic> map) {
    return Policy(
      policyId: map['policyId'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      titleLowercase: map['titleLowercase'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      imageFileType: map['imageFileType'] as String,
      imageFileName: map['imageFileName'] as String,
      banner: map['banner'] as String,
      bannerFileType: map['bannerFileType'] as String,
      bannerFileName: map['bannerFileName'] as String,
      public: map['public'] as bool,
      tags: List<String>.from(map['tags']),
      services: List<String>.from(map['services']),
      managers: List<String>.from(map['managers']),
      consumers: List<String>.from(map['consumers']),
      rules: List<String>.from(map['rules']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Policy(policyId: $policyId, uid: $uid, title: $title, titleLowercase: $titleLowercase, description: $description, image: $image, imageFileType: $imageFileType, imageFileName: $imageFileName, banner: $banner, bannerFileType: $bannerFileType, bannerFileName: $bannerFileName, public: $public, tags: $tags, services: $services, managers: $managers, consumers: $consumers, rules: $rules, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Policy other) {
    if (identical(this, other)) return true;

    return other.policyId == policyId &&
        other.uid == uid &&
        other.title == title &&
        other.titleLowercase == titleLowercase &&
        other.description == description &&
        other.image == image &&
        other.imageFileType == imageFileType &&
        other.imageFileName == imageFileName &&
        other.banner == banner &&
        other.bannerFileType == bannerFileType &&
        other.bannerFileName == bannerFileName &&
        other.public == public &&
        listEquals(other.tags, tags) &&
        listEquals(other.services, services) &&
        listEquals(other.managers, managers) &&
        listEquals(other.consumers, consumers) &&
        listEquals(other.rules, rules) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return policyId.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        titleLowercase.hashCode ^
        description.hashCode ^
        image.hashCode ^
        imageFileType.hashCode ^
        imageFileName.hashCode ^
        banner.hashCode ^
        bannerFileType.hashCode ^
        bannerFileName.hashCode ^
        public.hashCode ^
        tags.hashCode ^
        services.hashCode ^
        managers.hashCode ^
        consumers.hashCode ^
        rules.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
