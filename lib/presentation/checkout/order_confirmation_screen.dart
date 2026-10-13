import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../../routes/app_router.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: AppColors.success, size: 72),
              const SizedBox(height: 16),
              const Text('Order placed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Order #${order.id.substring(order.id.length - 6)}',
                  style: const TextStyle(color: AppColors.inkSoft)),
              const SizedBox(height: 4),
              Text('Payment method: ${order.paymentMethod}', style: const TextStyle(color: AppColors.inkSoft)),
              const SizedBox(height: 4),
              Text('Total: \$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.push(AppRoutes.orders),
                  child: const Text('View Orders'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Continue Shopping'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
