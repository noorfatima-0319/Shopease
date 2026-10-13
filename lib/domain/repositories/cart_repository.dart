import '../../data/models/cart_item_model.dart';

abstract class CartRepository {
  List<CartItemModel> getCartItems();
  Future<void> addOrUpdate(CartItemModel item);
  Future<void> removeItem(int productId);
  Future<void> clearCart();
}
