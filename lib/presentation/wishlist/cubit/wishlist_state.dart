import '../../../data/models/wishlist_item_model.dart';

class WishlistState {
  final List<WishlistItemModel> items;

  const WishlistState({this.items = const []});

  WishlistState copyWith({List<WishlistItemModel>? items}) {
    return WishlistState(items: items ?? this.items);
  }
}
