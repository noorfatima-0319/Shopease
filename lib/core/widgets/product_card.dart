import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';
import '../theme/app_theme.dart';
import 'network_image.dart';
import 'rating_stars.dart';

// One product card used by Home, Product List and Wishlist, so the
// product layout never has to be rebuilt per-screen.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final double width;

  const ProductCard({super.key, required this.product, required this.onTap, this.width = 160});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPercentage > 0;

    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Hero(
                    tag: 'product-image-${product.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AppNetworkImage(url: product.thumbnail),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                RatingStars(rating: product.rating, size: 12),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 6),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.inkSoft,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
