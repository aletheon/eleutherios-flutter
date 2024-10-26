import 'package:reddit_tutorial/models/shopping_cart_item.dart';

class ShoppingCartItemDisplay {
  final String type;
  final ShoppingCartItem shoppingCartItem;
  ShoppingCartItemDisplay({
    required this.type,
    required this.shoppingCartItem,
  });

  ShoppingCartItemDisplay copyWith({
    String? type,
    ShoppingCartItem? shoppingCartItem,
  }) {
    return ShoppingCartItemDisplay(
      type: type ?? this.type,
      shoppingCartItem: shoppingCartItem ?? this.shoppingCartItem,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'shoppingCartItem': shoppingCartItem.toMap(),
    };
  }

  factory ShoppingCartItemDisplay.fromMap(Map<String, dynamic> map) {
    return ShoppingCartItemDisplay(
      type: map['type'] as String,
      shoppingCartItem: ShoppingCartItem.fromMap(
          map['shoppingCartItem'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() =>
      'ShoppingCartItemDisplay(type: $type, shoppingCartItem: $shoppingCartItem)';

  @override
  bool operator ==(covariant ShoppingCartItemDisplay other) {
    if (identical(this, other)) return true;

    return other.type == type && other.shoppingCartItem == shoppingCartItem;
  }

  @override
  int get hashCode => type.hashCode ^ shoppingCartItem.hashCode;
}
