import '../../domain/repositories/order_repository.dart';
import '../datasources/address_local_datasource.dart';
import '../datasources/order_local_datasource.dart';
import '../models/address_model.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource ordersLocal;
  final AddressLocalDataSource addressLocal;

  OrderRepositoryImpl(this.ordersLocal, this.addressLocal);

  @override
  List<OrderModel> getOrders() => ordersLocal.getAll();

  @override
  Future<void> placeOrder(OrderModel order) => ordersLocal.save(order);

  @override
  AddressModel? getSavedAddress() => addressLocal.get();

  @override
  Future<void> saveAddress(AddressModel address) => addressLocal.save(address);
}
