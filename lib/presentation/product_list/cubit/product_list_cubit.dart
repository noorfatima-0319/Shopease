import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/product_repository.dart';
import 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ProductRepository repository;

  ProductListCubit(this.repository) : super(const ProductListState());

  Future<void> loadProducts({String? initialCategory}) async {
    emit(state.copyWith(status: ProductListStatus.loading));
    try {
      final products = await repository.getAllProducts();
      final highestPrice = products.isEmpty
          ? 0.0
          : products.map((p) => p.discountedPrice).reduce((a, b) => a > b ? a : b);
      final ceiling = (highestPrice).ceilToDouble();

      emit(state.copyWith(
        status: ProductListStatus.loaded,
        allProducts: products,
        categoryFilter: initialCategory,
        minPrice: 0,
        maxPrice: ceiling,
        priceCeiling: ceiling,
        minRating: 0,
      ));
      _applyFilters();
    } catch (e) {
      emit(state.copyWith(status: ProductListStatus.error, errorMessage: e.toString()));
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void setCategoryFilter(String? category) {
    if (category == null) {
      emit(state.copyWith(clearCategoryFilter: true));
    } else {
      emit(state.copyWith(categoryFilter: category));
    }
    _applyFilters();
  }

  void setSortOption(SortOption option) {
    emit(state.copyWith(sortOption: option));
    _applyFilters();
  }

  // Applied together when the user confirms the filter sheet, so the
  // list only rebuilds once rather than on every slider tick.
  void applyPriceAndRatingFilter({required double minPrice, required double maxPrice, required double minRating}) {
    emit(state.copyWith(minPrice: minPrice, maxPrice: maxPrice, minRating: minRating));
    _applyFilters();
  }

  void resetFilters() {
    emit(state.copyWith(
      clearCategoryFilter: true,
      minPrice: 0,
      maxPrice: state.priceCeiling,
      minRating: 0,
    ));
    _applyFilters();
  }

  // All filtering/sorting logic lives here, not in the widget tree.
  void _applyFilters() {
    var list = [...state.allProducts];

    if (state.categoryFilter != null) {
      list = list.where((p) => p.category == state.categoryFilter).toList();
    }

    if (state.searchQuery.trim().isNotEmpty) {
      final q = state.searchQuery.trim().toLowerCase();
      list = list.where((p) => p.title.toLowerCase().contains(q)).toList();
    }

    list = list.where((p) => p.discountedPrice >= state.minPrice && p.discountedPrice <= state.maxPrice).toList();

    if (state.minRating > 0) {
      list = list.where((p) => p.rating >= state.minRating).toList();
    }

    switch (state.sortOption) {
      case SortOption.priceLowHigh:
        list.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case SortOption.priceHighLow:
        list.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case SortOption.ratingHighLow:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.none:
        break;
    }

    emit(state.copyWith(visibleProducts: list));
  }
}
