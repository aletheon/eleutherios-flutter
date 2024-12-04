import 'package:reddit_tutorial/models/shopping_cart_item.dart';

class ShoppingCartItemDisplay {
  final String type;
  final ShoppingCartItem shoppingCartItem;
  final bool userEndMarker;
  final bool endMarker;
  ShoppingCartItemDisplay({
    required this.type,
    required this.shoppingCartItem,
    required this.userEndMarker,
    required this.endMarker,
  });

  ShoppingCartItemDisplay copyWith({
    String? type,
    ShoppingCartItem? shoppingCartItem,
    bool? userStartMarker,
    bool? startMarker,
    bool? userEndMarker,
    bool? endMarker,
  }) {
    return ShoppingCartItemDisplay(
      type: type ?? this.type,
      shoppingCartItem: shoppingCartItem ?? this.shoppingCartItem,
      userEndMarker: userEndMarker ?? this.userEndMarker,
      endMarker: endMarker ?? this.endMarker,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'shoppingCartItem': shoppingCartItem.toMap(),
      'userEndMarker': userEndMarker,
      'endMarker': endMarker,
    };
  }

  factory ShoppingCartItemDisplay.fromMap(Map<String, dynamic> map) {
    return ShoppingCartItemDisplay(
      type: map['type'] as String,
      shoppingCartItem: ShoppingCartItem.fromMap(
          map['shoppingCartItem'] as Map<String, dynamic>),
      userEndMarker: map['userEndMarker'] as bool,
      endMarker: map['endMarker'] as bool,
    );
  }

  @override
  String toString() =>
      'ShoppingCartItemDisplay(type: $type, shoppingCartItem: $shoppingCartItem, userEndMarker: $userEndMarker, endMarker: $endMarker,)';

  @override
  bool operator ==(covariant ShoppingCartItemDisplay other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.shoppingCartItem == shoppingCartItem &&
        other.userEndMarker &&
        other.endMarker;
  }

  @override
  int get hashCode =>
      type.hashCode ^
      shoppingCartItem.hashCode ^
      userEndMarker.hashCode ^
      endMarker.hashCode;
}
