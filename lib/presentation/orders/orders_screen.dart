import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/order_model.dart';
import '../../domain/repositories/order_repository.dart';
import '../../injection/injection_container.dart';
import 'cubit/orders_cubit.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(sl<OrderRepository>()),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrdersCubit, List<OrderModel>>(
        builder: (context, orders) {
          if (orders.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              subtitle: 'Orders you place will show up here.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _OrderCard(order: orders[index]),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    const steps = OrderStatus.values;
    final currentIndex = steps.indexOf(order.status);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order.id.substring(order.id.length - 6)}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('\$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 4),
            Text('${order.items.length} item(s) · ${order.paymentMethod}',
                style: const TextStyle(color: AppColors.inkSoft, fontSize: 12)),
            const SizedBox(height: 14),
            Row(
              children: List.generate(steps.length * 2 - 1, (i) {
                if (i.isOdd) {
                  final leftDone = (i - 1) ~/ 2 <= currentIndex;
                  return Expanded(
                    child: Container(height: 2, color: leftDone ? AppColors.primary : AppColors.border),
                  );
                }
                final stepIndex = i ~/ 2;
                final done = stepIndex <= currentIndex;
                return Column(
                  children: [
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? AppColors.primary : AppColors.border,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps
                  .map((s) => Text(s.label, style: const TextStyle(fontSize: 10, color: AppColors.inkSoft)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
