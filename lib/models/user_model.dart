import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String userName;
  final String businessName;
  final String businessDescription;
  final String personalWebsite;
  final String businessWebsite;
  final bool useBusinessProfile;
  final String email;
  final bool isAuthenticated;
  final String banner;
  final int cert;
  final List<String> activities;
  final List<String> policies;
  final List<String> forums;
  final List<String> services;
  final List<String> favorites;
  final List<String> tags;
  final String profilePic;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.userName,
    required this.businessName,
    required this.businessDescription,
    required this.personalWebsite,
    required this.businessWebsite,
    required this.useBusinessProfile,
    required this.email,
    required this.isAuthenticated,
    required this.banner,
    required this.cert,
    required this.activities,
    required this.policies,
    required this.forums,
    required this.services,
    required this.favorites,
    required this.tags,
    required this.profilePic,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? userName,
    String? businessName,
    String? businessDescription,
    String? personalWebsite,
    String? businessWebsite,
    bool? useBusinessProfile,
    String? email,
    bool? isAuthenticated,
    String? banner,
    int? cert,
    List<String>? activities,
    List<String>? policies,
    List<String>? forums,
    List<String>? services,
    List<String>? favorites,
    List<String>? tags,
    String? profilePic,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      personalWebsite: personalWebsite ?? this.personalWebsite,
      businessWebsite: businessWebsite ?? this.businessWebsite,
      useBusinessProfile: useBusinessProfile ?? this.useBusinessProfile,
      email: email ?? this.email,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      banner: banner ?? this.banner,
      cert: cert ?? this.cert,
      activities: activities ?? this.activities,
      policies: policies ?? this.policies,
      forums: forums ?? this.forums,
      services: services ?? this.services,
      favorites: favorites ?? this.favorites,
      tags: tags ?? this.tags,
      profilePic: profilePic ?? this.profilePic,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullName': fullName,
      'userName': userName,
      'businessName': businessName,
      'businessDescription': businessDescription,
      'personalWebsite': personalWebsite,
      'businessWebsite': businessWebsite,
      'useBusinessProfile': useBusinessProfile,
      'email': email,
      'isAuthenticated': isAuthenticated,
      'banner': banner,
      'cert': cert,
      'activities': activities,
      'policies': policies,
      'forums': forums,
      'services': services,
      'favorites': favorites,
      'tags': tags,
      'profilePic': profilePic,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      fullName: map['fullName'] as String,
      userName: map['userName'] as String,
      businessName: map['businessName'] as String,
      businessDescription: map['businessDescription'] as String,
      personalWebsite: map['personalWebsite'] as String,
      businessWebsite: map['businessWebsite'] as String,
      useBusinessProfile: map['useBusinessProfile'] as bool,
      email: map['email'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      banner: map['banner'] as String,
      cert: map['cert'] as int,
      activities: List<String>.from(map['activities']),
      policies: List<String>.from(map['policies']),
      forums: List<String>.from(map['forums']),
      services: List<String>.from(map['services']),
      favorites: List<String>.from(map['favorites']),
      tags: List<String>.from(map['tags']),
      profilePic: map['profilePic'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, userName: $userName, businessName: $businessName, businessDescription: $businessDescription, personalWebsite: $personalWebsite, businessWebsite: $businessWebsite, useBusinessProfile: $useBusinessProfile, email: $email, isAuthenticated: $isAuthenticated, banner: $banner, cert: $cert, activities: $activities, policies: $policies, forums: $forums, services: $services, favorites: $favorites, tags: $tags, profilePic: $profilePic, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.fullName == fullName &&
        other.userName == userName &&
        other.businessName == businessName &&
        other.businessDescription == businessDescription &&
        other.personalWebsite == personalWebsite &&
        other.businessWebsite == businessWebsite &&
        other.useBusinessProfile == useBusinessProfile &&
        other.email == email &&
        other.isAuthenticated == isAuthenticated &&
        other.banner == banner &&
        other.cert == cert &&
        listEquals(other.activities, activities) &&
        listEquals(other.policies, policies) &&
        listEquals(other.forums, forums) &&
        listEquals(other.services, services) &&
        listEquals(other.favorites, favorites) &&
        listEquals(other.tags, tags) &&
        other.profilePic == profilePic &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fullName.hashCode ^
        userName.hashCode ^
        businessName.hashCode ^
        businessDescription.hashCode ^
        personalWebsite.hashCode ^
        businessWebsite.hashCode ^
        useBusinessProfile.hashCode ^
        email.hashCode ^
        isAuthenticated.hashCode ^
        banner.hashCode ^
        cert.hashCode ^
        activities.hashCode ^
        policies.hashCode ^
        forums.hashCode ^
        services.hashCode ^
        favorites.hashCode ^
        tags.hashCode ^
        profilePic.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
