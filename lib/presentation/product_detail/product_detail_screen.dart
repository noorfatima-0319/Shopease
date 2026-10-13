import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/add_to_cart_button.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/network_image.dart';
import '../../core/widgets/rating_stars.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../injection/injection_container.dart';
import '../cart/cubit/cart_cubit.dart';
import '../wishlist/cubit/wishlist_cubit.dart';
import 'cubit/product_detail_cubit.dart';
import 'cubit/product_detail_state.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailCubit(
        sl<ProductRepository>(),
        sl<CartRepository>(),
        sl<WishlistRepository>(),
        sl<CartCubit>(),
        sl<WishlistCubit>(),
      )..loadProduct(productId),
      child: _ProductDetailView(productId: productId),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  final int productId;
  const _ProductDetailView({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state.status == ProductDetailStatus.error) {
            return SafeArea(
              child: ErrorView(
                message: state.errorMessage ?? 'Unable to load this product',
                onRetry: () => context.read<ProductDetailCubit>().loadProduct(productId),
              ),
            );
          }

          if (state.status == ProductDetailStatus.loading || state.product == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = state.product!;
          final hasDiscount = product.discountPercentage > 0;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 340,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    actions: [
                      IconButton(
                        icon: Icon(
                          state.isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: state.isInWishlist ? AppColors.primary : null,
                        ),
                        onPressed: () => context.read<ProductDetailCubit>().toggleWishlist(),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'product-image-${product.id}',
                        child: _ImageCarousel(images: product.images.isNotEmpty ? product.images : [product.thumbnail]),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.brand.toUpperCase(),
                                style: const TextStyle(color: AppColors.inkSoft, fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            RatingStars(rating: product.rating, reviewCount: product.reviews.length),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text('\$${product.discountedPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                if (hasDiscount) ...[
                                  const SizedBox(width: 10),
                                  Text('\$${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppColors.inkSoft)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                                    child: Text('${product.discountPercentage.toStringAsFixed(0)}% off',
                                        style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.stock > 0 ? '${product.stock} in stock' : 'Out of stock',
                              style: TextStyle(fontSize: 12, color: product.stock > 0 ? AppColors.success : AppColors.danger),
                            ),
                            const SizedBox(height: 16),
                            const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(product.description, style: const TextStyle(height: 1.5)),
                            const SizedBox(height: 20),
                            Text('Reviews (${product.reviews.length})', style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            if (product.reviews.isEmpty)
                              const Text('No reviews yet.', style: TextStyle(color: AppColors.inkSoft))
                            else
                              ...product.reviews.map((review) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                            const SizedBox(width: 8),
                                            RatingStars(rating: review.rating, size: 11),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(review.comment, style: const TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: const Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        _QuantityStepper(
                          quantity: state.quantity,
                          onDecrease: () => context.read<ProductDetailCubit>().decreaseQuantity(),
                          onIncrease: () => context.read<ProductDetailCubit>().increaseQuantity(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AddToCartButton(
                            enabled: product.stock > 0,
                            onAddToCart: () => context.read<ProductDetailCubit>().addToCart(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0, left: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// A real swipeable carousel: PageView + dot indicator, not a static
// image with a separate thumbnail strip underneath.
class _ImageCarousel extends StatefulWidget {
  final List<String> images;
  const _ImageCarousel({required this.images});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          onPageChanged: (index) => setState(() => _index = index),
          itemBuilder: (context, index) {
            return AppNetworkImage(url: widget.images[index], fit: BoxFit.cover);
          },
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityStepper({required this.quantity, required this.onDecrease, required this.onIncrease});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.remove, size: 18), onPressed: onDecrease),
          Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w600)),
          IconButton(icon: const Icon(Icons.add, size: 18), onPressed: onIncrease),
        ],
      ),
    );
  }
}
