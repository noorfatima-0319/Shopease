import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/wishlist_repository.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository repository;

  WishlistCubit(this.repository)
      : super(WishlistState(items: repository.getWishlistItems()));

  void refresh() {
    emit(state.copyWith(items: repository.getWishlistItems()));
  }

  Future<void> removeItem(int productId) async {
    await repository.removeItem(productId);
    refresh();
  }
}
