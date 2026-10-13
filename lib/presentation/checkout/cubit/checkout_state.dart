import '../../../data/models/address_model.dart';
import '../../../data/models/order_model.dart';

enum CheckoutStatus { idle, placing, placed, error }

class CheckoutState {
  final CheckoutStatus status;
  final AddressModel? savedAddress;
  final String paymentMethod; // 'Cash on Delivery' or 'Card'
  final OrderModel? placedOrder;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.idle,
    this.savedAddress,
    this.paymentMethod = 'Cash on Delivery',
    this.placedOrder,
    this.errorMessage,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    AddressModel? savedAddress,
    String? paymentMethod,
    OrderModel? placedOrder,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      savedAddress: savedAddress ?? this.savedAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      placedOrder: placedOrder ?? this.placedOrder,
      errorMessage: errorMessage,
    );
  }
}
