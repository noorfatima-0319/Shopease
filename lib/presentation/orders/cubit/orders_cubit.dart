import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/order_model.dart';
import '../../../domain/repositories/order_repository.dart';

class OrdersCubit extends Cubit<List<OrderModel>> {
  final OrderRepository repository;

  OrdersCubit(this.repository) : super(repository.getOrders());

  void refresh() {
    emit(repository.getOrders());
  }
}
