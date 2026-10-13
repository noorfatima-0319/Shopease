import '../../../data/models/product_model.dart';

enum ProductDetailStatus { loading, loaded, error }

class ProductDetailState {
  final ProductDetailStatus status;
  final ProductModel? product;
  final int quantity;
  final bool isInWishlist;
  final String? errorMessage;

  const ProductDetailState({
    this.status = ProductDetailStatus.loading,
    this.product,
    this.quantity = 1,
    this.isInWishlist = false,
    this.errorMessage,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductModel? product,
    int? quantity,
    bool? isInWishlist,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      errorMessage: errorMessage,
    );
  }
}
