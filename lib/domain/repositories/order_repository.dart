import '../../data/models/address_model.dart';
import '../../data/models/order_model.dart';

abstract class OrderRepository {
  List<OrderModel> getOrders();
  Future<void> placeOrder(OrderModel order);
  AddressModel? getSavedAddress();
  Future<void> saveAddress(AddressModel address);
}
