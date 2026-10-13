class WishlistItemModel {
  final int productId;
  final String title;
  final String thumbnail;
  final double price;

  const WishlistItemModel({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
  });

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'title': title,
        'thumbnail': thumbnail,
        'price': price,
      };

  factory WishlistItemModel.fromMap(Map<dynamic, dynamic> map) => WishlistItemModel(
        productId: map['productId'] as int,
        title: map['title'] as String,
        thumbnail: map['thumbnail'] as String,
        price: (map['price'] as num).toDouble(),
      );
}
