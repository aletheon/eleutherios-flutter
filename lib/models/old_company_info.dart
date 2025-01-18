import 'package:flutter/foundation.dart';

import 'package:reddit_tutorial/models/open_hours.dart';

class OldCompanyInfo {
  final String companyId;
  final String uid; // initial user who created the company
  final String updateUid; // id of the user updating the company
  final String companyName;
  final String companyNameLowercase;
  final String industry; // sector or industry the company operates in
  final String description;
  final String houseOrBuildingNumber;
  final String streetName;
  final String city;
  final String stateProvinceOrRegion;
  final String postOrZipcode;
  final String country;
  final double latitude; // for geocoding and mapping
  final double longitude; // for geocoding and mapping
  final String
      landmark; // notable nearby points for easier identification (useful in regions where addresses are not standard)
  final String contactName;
  final String contactPhone;
  final String contactEmail;
  final bool addressVerification; // whether address has been verified or not
  final String image;
  final String imageFileType;
  final String imageFileName;
  final String banner;
  final String bannerFileType;
  final String bannerFileName;
  final String website;
  final String ownershipType; // public, private, nonprofit etc
  final List<String> tags;
  final List<OpenHours> hours;
  final DateTime yearFounded;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  OldCompanyInfo({
    required this.companyId,
    required this.uid,
    required this.updateUid,
    required this.companyName,
    required this.companyNameLowercase,
    required this.industry,
    required this.description,
    required this.houseOrBuildingNumber,
    required this.streetName,
    required this.city,
    required this.stateProvinceOrRegion,
    required this.postOrZipcode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.landmark,
    required this.contactName,
    required this.contactPhone,
    required this.contactEmail,
    required this.addressVerification,
    required this.image,
    required this.imageFileType,
    required this.imageFileName,
    required this.banner,
    required this.bannerFileType,
    required this.bannerFileName,
    required this.website,
    required this.ownershipType,
    required this.tags,
    required this.hours,
    required this.yearFounded,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  OldCompanyInfo copyWith({
    String? companyId,
    String? uid,
    String? updateUid,
    String? companyName,
    String? companyNameLowercase,
    String? industry,
    String? description,
    String? houseOrBuildingNumber,
    String? streetName,
    String? city,
    String? stateProvinceOrRegion,
    String? postOrZipcode,
    String? country,
    double? latitude,
    double? longitude,
    String? landmark,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    bool? addressVerification,
    String? image,
    String? imageFileType,
    String? imageFileName,
    String? banner,
    String? bannerFileType,
    String? bannerFileName,
    String? website,
    String? ownershipType,
    List<String>? tags,
    List<OpenHours>? hours,
    DateTime? yearFounded,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return OldCompanyInfo(
      companyId: companyId ?? this.companyId,
      uid: uid ?? this.uid,
      updateUid: updateUid ?? this.updateUid,
      companyName: companyName ?? this.companyName,
      companyNameLowercase: companyNameLowercase ?? this.companyNameLowercase,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      houseOrBuildingNumber:
          houseOrBuildingNumber ?? this.houseOrBuildingNumber,
      streetName: streetName ?? this.streetName,
      city: city ?? this.city,
      stateProvinceOrRegion:
          stateProvinceOrRegion ?? this.stateProvinceOrRegion,
      postOrZipcode: postOrZipcode ?? this.postOrZipcode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      landmark: landmark ?? this.landmark,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      addressVerification: addressVerification ?? this.addressVerification,
      image: image ?? this.image,
      imageFileType: imageFileType ?? this.imageFileType,
      imageFileName: imageFileName ?? this.imageFileName,
      banner: banner ?? this.banner,
      bannerFileType: bannerFileType ?? this.bannerFileType,
      bannerFileName: bannerFileName ?? this.bannerFileName,
      website: website ?? this.website,
      ownershipType: ownershipType ?? this.ownershipType,
      tags: tags ?? this.tags,
      hours: hours ?? this.hours,
      yearFounded: yearFounded ?? this.yearFounded,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'companyId': companyId,
      'uid': uid,
      'updateUid': updateUid,
      'companyName': companyName,
      'companyNameLowercase': companyNameLowercase,
      'industry': industry,
      'description': description,
      'houseOrBuildingNumber': houseOrBuildingNumber,
      'streetName': streetName,
      'city': city,
      'stateProvinceOrRegion': stateProvinceOrRegion,
      'postOrZipcode': postOrZipcode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'landmark': landmark,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'addressVerification': addressVerification,
      'image': image,
      'imageFileType': imageFileType,
      'imageFileName': imageFileName,
      'banner': banner,
      'bannerFileType': bannerFileType,
      'bannerFileName': bannerFileName,
      'website': website,
      'ownershipType': ownershipType,
      'tags': tags,
      'hours': hours.map((x) => x.toMap()).toList(),
      'yearFounded': yearFounded.millisecondsSinceEpoch,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory OldCompanyInfo.fromMap(Map<String, dynamic> map) {
    return OldCompanyInfo(
      companyId: map['companyId'] as String,
      uid: map['uid'] as String,
      updateUid: map['updateUid'] as String,
      companyName: map['companyName'] as String,
      companyNameLowercase: map['companyNameLowercase'] as String,
      industry: map['industry'] as String,
      description: map['description'] as String,
      houseOrBuildingNumber: map['houseOrBuildingNumber'] as String,
      streetName: map['streetName'] as String,
      city: map['city'] as String,
      stateProvinceOrRegion: map['stateProvinceOrRegion'] as String,
      postOrZipcode: map['postOrZipcode'] as String,
      country: map['country'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      landmark: map['landmark'] as String,
      contactName: map['contactName'] as String,
      contactPhone: map['contactPhone'] as String,
      contactEmail: map['contactEmail'] as String,
      addressVerification: map['addressVerification'] as bool,
      image: map['image'] as String,
      imageFileType: map['imageFileType'] as String,
      imageFileName: map['imageFileName'] as String,
      banner: map['banner'] as String,
      bannerFileType: map['bannerFileType'] as String,
      bannerFileName: map['bannerFileName'] as String,
      website: map['website'] as String,
      ownershipType: map['ownershipType'] as String,
      tags: List<String>.from(map['tags']),
      hours: List<OpenHours>.from(map['hours']),
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
    return 'OldCompanyInfo(companyId: $companyId, uid: $uid, updateUid: $updateUid, companyName: $companyName, companyNameLowercase: $companyNameLowercase, industry: $industry, description: $description, houseOrBuildingNumber: $houseOrBuildingNumber, streetName: $streetName, city: $city, stateProvinceOrRegion: $stateProvinceOrRegion, postOrZipcode: $postOrZipcode, country: $country, latitude: $latitude, longitude: $longitude, landmark: $landmark, contactName: $contactName, contactPhone: $contactPhone, contactEmail: $contactEmail, addressVerification: $addressVerification, image: $image, imageFileType: $imageFileType, imageFileName: $imageFileName, banner: $banner, bannerFileType: $bannerFileType, bannerFileName: $bannerFileName, website: $website, ownershipType: $ownershipType, tags: $tags, hours: $hours, yearFounded: $yearFounded, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant OldCompanyInfo other) {
    if (identical(this, other)) return true;

    return other.companyId == companyId &&
        other.uid == uid &&
        other.updateUid == updateUid &&
        other.companyName == companyName &&
        other.companyNameLowercase == companyNameLowercase &&
        other.industry == industry &&
        other.description == description &&
        other.houseOrBuildingNumber == houseOrBuildingNumber &&
        other.streetName == streetName &&
        other.city == city &&
        other.stateProvinceOrRegion == stateProvinceOrRegion &&
        other.postOrZipcode == postOrZipcode &&
        other.country == country &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.landmark == landmark &&
        other.contactName == contactName &&
        other.contactPhone == contactPhone &&
        other.contactEmail == contactEmail &&
        other.addressVerification == addressVerification &&
        other.image == image &&
        other.imageFileType == imageFileType &&
        other.imageFileName == imageFileName &&
        other.banner == banner &&
        other.bannerFileType == bannerFileType &&
        other.bannerFileName == bannerFileName &&
        other.website == website &&
        other.ownershipType == ownershipType &&
        listEquals(other.tags, tags) &&
        listEquals(other.hours, hours) &&
        other.yearFounded == yearFounded &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return companyId.hashCode ^
        uid.hashCode ^
        updateUid.hashCode ^
        companyName.hashCode ^
        companyNameLowercase.hashCode ^
        industry.hashCode ^
        description.hashCode ^
        houseOrBuildingNumber.hashCode ^
        streetName.hashCode ^
        city.hashCode ^
        stateProvinceOrRegion.hashCode ^
        postOrZipcode.hashCode ^
        country.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        landmark.hashCode ^
        contactName.hashCode ^
        contactPhone.hashCode ^
        contactEmail.hashCode ^
        addressVerification.hashCode ^
        image.hashCode ^
        imageFileType.hashCode ^
        imageFileName.hashCode ^
        banner.hashCode ^
        bannerFileType.hashCode ^
        bannerFileName.hashCode ^
        website.hashCode ^
        ownershipType.hashCode ^
        tags.hashCode ^
        hours.hashCode ^
        yearFounded.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
