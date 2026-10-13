import 'review_model.dart';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> images;
  final String thumbnail;
  final String brand;
  final List<ReviewModel> reviews;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.images,
    required this.thumbnail,
    required this.brand,
    required this.reviews,
  });

  double get discountedPrice => price - (price * discountPercentage / 100);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final reviewsJson = json['reviews'] as List<dynamic>? ?? [];
    final imagesJson = json['images'] as List<dynamic>? ?? [];

    return ProductModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      images: imagesJson.map((e) => e.toString()).toList(),
      thumbnail: (json['thumbnail'] as String?) ?? '',
      brand: (json['brand'] as String?) ?? '',
      reviews: reviewsJson
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
