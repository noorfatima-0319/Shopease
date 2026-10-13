import '../../../data/models/product_model.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState {
  final HomeStatus status;
  final List<ProductModel> featured;
  final List<ProductModel> newArrivals;
  final List<String> categories;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.featured = const [],
    this.newArrivals = const [],
    this.categories = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ProductModel>? featured,
    List<ProductModel>? newArrivals,
    List<String>? categories,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      featured: featured ?? this.featured,
      newArrivals: newArrivals ?? this.newArrivals,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }
}
