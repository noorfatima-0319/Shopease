import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/cart_item_model.dart';

// All reads/writes to the cart Hive box live here, and nowhere else.
class CartLocalDataSource {
  Box get _box => Hive.box(AppConstants.cartBox);

  List<CartItemModel> getAll() {
    return _box.values
        .map((e) => CartItemModel.fromMap(e as Map))
        .toList();
  }

  Future<void> upsert(CartItemModel item) async {
    await _box.put(item.productId.toString(), item.toMap());
  }

  Future<void> remove(int productId) async {
    await _box.delete(productId.toString());
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
