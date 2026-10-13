import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/address_model.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../../injection/injection_container.dart';
import '../../routes/app_router.dart';
import '../cart/cubit/cart_cubit.dart';
import '../cart/cubit/cart_state.dart';
import 'cubit/checkout_cubit.dart';
import 'cubit/checkout_state.dart';

// CartCubit is a shared app-wide singleton, provided once in main.dart.
// Only CheckoutCubit needs to be created locally, since checkout state
// doesn't need to persist once the user leaves this screen.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutCubit(sl<OrderRepository>(), sl<CartRepository>(), sl<CartCubit>()),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final saved = context.read<CheckoutCubit>().state.savedAddress;
    if (saved != null) {
      _nameController.text = saved.fullName;
      _phoneController.text = saved.phone;
      _addressController.text = saved.addressLine;
      _cityController.text = saved.city;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'This field is required' : null;

  Future<void> _placeOrder(CartState cartState) async {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressModel(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine: _addressController.text.trim(),
      city: _cityController.text.trim(),
    );

    final cubit = context.read<CheckoutCubit>();
    await cubit.saveAddress(address);
    await cubit.placeOrder(cartState.items, cartState.subtotal);

    if (!mounted) return;

    final state = cubit.state;
    if (state.status == CheckoutStatus.placed && state.placedOrder != null) {
      context.go(AppRoutes.orderConfirmation, extra: state.placedOrder);
    } else if (state.status == CheckoutStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Could not place order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 10),
                TextFormField(controller: _nameController, validator: _required,
                    decoration: const InputDecoration(labelText: 'Full name')),
                const SizedBox(height: 10),
                TextFormField(controller: _phoneController, validator: _required,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone number')),
                const SizedBox(height: 10),
                TextFormField(controller: _addressController, validator: _required,
                    decoration: const InputDecoration(labelText: 'Address')),
                const SizedBox(height: 10),
                TextFormField(controller: _cityController, validator: _required,
                    decoration: const InputDecoration(labelText: 'City')),
                const SizedBox(height: 24),
                const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 10),
                BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (context, checkoutState) {
                    return Column(
                      children: [
                        RadioGroup<String>(
                          groupValue: checkoutState.paymentMethod,
                          onChanged: (value) => context.read<CheckoutCubit>().setPaymentMethod(value!),
                          child: const Column(
                            children: [
                              RadioListTile<String>(
                                value: 'Cash on Delivery',
                                title: Text('Cash on Delivery'),
                                subtitle: Text('Pay when your order arrives'),
                                contentPadding: EdgeInsets.zero,
                              ),
                              RadioListTile<String>(
                                value: 'Card',
                                title: Text('Card (Stripe test mode)'),
                                subtitle: Text('Requires a payment server; not available in this build'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 10),
                ...cartState.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('${item.title} x${item.quantity}', overflow: TextOverflow.ellipsis)),
                          Text('\$${item.lineTotal.toStringAsFixed(2)}'),
                        ],
                      ),
                    )),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('\$${cartState.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text('By placing this order you agree to our ', style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.terms),
                      child: const Text('Terms', style: TextStyle(fontSize: 12, color: AppColors.primary, decoration: TextDecoration.underline)),
                    ),
                    const Text(' and ', style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.privacyPolicy),
                      child: const Text('Privacy Policy', style: TextStyle(fontSize: 12, color: AppColors.primary, decoration: TextDecoration.underline)),
                    ),
                    const Text('.', style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, checkoutState) {
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: checkoutState.status == CheckoutStatus.placing
                          ? null
                          : () => _placeOrder(cartState),
                      child: checkoutState.status == CheckoutStatus.placing
                          ? const SizedBox(height: 18, width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Place Order'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
