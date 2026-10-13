import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/product_repository.dart';
import 'home_state.dart';

// Widgets never call the repository themselves — they call cubit
// methods, and rebuild only from the emitted state.
class HomeCubit extends Cubit<HomeState> {
  final ProductRepository repository;

  HomeCubit(this.repository) : super(const HomeState());

  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final products = await repository.getAllProducts();
      final categories = await repository.getCategories();

      final sortedByRating = [...products]..sort((a, b) => b.rating.compareTo(a.rating));
      final featured = sortedByRating.take(8).toList();

      final sortedById = [...products]..sort((a, b) => b.id.compareTo(a.id));
      final newArrivals = sortedById.take(8).toList();

      emit(state.copyWith(
        status: HomeStatus.loaded,
        featured: featured,
        newArrivals: newArrivals,
        categories: categories.take(10).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: e.toString()));
    }
  }
}
