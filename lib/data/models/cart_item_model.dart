// Stored in Hive as a plain Map, so no generated type adapter is needed.
class CartItemModel {
  final int productId;
  final String title;
  final String thumbnail;
  final double price;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.quantity,
  });

  double get lineTotal => price * quantity;

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'title': title,
        'thumbnail': thumbnail,
        'price': price,
        'quantity': quantity,
      };

  factory CartItemModel.fromMap(Map<dynamic, dynamic> map) => CartItemModel(
        productId: map['productId'] as int,
        title: map['title'] as String,
        thumbnail: map['thumbnail'] as String,
        price: (map['price'] as num).toDouble(),
        quantity: map['quantity'] as int,
      );
}
