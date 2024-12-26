import 'package:flutter/foundation.dart';

class Company {
  final String companyId;
  final String uid; // initial user who created the company
  final String companyName;
  final String companyNameLowercase;
  final String industry; // sector or industry the company operates in
  final String description;
  final String image;
  final String imageFileType;
  final String imageFileName;
  final String banner;
  final String bannerFileType;
  final String bannerFileName;
  final String website;
  final String ownershipType; // public, private, nonprofit etc
  final List<String> tags;
  final DateTime yearFounded;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Company({
    required this.companyId,
    required this.uid,
    required this.companyName,
    required this.companyNameLowercase,
    required this.industry,
    required this.description,
    required this.image,
    required this.imageFileType,
    required this.imageFileName,
    required this.banner,
    required this.bannerFileType,
    required this.bannerFileName,
    required this.website,
    required this.ownershipType,
    required this.tags,
    required this.yearFounded,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Company copyWith({
    String? companyId,
    String? uid,
    String? companyName,
    String? companyNameLowercase,
    String? industry,
    String? description,
    String? image,
    String? imageFileType,
    String? imageFileName,
    String? banner,
    String? bannerFileType,
    String? bannerFileName,
    String? website,
    String? ownershipType,
    List<String>? tags,
    DateTime? yearFounded,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Company(
      companyId: companyId ?? this.companyId,
      uid: uid ?? this.uid,
      companyName: companyName ?? this.companyName,
      companyNameLowercase: companyNameLowercase ?? this.companyNameLowercase,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      image: image ?? this.image,
      imageFileType: imageFileType ?? this.imageFileType,
      imageFileName: imageFileName ?? this.imageFileName,
      banner: banner ?? this.banner,
      bannerFileType: bannerFileType ?? this.bannerFileType,
      bannerFileName: bannerFileName ?? this.bannerFileName,
      website: website ?? this.website,
      ownershipType: ownershipType ?? this.ownershipType,
      tags: tags ?? this.tags,
      yearFounded: yearFounded ?? this.yearFounded,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'companyId': companyId,
      'uid': uid,
      'companyName': companyName,
      'companyNameLowercase': companyNameLowercase,
      'industry': industry,
      'description': description,
      'image': image,
      'imageFileType': imageFileType,
      'imageFileName': imageFileName,
      'banner': banner,
      'bannerFileType': bannerFileType,
      'bannerFileName': bannerFileName,
      'website': website,
      'ownershipType': ownershipType,
      'tags': tags,
      'yearFounded': yearFounded.millisecondsSinceEpoch,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      companyId: map['companyId'] as String,
      uid: map['uid'] as String,
      companyName: map['companyName'] as String,
      companyNameLowercase: map['companyNameLowercase'] as String,
      industry: map['industry'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      imageFileType: map['imageFileType'] as String,
      imageFileName: map['imageFileName'] as String,
      banner: map['banner'] as String,
      bannerFileType: map['bannerFileType'] as String,
      bannerFileName: map['bannerFileName'] as String,
      website: map['website'] as String,
      ownershipType: map['ownershipType'] as String,
      tags: List<String>.from(map['tags']),
      yearFounded:
          DateTime.fromMillisecondsSinceEpoch(map['yearFounded'] as int),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Company(companyId: $companyId, uid: $uid, companyName: $companyName, companyNameLowercase: $companyNameLowercase, industry: $industry, description: $description, image: $image, imageFileType: $imageFileType, imageFileName: $imageFileName, banner: $banner, bannerFileType: $bannerFileType, bannerFileName: $bannerFileName, website: $website, ownershipType: $ownershipType, tags: $tags, yearFounded: $yearFounded, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Company other) {
    if (identical(this, other)) return true;

    return other.companyId == companyId &&
        other.uid == uid &&
        other.companyName == companyName &&
        other.companyNameLowercase == companyNameLowercase &&
        other.industry == industry &&
        other.description == description &&
        other.image == image &&
        other.imageFileType == imageFileType &&
        other.imageFileName == imageFileName &&
        other.banner == banner &&
        other.bannerFileType == bannerFileType &&
        other.bannerFileName == bannerFileName &&
        other.website == website &&
        other.ownershipType == ownershipType &&
        listEquals(other.tags, tags) &&
        other.yearFounded == yearFounded &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return companyId.hashCode ^
        uid.hashCode ^
        companyName.hashCode ^
        companyNameLowercase.hashCode ^
        industry.hashCode ^
        description.hashCode ^
        image.hashCode ^
        imageFileType.hashCode ^
        imageFileName.hashCode ^
        banner.hashCode ^
        bannerFileType.hashCode ^
        bannerFileName.hashCode ^
        website.hashCode ^
        ownershipType.hashCode ^
        tags.hashCode ^
        yearFounded.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
