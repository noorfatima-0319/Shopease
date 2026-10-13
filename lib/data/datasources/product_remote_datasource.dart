import 'package:dio/dio.dart';

import '../models/product_model.dart';

// Talks to DummyJSON only. Nothing above this layer knows it's Dio
// or that the URL is dummyjson.com — that's the point of a data source.
class ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSource(this.dio);

  Future<List<ProductModel>> getAllProducts({int limit = 100}) async {
    final response = await dio.get('/products', queryParameters: {'limit': limit});
    final List<dynamic> list = response.data['products'] as List<dynamic>;
    return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await dio.get('/products/$id');
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await dio.get('/products/search', queryParameters: {'q': query});
    final List<dynamic> list = response.data['products'] as List<dynamic>;
    return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<String>> getCategories() async {
    final response = await dio.get('/products/categories');
    final List<dynamic> list = response.data as List<dynamic>;
    // DummyJSON returns objects like {slug, name, url}; fall back to
    // plain strings if the shape differs.
    // slug matches the value stored on each product's `category` field;
    // `name` is only used for display, via formatCategoryLabel().
    return list.map((e) {
      if (e is Map) return (e['slug'] ?? e['name'] ?? '').toString();
      return e.toString();
    }).where((s) => s.isNotEmpty).toList();
  }
}
