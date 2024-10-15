import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
import 'package:reddit_tutorial/models/shopping_cart_member.dart';

class ShoppingCartForumMember {
  final Forum? forum;
  final ShoppingCart? shoppingCart;
  final ShoppingCartItem? shoppingCartItem;
  final Service? selectedService;
  ShoppingCartForumMember({
    required this.forum,
    required this.shoppingCart,
    required this.shoppingCartItem,
    required this.selectedService,
  });

  ShoppingCartForumMember copyWith({
    Forum? forum,
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    Service? selectedService,
    List<ShoppingCartMember>? shoppingCartMembers,
  }) {
    return ShoppingCartForumMember(
      forum: forum ?? this.forum,
      shoppingCart: shoppingCart ?? this.shoppingCart,
      shoppingCartItem: shoppingCartItem ?? this.shoppingCartItem,
      selectedService: selectedService ?? this.selectedService,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forum': forum!.toMap(),
      'shoppingCart': shoppingCart!.toMap(),
      'shoppingCartItem': shoppingCartItem!.toMap(),
      'selectedService': selectedService!.toMap(),
    };
  }

  factory ShoppingCartForumMember.fromMap(Map<String, dynamic> map) {
    return ShoppingCartForumMember(
      forum: Forum.fromMap(map['forum'] as Map<String, dynamic>),
      shoppingCart:
          ShoppingCart.fromMap(map['shoppingCart'] as Map<String, dynamic>),
      shoppingCartItem: ShoppingCartItem.fromMap(
          map['shoppingCartItem'] as Map<String, dynamic>),
      selectedService:
          Service.fromMap(map['selectedService'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() =>
      'ShoppingCartForumMember(forum: $forum, shoppingCart: $shoppingCart, shoppingCartItem: $shoppingCartItem, selectedService: $selectedService)';

  @override
  bool operator ==(covariant ShoppingCartForumMember other) {
    if (identical(this, other)) return true;

    return other.forum == forum &&
        other.shoppingCart == shoppingCart &&
        other.shoppingCartItem == shoppingCartItem &&
        other.selectedService == selectedService;
  }

  @override
  int get hashCode =>
      forum.hashCode ^
      shoppingCart.hashCode ^
      shoppingCartItem.hashCode ^
      selectedService.hashCode;
}
