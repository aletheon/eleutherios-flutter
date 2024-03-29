import 'package:flutter/foundation.dart';

// A rule gets converted to a forum either when a user saves the policy to their service or
// when another service orders the service or when a particular datetime for the rule is reached.
class Rule {
  final String ruleId;
  final String policyId; // policy this rule is associated to
  final String policyUid; // owner / superuser of this policy
  final String managerId; // manager creating the rule
  final String managerUid;
  final String title;
  final String titleLowercase;
  final String description;
  final String image;
  final String banner;
  final bool public; // visibility of rule
  final String instantiationType; // consumption, order, date
  final DateTime instantiationDate;
  final List<String> services;
  final List<String> tags;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Rule({
    required this.ruleId,
    required this.policyId,
    required this.policyUid,
    required this.managerId,
    required this.managerUid,
    required this.title,
    required this.titleLowercase,
    required this.description,
    required this.image,
    required this.banner,
    required this.public,
    required this.instantiationType,
    required this.instantiationDate,
    required this.services,
    required this.tags,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Rule copyWith({
    String? ruleId,
    String? policyId,
    String? policyUid,
    String? managerId,
    String? managerUid,
    String? title,
    String? titleLowercase,
    String? description,
    String? image,
    String? banner,
    bool? public,
    String? instantiationType,
    DateTime? instantiationDate,
    List<String>? services,
    List<String>? tags,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Rule(
      ruleId: ruleId ?? this.ruleId,
      policyId: policyId ?? this.policyId,
      policyUid: policyUid ?? this.policyUid,
      managerId: managerId ?? this.managerId,
      managerUid: managerUid ?? this.managerUid,
      title: title ?? this.title,
      titleLowercase: titleLowercase ?? this.titleLowercase,
      description: description ?? this.description,
      image: image ?? this.image,
      banner: banner ?? this.banner,
      public: public ?? this.public,
      instantiationType: instantiationType ?? this.instantiationType,
      instantiationDate: instantiationDate ?? this.instantiationDate,
      services: services ?? this.services,
      tags: tags ?? this.tags,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ruleId': ruleId,
      'policyId': policyId,
      'policyUid': policyUid,
      'managerId': managerId,
      'managerUid': managerUid,
      'title': title,
      'titleLowercase': titleLowercase,
      'description': description,
      'image': image,
      'banner': banner,
      'public': public,
      'instantiationType': instantiationType,
      'instantiationDate': instantiationDate.millisecondsSinceEpoch,
      'services': services,
      'tags': tags,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Rule.fromMap(Map<String, dynamic> map) {
    return Rule(
      ruleId: map['ruleId'] as String,
      policyId: map['policyId'] as String,
      policyUid: map['policyUid'] as String,
      managerId: map['managerId'] as String,
      managerUid: map['managerUid'] as String,
      title: map['title'] as String,
      titleLowercase: map['titleLowercase'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      banner: map['banner'] as String,
      public: map['public'] as bool,
      instantiationType: map['instantiationType'] as String,
      instantiationDate:
          DateTime.fromMillisecondsSinceEpoch(map['instantiationDate'] as int),
      services: List<String>.from(map['services']),
      tags: List<String>.from(map['tags']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Rule(ruleId: $ruleId, policyId: $policyId, policyUid: $policyUid, managerId: $managerId, managerUid: $managerUid, title: $title, titleLowercase: $titleLowercase, description: $description, image: $image, banner: $banner, public: $public, instantiationType: $instantiationType, instantiationDate: $instantiationDate, services: $services, tags: $tags, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Rule other) {
    if (identical(this, other)) return true;

    return other.ruleId == ruleId &&
        other.policyId == policyId &&
        other.policyUid == policyUid &&
        other.managerId == managerId &&
        other.managerUid == managerUid &&
        other.title == title &&
        other.titleLowercase == titleLowercase &&
        other.description == description &&
        other.image == image &&
        other.banner == banner &&
        other.public == public &&
        other.instantiationType == instantiationType &&
        other.instantiationDate == instantiationDate &&
        listEquals(other.services, services) &&
        listEquals(other.tags, tags) &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return ruleId.hashCode ^
        policyId.hashCode ^
        policyUid.hashCode ^
        managerId.hashCode ^
        managerUid.hashCode ^
        title.hashCode ^
        titleLowercase.hashCode ^
        description.hashCode ^
        image.hashCode ^
        banner.hashCode ^
        public.hashCode ^
        instantiationType.hashCode ^
        instantiationDate.hashCode ^
        services.hashCode ^
        tags.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
