import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Shows real rating values only; never a fabricated number.
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final int? reviewCount;

  const RatingStars({super.key, required this.rating, this.size = 14, this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: size, color: AppColors.star),
        const SizedBox(width: 3),
        Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: size, fontWeight: FontWeight.w600)),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text('($reviewCount)', style: TextStyle(fontSize: size - 2, color: AppColors.inkSoft)),
        ],
      ],
    );
  }
}
