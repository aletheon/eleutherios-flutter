import 'package:flutter/foundation.dart';

// Abstract representation of energy or a person, place or thing.
class Service {
  final String serviceId;
  final String uid; // owner or superuser of this service
  final String title;
  final String titleLowercase;
  final String description;
  final String image;
  final String imageFileType;
  final String imageFileName;
  final String banner;
  final String bannerFileType;
  final String bannerFileName;
  final bool public;
  final bool canBePurchased; // whether service can be purchased or not
  final double price; // [99.99]
  final String type; // [API, Data, Product, Service]
  final int quantity; // [99]
  final double height; // [99.99]
  final double length; // [99.99]
  final double width; // [99.99]
  final String sizeUnit; // [nm, mm, cm, m, ft]
  final double weight; // [99.99]
  final String weightUnit; // [mg, gm, kg, lb, tn, ml, lt, gn, pt, qt]
  final List<String> tags;
  final List<String> likes;
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
    required this.imageFileType,
    required this.imageFileName,
    required this.banner,
    required this.bannerFileType,
    required this.bannerFileName,
    required this.public,
    required this.canBePurchased,
    required this.price,
    required this.type,
    required this.quantity,
    required this.height,
    required this.length,
    required this.width,
    required this.sizeUnit,
    required this.weight,
    required this.weightUnit,
    required this.tags,
    required this.likes,
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
    String? imageFileType,
    String? imageFileName,
    String? banner,
    String? bannerFileType,
    String? bannerFileName,
    bool? public,
    bool? canBePurchased,
    double? price,
    String? type,
    int? quantity,
    double? height,
    double? length,
    double? width,
    String? sizeUnit,
    double? weight,
    String? weightUnit,
    List<String>? tags,
    List<String>? likes,
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
      imageFileType: imageFileType ?? this.imageFileType,
      imageFileName: imageFileName ?? this.imageFileName,
      banner: banner ?? this.banner,
      bannerFileType: bannerFileType ?? this.bannerFileType,
      bannerFileName: bannerFileName ?? this.bannerFileName,
      public: public ?? this.public,
      canBePurchased: canBePurchased ?? this.canBePurchased,
      price: price ?? this.price,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      height: height ?? this.height,
      length: length ?? this.length,
      width: width ?? this.width,
      sizeUnit: sizeUnit ?? this.sizeUnit,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
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
      'imageFileType': imageFileType,
      'imageFileName': imageFileName,
      'banner': banner,
      'bannerFileType': bannerFileType,
      'bannerFileName': bannerFileName,
      'public': public,
      'canBePurchased': canBePurchased,
      'price': price,
      'type': type,
      'quantity': quantity,
      'height': height,
      'length': length,
      'width': width,
      'sizeUnit': sizeUnit,
      'weight': weight,
      'weightUnit': weightUnit,
      'tags': tags,
      'likes': likes,
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
      imageFileType: map['imageFileType'] as String,
      imageFileName: map['imageFileName'] as String,
      banner: map['banner'] as String,
      bannerFileType: map['bannerFileType'] as String,
      bannerFileName: map['bannerFileName'] as String,
      public: map['public'] as bool,
      canBePurchased: map['canBePurchased'] as bool,
      price: map['price'] as double,
      type: map['type'] as String,
      quantity: map['quantity'] as int,
      height: map['height'] as double,
      length: map['length'] as double,
      width: map['width'] as double,
      sizeUnit: map['sizeUnit'] as String,
      weight: map['weight'] as double,
      weightUnit: map['weightUnit'] as String,
      tags: List<String>.from(map['tags']),
      likes: List<String>.from(map['likes']),
      policies: List<String>.from(map['policies']),
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Service(serviceId: $serviceId, uid: $uid, title: $title, titleLowercase: $titleLowercase, description: $description, image: $image, imageFileType: $imageFileType, imageFileName: $imageFileName, banner: $banner, bannerFileType: $bannerFileType, bannerFileName: $bannerFileName, public: $public, canBePurchased: $canBePurchased, price: $price, type: $type, quantity: $quantity, height: $height, length: $length, width: $width, sizeUnit: $sizeUnit, weight: $weight, weightUnit: $weightUnit, tags: $tags, likes: $likes, policies: $policies, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
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
        other.imageFileType == imageFileType &&
        other.imageFileName == imageFileName &&
        other.banner == banner &&
        other.bannerFileType == bannerFileType &&
        other.bannerFileName == bannerFileName &&
        other.public == public &&
        other.canBePurchased == canBePurchased &&
        other.price == price &&
        other.type == type &&
        other.quantity == quantity &&
        other.height == height &&
        other.length == length &&
        other.width == width &&
        other.sizeUnit == sizeUnit &&
        other.weight == weight &&
        other.weightUnit == weightUnit &&
        listEquals(other.tags, tags) &&
        listEquals(other.likes, likes) &&
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
        imageFileType.hashCode ^
        imageFileName.hashCode ^
        banner.hashCode ^
        bannerFileType.hashCode ^
        bannerFileName.hashCode ^
        public.hashCode ^
        canBePurchased.hashCode ^
        price.hashCode ^
        type.hashCode ^
        quantity.hashCode ^
        height.hashCode ^
        length.hashCode ^
        width.hashCode ^
        sizeUnit.hashCode ^
        weight.hashCode ^
        weightUnit.hashCode ^
        tags.hashCode ^
        likes.hashCode ^
        policies.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
