import '../../data/models/wishlist_item_model.dart';

abstract class WishlistRepository {
  List<WishlistItemModel> getWishlistItems();
  bool isInWishlist(int productId);
  Future<void> addItem(WishlistItemModel item);
  Future<void> removeItem(int productId);
}
