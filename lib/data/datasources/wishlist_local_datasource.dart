import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/wishlist_item_model.dart';

class WishlistLocalDataSource {
  Box get _box => Hive.box(AppConstants.wishlistBox);

  List<WishlistItemModel> getAll() {
    return _box.values
        .map((e) => WishlistItemModel.fromMap(e as Map))
        .toList();
  }

  bool contains(int productId) => _box.containsKey(productId.toString());

  Future<void> add(WishlistItemModel item) async {
    await _box.put(item.productId.toString(), item.toMap());
  }

  Future<void> remove(int productId) async {
    await _box.delete(productId.toString());
  }
}
