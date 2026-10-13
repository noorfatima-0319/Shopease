import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/network_image.dart';
import '../../routes/app_router.dart';
import 'cubit/wishlist_cubit.dart';
import 'cubit/wishlist_state.dart';

// WishlistCubit is a shared app-wide singleton, provided once in
// main.dart, so this screen reads it directly rather than creating
// its own copy.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _WishlistView();
  }
}

class _WishlistView extends StatelessWidget {
  const _WishlistView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border,
              title: 'Your wishlist is empty',
              subtitle: 'Tap the heart icon on a product to save it here.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  onTap: () => context.push('${AppRoutes.productDetail}/${item.productId}'),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: AppNetworkImage(url: item.thumbnail, width: 48, height: 48),
                  ),
                  title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: AppColors.primary),
                    onPressed: () => context.read<WishlistCubit>().removeItem(item.productId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
