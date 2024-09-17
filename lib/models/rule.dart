import 'package:flutter/foundation.dart';

// A rule gets converted to a forum either when a user saves the policy to their service or
// when another service orders the service or when a particular datetime for the rule is reached.

// HERE ROB ADD ANOTHER OPTION TO ENABLE SERVICE TO BE A PART OF THE SAME RULE / FORUM WHEN THIS POLICY
// IS CONSUMED OR A PART OF THEIR OWN RULE / FORUM WHEN THEY CONSUME THE POLICY
// IE:
// - When policy is consumed create a separate forum for this rule
// - When policy is consumed use the same forum for this rule
// This new field is important for allowing a service to share their data in the same forum
// without having to recreate or share the data with each new consumer.  They can just have it in one
// place for everybody to grab at

class Rule {
  final String ruleId;
  final String uid; // owner or superuser of this rule
  final String policyId; // policy this rule is associated to
  final String policyUid; // owner or superuser of this policy
  final String managerId; // manager creating the rule
  final String managerUid;
  final String title;
  final String titleLowercase;
  final String description;
  final String image;
  final String imageFileType;
  final String imageFileName;
  final String banner;
  final String bannerFileType;
  final String bannerFileName;
  final bool public; // visibility of rule
  final String ruleType; // separate, single
  final String instantiationType; // consume, order, date
  final DateTime instantiationDate;
  final List<String> services; // copy of member services for redundancy sake
  final List<String>
      members; // potential members (i.e. services) that will serve in this rule
  final List<String> tags;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Rule({
    required this.ruleId,
    required this.uid,
    required this.policyId,
    required this.policyUid,
    required this.managerId,
    required this.managerUid,
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
    required this.ruleType,
    required this.instantiationType,
    required this.instantiationDate,
    required this.services,
    required this.members,
    required this.tags,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Rule copyWith({
    String? ruleId,
    String? uid,
    String? policyId,
    String? policyUid,
    String? managerId,
    String? managerUid,
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
    String? ruleType,
    String? instantiationType,
    DateTime? instantiationDate,
    List<String>? services,
    List<String>? members,
    List<String>? tags,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Rule(
      ruleId: ruleId ?? this.ruleId,
      uid: uid ?? this.uid,
      policyId: policyId ?? this.policyId,
      policyUid: policyUid ?? this.policyUid,
      managerId: managerId ?? this.managerId,
      managerUid: managerUid ?? this.managerUid,
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
      ruleType: ruleType ?? this.ruleType,
      instantiationType: instantiationType ?? this.instantiationType,
      instantiationDate: instantiationDate ?? this.instantiationDate,
      services: services ?? this.services,
      members: members ?? this.members,
      tags: tags ?? this.tags,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ruleId': ruleId,
      'uid': uid,
      'policyId': policyId,
      'policyUid': policyUid,
      'managerId': managerId,
      'managerUid': managerUid,
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
      'ruleType': ruleType,
      'instantiationType': instantiationType,
      'instantiationDate': instantiationDate.millisecondsSinceEpoch,
      'services': services,
      'members': members,
      'tags': tags,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Rule.fromMap(Map<String, dynamic> map) {
    return Rule(
      ruleId: map['ruleId'] as String,
      uid: map['uid'] as String,
      policyId: map['policyId'] as String,
      policyUid: map['policyUid'] as String,
      managerId: map['managerId'] as String,
      managerUid: map['managerUid'] as String,
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
      ruleType: map['ruleType'] as String,
      instantiationType: map['instantiationType'] as String,
      instantiationDate:
          DateTime.fromMillisecondsSinceEpoch(map['instantiationDate'] as int),
      services: List<String>.from(map['services']),
      members: List<String>.from(map['members']),
      tags: List<String>.from(map['tags']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Rule(ruleId: $ruleId, uid: $uid, policyId: $policyId, policyUid: $policyUid, managerId: $managerId, managerUid: $managerUid, title: $title, titleLowercase: $titleLowercase, description: $description, image: $image, imageFileType: $imageFileType, imageFileName: $imageFileName, banner: $banner, bannerFileType: $bannerFileType, bannerFileName: $bannerFileName, public: $public, instantiationType: $instantiationType, ruleType: $ruleType, instantiationDate: $instantiationDate, services: $services, members: $members, tags: $tags, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Rule other) {
    if (identical(this, other)) return true;

    return other.ruleId == ruleId &&
        other.uid == uid &&
        other.policyId == policyId &&
        other.policyUid == policyUid &&
        other.managerId == managerId &&
        other.managerUid == managerUid &&
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
        other.ruleType == ruleType &&
        other.instantiationType == instantiationType &&
        other.instantiationDate == instantiationDate &&
        listEquals(other.services, services) &&
        listEquals(other.members, members) &&
        listEquals(other.tags, tags) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return ruleId.hashCode ^
        uid.hashCode ^
        policyId.hashCode ^
        policyUid.hashCode ^
        managerId.hashCode ^
        managerUid.hashCode ^
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
        ruleType.hashCode ^
        instantiationType.hashCode ^
        instantiationDate.hashCode ^
        services.hashCode ^
        members.hashCode ^
        tags.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
