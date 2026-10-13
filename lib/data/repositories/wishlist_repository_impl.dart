import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_datasource.dart';
import '../models/wishlist_item_model.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource local;

  WishlistRepositoryImpl(this.local);

  @override
  List<WishlistItemModel> getWishlistItems() => local.getAll();

  @override
  bool isInWishlist(int productId) => local.contains(productId);

  @override
  Future<void> addItem(WishlistItemModel item) => local.add(item);

  @override
  Future<void> removeItem(int productId) => local.remove(productId);
}
