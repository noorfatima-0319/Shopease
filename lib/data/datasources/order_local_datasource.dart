import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/order_model.dart';

class OrderLocalDataSource {
  Box get _box => Hive.box(AppConstants.ordersBox);

  List<OrderModel> getAll() {
    final orders = _box.values.map((e) => OrderModel.fromMap(e as Map)).toList();
    orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return orders;
  }

  Future<void> save(OrderModel order) async {
    await _box.put(order.id, order.toMap());
  }
}
