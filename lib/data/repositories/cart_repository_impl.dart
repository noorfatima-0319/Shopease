import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource local;

  CartRepositoryImpl(this.local);

  @override
  List<CartItemModel> getCartItems() => local.getAll();

  @override
  Future<void> addOrUpdate(CartItemModel item) => local.upsert(item);

  @override
  Future<void> removeItem(int productId) => local.remove(productId);

  @override
  Future<void> clearCart() => local.clear();
}
