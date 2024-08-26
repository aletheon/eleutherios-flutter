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
  final String shoppingCartId;
  final String stripeCustomerId;
  final String stripeAccountId;
  final String stripeOnboardingStatus;
  final String stripeCurrency;
  final String fcmToken;
  final List<String> forumActivities;
  final List<String> policyActivities;
  final List<String> policies;
  final List<String> forums;
  final List<String> services;
  final List<String> favorites;
  // shopping cart users this user has member permission to add items too
  final List<String> shoppingCartUserIds;
  final List<String> shoppingCartItemIds;
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
    required this.shoppingCartId,
    required this.stripeCustomerId,
    required this.stripeAccountId,
    required this.stripeOnboardingStatus,
    required this.stripeCurrency,
    required this.fcmToken,
    required this.forumActivities,
    required this.policyActivities,
    required this.policies,
    required this.forums,
    required this.services,
    required this.favorites,
    required this.shoppingCartUserIds,
    required this.shoppingCartItemIds,
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
    String? shoppingCartId,
    String? stripeCustomerId,
    String? stripeAccountId,
    String? stripeOnboardingStatus,
    String? stripeCurrency,
    String? fcmToken,
    List<String>? forumActivities,
    List<String>? policyActivities,
    List<String>? policies,
    List<String>? forums,
    List<String>? services,
    List<String>? favorites,
    List<String>? shoppingCartUserIds,
    List<String>? shoppingCartItemIds,
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
      shoppingCartId: shoppingCartId ?? this.shoppingCartId,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      stripeOnboardingStatus:
          stripeOnboardingStatus ?? this.stripeOnboardingStatus,
      stripeCurrency: stripeCurrency ?? this.stripeCurrency,
      fcmToken: fcmToken ?? this.fcmToken,
      forumActivities: forumActivities ?? this.forumActivities,
      policyActivities: policyActivities ?? this.policyActivities,
      policies: policies ?? this.policies,
      forums: forums ?? this.forums,
      services: services ?? this.services,
      favorites: favorites ?? this.favorites,
      shoppingCartUserIds: shoppingCartUserIds ?? this.shoppingCartUserIds,
      shoppingCartItemIds: shoppingCartItemIds ?? this.shoppingCartItemIds,
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
      'shoppingCartId': shoppingCartId,
      'stripeCustomerId': stripeCustomerId,
      'stripeAccountId': stripeAccountId,
      'stripeOnboardingStatus': stripeOnboardingStatus,
      'stripeCurrency': stripeCurrency,
      'fcmToken': fcmToken,
      'forumActivities': forumActivities,
      'policyActivities': policyActivities,
      'policies': policies,
      'forums': forums,
      'services': services,
      'favorites': favorites,
      'shoppingCartUserIds': shoppingCartUserIds,
      'shoppingCartItemIds': shoppingCartItemIds,
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
      shoppingCartId: map['shoppingCartId'] as String,
      stripeCustomerId: map['stripeCustomerId'] as String,
      stripeAccountId: map['stripeAccountId'] as String,
      stripeOnboardingStatus: map['stripeOnboardingStatus'] as String,
      stripeCurrency: map['stripeCurrency'] as String,
      fcmToken: map['fcmToken'] as String,
      forumActivities: List<String>.from(map['forumActivities']),
      policyActivities: List<String>.from(map['policyActivities']),
      policies: List<String>.from(map['policies']),
      forums: List<String>.from(map['forums']),
      services: List<String>.from(map['services']),
      favorites: List<String>.from(map['favorites']),
      shoppingCartUserIds: List<String>.from(map['shoppingCartUserIds']),
      shoppingCartItemIds: List<String>.from(map['shoppingCartItemIds']),
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
    return 'UserModel(uid: $uid, fullName: $fullName, userName: $userName, businessName: $businessName, businessDescription: $businessDescription, personalWebsite: $personalWebsite, businessWebsite: $businessWebsite, useBusinessProfile: $useBusinessProfile, email: $email, isAuthenticated: $isAuthenticated, banner: $banner, cert: $cert, shoppingCartId: $shoppingCartId, stripeCustomerId: $stripeCustomerId, stripeAccountId: $stripeAccountId, stripeOnboardingStatus: $stripeOnboardingStatus, stripeCurrency: $stripeCurrency, fcmToken: $fcmToken, forumActivities: $forumActivities, policyActivities: $policyActivities, policies: $policies, forums: $forums, services: $services, favorites: $favorites, shoppingCartUserIds: $shoppingCartUserIds, shoppingCartItemIds: $shoppingCartItemIds, tags: $tags, profilePic: $profilePic, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
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
        other.shoppingCartId == shoppingCartId &&
        other.stripeCustomerId == stripeCustomerId &&
        other.stripeAccountId == stripeAccountId &&
        other.stripeOnboardingStatus == stripeOnboardingStatus &&
        other.stripeCurrency == stripeCurrency &&
        other.fcmToken == fcmToken &&
        listEquals(other.forumActivities, forumActivities) &&
        listEquals(other.policyActivities, policyActivities) &&
        listEquals(other.policies, policies) &&
        listEquals(other.forums, forums) &&
        listEquals(other.services, services) &&
        listEquals(other.favorites, favorites) &&
        listEquals(other.shoppingCartUserIds, shoppingCartUserIds) &&
        listEquals(other.shoppingCartItemIds, shoppingCartItemIds) &&
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
        shoppingCartId.hashCode ^
        stripeCustomerId.hashCode ^
        stripeAccountId.hashCode ^
        stripeOnboardingStatus.hashCode ^
        stripeCurrency.hashCode ^
        fcmToken.hashCode ^
        forumActivities.hashCode ^
        policyActivities.hashCode ^
        policies.hashCode ^
        forums.hashCode ^
        services.hashCode ^
        favorites.hashCode ^
        shoppingCartUserIds.hashCode ^
        shoppingCartItemIds.hashCode ^
        tags.hashCode ^
        profilePic.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
