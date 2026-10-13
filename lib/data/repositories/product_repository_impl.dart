import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<List<ProductModel>> getAllProducts() => remote.getAllProducts();

  @override
  Future<ProductModel> getProductById(int id) => remote.getProductById(id);

  @override
  Future<List<ProductModel>> searchProducts(String query) => remote.searchProducts(query);

  @override
  Future<List<String>> getCategories() => remote.getCategories();
}
