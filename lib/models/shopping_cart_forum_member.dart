import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart_member.dart';

class ShoppingCartForumMember {
  final Forum? forum;
  final Service? selectedService;
  ShoppingCartForumMember({
    required this.forum,
    required this.selectedService,
  });

  ShoppingCartForumMember copyWith({
    Forum? forum,
    Service? selectedService,
    List<ShoppingCartMember>? shoppingCartMembers,
  }) {
    return ShoppingCartForumMember(
      forum: forum ?? this.forum,
      selectedService: selectedService ?? this.selectedService,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forum': forum!.toMap(),
      'selectedService': selectedService!.toMap(),
    };
  }

  factory ShoppingCartForumMember.fromMap(Map<String, dynamic> map) {
    return ShoppingCartForumMember(
      forum: Forum.fromMap(map['forum'] as Map<String, dynamic>),
      selectedService:
          Service.fromMap(map['selectedService'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() =>
      'ShoppingCartForumMember(forum: $forum, selectedService: $selectedService)';

  @override
  bool operator ==(covariant ShoppingCartForumMember other) {
    if (identical(this, other)) return true;

    return other.forum == forum && other.selectedService == selectedService;
  }

  @override
  int get hashCode => forum.hashCode ^ selectedService.hashCode;
}
