import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/address_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../domain/repositories/cart_repository.dart';
import '../../../domain/repositories/order_repository.dart';
import '../../cart/cubit/cart_cubit.dart';
import 'checkout_state.dart';

// Payment note: a real Stripe PaymentSheet needs a PaymentIntent created
// by a server holding the Stripe secret key. Without a deployed backend,
// "Card" here is a placeholder path for that future integration, and
// Cash on Delivery is the fully working, testable checkout method,
// exactly as the task allows ("Stripe PaymentSheet or cash on delivery").
class CheckoutCubit extends Cubit<CheckoutState> {
  final OrderRepository orderRepository;
  final CartRepository cartRepository;
  final CartCubit cartCubit;

  CheckoutCubit(this.orderRepository, this.cartRepository, this.cartCubit)
      : super(CheckoutState(savedAddress: orderRepository.getSavedAddress()));

  void setPaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }

  Future<void> saveAddress(AddressModel address) async {
    await orderRepository.saveAddress(address);
    emit(state.copyWith(savedAddress: address));
  }

  Future<void> placeOrder(List<CartItemModel> items, double total) async {
    if (state.savedAddress == null) {
      emit(state.copyWith(status: CheckoutStatus.error, errorMessage: 'Add a delivery address first'));
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.placing));
    try {
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: items,
        total: total,
        address: state.savedAddress!,
        status: OrderStatus.placed,
        placedAt: DateTime.now(),
        paymentMethod: state.paymentMethod,
      );

      await orderRepository.placeOrder(order);
      await cartRepository.clearCart();
      cartCubit.refresh();

      emit(state.copyWith(status: CheckoutStatus.placed, placedOrder: order));
    } catch (e) {
      emit(state.copyWith(status: CheckoutStatus.error, errorMessage: e.toString()));
    }
  }
}
