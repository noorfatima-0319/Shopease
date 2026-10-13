import '../../data/models/product_model.dart';

// The presentation layer only ever talks to this interface, never to
// Dio or DummyJSON directly.
abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<String>> getCategories();
}
