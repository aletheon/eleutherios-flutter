import 'package:flutter/foundation.dart';

// Abstract network for service providers to share their service or energy
class Forum {
  final String forumId;
  final String uid; // owner or superuser of this forum
  final String parentId; // id of the forum, that this forum belongs to
  final String parentUid; // id of the user who owns the parent forum
  final String policyId; // policy this forum is associated to
  final String policyUid;
  final String ruleId; // rule that this forum is derived from
  final String title;
  final String titleLowercase;
  final String description;
  final String image;
  final String banner;
  final bool public;
  final List<String> tags;
  final List<String> registrants;
  final List<String> posts;
  final List<String> forums;
  final List<String> breadcrumbs; // breadcrumb to store forumIds up to the root
  final List<String>
      breadcrumbReferences; // store the forumIds of other forums referencing this forum in their breadcrumb
  final String recentPostId;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Forum({
    required this.forumId,
    required this.uid,
    required this.parentId,
    required this.parentUid,
    required this.policyId,
    required this.policyUid,
    required this.ruleId,
    required this.title,
    required this.titleLowercase,
    required this.description,
    required this.image,
    required this.banner,
    required this.public,
    required this.tags,
    required this.registrants,
    required this.posts,
    required this.forums,
    required this.breadcrumbs,
    required this.breadcrumbReferences,
    required this.recentPostId,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Forum copyWith({
    String? forumId,
    String? uid,
    String? parentId,
    String? parentUid,
    String? policyId,
    String? policyUid,
    String? ruleId,
    String? title,
    String? titleLowercase,
    String? description,
    String? image,
    String? banner,
    bool? public,
    List<String>? tags,
    List<String>? registrants,
    List<String>? posts,
    List<String>? forums,
    List<String>? breadcrumbs,
    List<String>? breadcrumbReferences,
    String? recentPostId,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Forum(
      forumId: forumId ?? this.forumId,
      uid: uid ?? this.uid,
      parentId: parentId ?? this.parentId,
      parentUid: parentUid ?? this.parentUid,
      policyId: policyId ?? this.policyId,
      policyUid: policyUid ?? this.policyUid,
      ruleId: ruleId ?? this.ruleId,
      title: title ?? this.title,
      titleLowercase: titleLowercase ?? this.titleLowercase,
      description: description ?? this.description,
      image: image ?? this.image,
      banner: banner ?? this.banner,
      public: public ?? this.public,
      tags: tags ?? this.tags,
      registrants: registrants ?? this.registrants,
      posts: posts ?? this.posts,
      forums: forums ?? this.forums,
      breadcrumbs: breadcrumbs ?? this.breadcrumbs,
      breadcrumbReferences: breadcrumbReferences ?? this.breadcrumbReferences,
      recentPostId: recentPostId ?? this.recentPostId,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forumId': forumId,
      'uid': uid,
      'parentId': parentId,
      'parentUid': parentUid,
      'policyId': policyId,
      'policyUid': policyUid,
      'ruleId': ruleId,
      'title': title,
      'titleLowercase': titleLowercase,
      'description': description,
      'image': image,
      'banner': banner,
      'public': public,
      'tags': tags,
      'registrants': registrants,
      'posts': posts,
      'forums': forums,
      'breadcrumbs': breadcrumbs,
      'breadcrumbReferences': breadcrumbReferences,
      'recentPostId': recentPostId,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Forum.fromMap(Map<String, dynamic> map) {
    return Forum(
      forumId: map['forumId'] as String,
      uid: map['uid'] as String,
      parentId: map['parentId'] as String,
      parentUid: map['parentUid'] as String,
      policyId: map['policyId'] as String,
      policyUid: map['policyUid'] as String,
      ruleId: map['ruleId'] as String,
      title: map['title'] as String,
      titleLowercase: map['titleLowercase'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      banner: map['banner'] as String,
      public: map['public'] as bool,
      tags: List<String>.from(map['tags']),
      registrants: List<String>.from(map['registrants']),
      posts: List<String>.from(map['posts']),
      forums: List<String>.from(map['forums']),
      breadcrumbs: List<String>.from(map['breadcrumbs']),
      breadcrumbReferences: List<String>.from(map['breadcrumbReferences']),
      recentPostId: map['recentPostId'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Forum(forumId: $forumId, uid: $uid, parentId: $parentId, parentUid: $parentUid, policyId: $policyId, policyUid: $policyUid, ruleId: $ruleId, title: $title, titleLowercase: $titleLowercase, description: $description, image: $image, banner: $banner, public: $public, tags: $tags, registrants: $registrants, posts: $posts, forums: $forums, breadcrumbs: $breadcrumbs, breadcrumbReferences: $breadcrumbReferences, recentPostId: $recentPostId, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Forum other) {
    if (identical(this, other)) return true;

    return other.forumId == forumId &&
        other.uid == uid &&
        other.parentId == parentId &&
        other.parentUid == parentUid &&
        other.policyId == policyId &&
        other.policyUid == policyUid &&
        other.ruleId == ruleId &&
        other.title == title &&
        other.titleLowercase == titleLowercase &&
        other.description == description &&
        other.image == image &&
        other.banner == banner &&
        other.public == public &&
        listEquals(other.tags, tags) &&
        listEquals(other.registrants, registrants) &&
        listEquals(other.posts, posts) &&
        listEquals(other.forums, forums) &&
        listEquals(other.breadcrumbs, breadcrumbs) &&
        listEquals(other.breadcrumbReferences, breadcrumbReferences) &&
        other.recentPostId == recentPostId &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return forumId.hashCode ^
        uid.hashCode ^
        parentId.hashCode ^
        parentUid.hashCode ^
        policyId.hashCode ^
        policyUid.hashCode ^
        ruleId.hashCode ^
        title.hashCode ^
        titleLowercase.hashCode ^
        description.hashCode ^
        image.hashCode ^
        banner.hashCode ^
        public.hashCode ^
        tags.hashCode ^
        registrants.hashCode ^
        posts.hashCode ^
        forums.hashCode ^
        breadcrumbs.hashCode ^
        breadcrumbReferences.hashCode ^
        recentPostId.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
