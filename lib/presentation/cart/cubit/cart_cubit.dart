import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../domain/repositories/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;

  CartCubit(this.repository) : super(CartState(items: repository.getCartItems()));

  void refresh() {
    emit(state.copyWith(items: repository.getCartItems()));
  }

  Future<void> updateQuantity(CartItemModel item, int quantity) async {
    if (quantity <= 0) {
      await repository.removeItem(item.productId);
    } else {
      item.quantity = quantity;
      await repository.addOrUpdate(item);
    }
    refresh();
  }

  Future<void> removeItem(int productId) async {
    await repository.removeItem(productId);
    refresh();
  }

  Future<void> clearCart() async {
    await repository.clearCart();
    refresh();
  }
}
