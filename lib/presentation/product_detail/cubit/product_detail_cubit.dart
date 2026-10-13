import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/wishlist_item_model.dart';
import '../../../domain/repositories/cart_repository.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/repositories/wishlist_repository.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../wishlist/cubit/wishlist_cubit.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository productRepository;
  final CartRepository cartRepository;
  final WishlistRepository wishlistRepository;
  final CartCubit cartCubit;
  final WishlistCubit wishlistCubit;

  ProductDetailCubit(
    this.productRepository,
    this.cartRepository,
    this.wishlistRepository,
    this.cartCubit,
    this.wishlistCubit,
  ) : super(const ProductDetailState());

  Future<void> loadProduct(int id) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    try {
      final product = await productRepository.getProductById(id);
      emit(state.copyWith(
        status: ProductDetailStatus.loaded,
        product: product,
        quantity: 1,
        isInWishlist: wishlistRepository.isInWishlist(id),
      ));
    } catch (e) {
      emit(state.copyWith(status: ProductDetailStatus.error, errorMessage: e.toString()));
    }
  }

  void increaseQuantity() {
    final product = state.product;
    if (product == null) return;
    if (state.quantity >= product.stock) return;
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decreaseQuantity() {
    if (state.quantity <= 1) return;
    emit(state.copyWith(quantity: state.quantity - 1));
  }

  Future<void> addToCart() async {
    final product = state.product;
    if (product == null) return;

    final existing = cartRepository
        .getCartItems()
        .where((item) => item.productId == product.id);

    final newQuantity =
        (existing.isEmpty ? 0 : existing.first.quantity) + state.quantity;

    await cartRepository.addOrUpdate(CartItemModel(
      productId: product.id,
      title: product.title,
      thumbnail: product.thumbnail,
      price: product.discountedPrice,
      quantity: newQuantity,
    ));

    cartCubit.refresh();
  }

  Future<void> toggleWishlist() async {
    final product = state.product;
    if (product == null) return;

    if (state.isInWishlist) {
      await wishlistRepository.removeItem(product.id);
      emit(state.copyWith(isInWishlist: false));
      wishlistCubit.refresh();
    } else {
      await wishlistRepository.addItem(WishlistItemModel(
        productId: product.id,
        title: product.title,
        thumbnail: product.thumbnail,
        price: product.discountedPrice,
      ));
      emit(state.copyWith(isInWishlist: true));
      wishlistCubit.refresh();
    }
  }
}
