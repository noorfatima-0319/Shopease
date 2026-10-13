import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/text_format.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/shimmer_placeholder.dart';
import '../../routes/app_router.dart';
import '../cart/cubit/cart_cubit.dart';
import '../cart/cubit/cart_state.dart';
import '../wishlist/cubit/wishlist_cubit.dart';
import '../wishlist/cubit/wishlist_state.dart';
import '../../injection/injection_container.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CartCubit and WishlistCubit are app-wide singletons provided once
    // in main.dart, so Home only needs to create its own HomeCubit.
    return BlocProvider(
      create: (_) => HomeCubit(sl())..loadHome(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopEase'),
        actions: [
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, wishlistState) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    tooltip: 'Wishlist',
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () => context.push(AppRoutes.wishlist),
                  ),
                  if (wishlistState.items.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: _Badge(count: wishlistState.items.length),
                    ),
                ],
              );
            },
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    tooltip: 'Cart',
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => context.push(AppRoutes.cart),
                  ),
                  if (cartState.itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: _Badge(count: cartState.itemCount),
                    ),
                ],
              );
            },
          ),
          IconButton(
            tooltip: 'Orders',
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => context.push(AppRoutes.orders),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.error) {
            return ErrorView(
              message: state.errorMessage ?? 'Unable to load products',
              onRetry: () => context.read<HomeCubit>().loadHome(),
            );
          }

          final loading = state.status != HomeStatus.loaded;

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadHome(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.productList),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 10),
                          Text('Search products', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New season arrivals',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Browse the latest products added to the catalogue.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!loading && state.categories.isNotEmpty) ...[
                  const SectionTitle(title: 'Categories'),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        return ActionChip(
                          label: Text(formatCategoryLabel(category)),
                          onPressed: () => context.push('${AppRoutes.productList}?category=$category'),
                        );
                      },
                    ),
                  ),
                ],
                SectionTitle(
                  title: 'Featured',
                  onSeeAll: () => context.push(AppRoutes.productList),
                ),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: loading ? 4 : state.featured.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (loading) return const ProductCardShimmer();
                      final product = state.featured[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('${AppRoutes.productDetail}/${product.id}'),
                      );
                    },
                  ),
                ),
                const SectionTitle(title: 'New Arrivals'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: loading
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.62,
                          ),
                          itemBuilder: (context, index) => const ProductCardShimmer(),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.newArrivals.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.62,
                          ),
                          itemBuilder: (context, index) {
                            final product = state.newArrivals[index];
                            return ProductCard(
                              product: product,
                              width: double.infinity,
                              onTap: () => context.push('${AppRoutes.productDetail}/${product.id}'),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
