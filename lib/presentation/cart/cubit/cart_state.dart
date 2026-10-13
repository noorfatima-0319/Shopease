import '../../../data/models/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }
}
