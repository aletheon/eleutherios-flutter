import 'package:flutter/foundation.dart';

class Search {
  final String uid;
  final String query;
  final List<String> tags;
  Search({
    required this.uid,
    required this.query,
    required this.tags,
  });

  Search copyWith({
    String? uid,
    String? query,
    List<String>? tags,
  }) {
    return Search(
      uid: uid ?? this.uid,
      query: query ?? this.query,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'query': query,
      'tags': tags,
    };
  }

  factory Search.fromMap(Map<String, dynamic> map) {
    return Search(
      uid: map['uid'] as String,
      query: map['query'] as String,
      tags: List<String>.from(map['tags']),
    );
  }

  @override
  String toString() => 'Member(uid: $uid, query: $query, tags: $tags)';

  @override
  bool operator ==(covariant Search other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.query == query &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode => uid.hashCode ^ query.hashCode ^ tags.hashCode;
}
