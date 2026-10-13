import '../../../data/models/product_model.dart';

enum ProductListStatus { initial, loading, loaded, error }
enum SortOption { none, priceLowHigh, priceHighLow, ratingHighLow }

class ProductListState {
  final ProductListStatus status;
  final List<ProductModel> allProducts; // unfiltered, as loaded
  final List<ProductModel> visibleProducts; // after search/filter/sort
  final String searchQuery;
  final String? categoryFilter; // null = all categories
  final SortOption sortOption;
  final double minPrice;
  final double maxPrice; // current upper bound of the price filter
  final double priceCeiling; // highest price among all loaded products
  final double minRating; // 0 = no minimum
  final String? errorMessage;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.allProducts = const [],
    this.visibleProducts = const [],
    this.searchQuery = '',
    this.categoryFilter,
    this.sortOption = SortOption.none,
    this.minPrice = 0,
    this.maxPrice = 0,
    this.priceCeiling = 0,
    this.minRating = 0,
    this.errorMessage,
  });

  bool get hasActiveFilters =>
      categoryFilter != null || minRating > 0 || maxPrice < priceCeiling;

  ProductListState copyWith({
    ProductListStatus? status,
    List<ProductModel>? allProducts,
    List<ProductModel>? visibleProducts,
    String? searchQuery,
    String? categoryFilter,
    bool clearCategoryFilter = false,
    SortOption? sortOption,
    double? minPrice,
    double? maxPrice,
    double? priceCeiling,
    double? minRating,
    String? errorMessage,
  }) {
    return ProductListState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      visibleProducts: visibleProducts ?? this.visibleProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: clearCategoryFilter ? null : (categoryFilter ?? this.categoryFilter),
      sortOption: sortOption ?? this.sortOption,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      priceCeiling: priceCeiling ?? this.priceCeiling,
      minRating: minRating ?? this.minRating,
      errorMessage: errorMessage,
    );
  }
}
