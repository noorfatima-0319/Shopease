import 'address_model.dart';
import 'cart_item_model.dart';

enum OrderStatus { placed, processing, shipped, delivered }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed: return 'Placed';
      case OrderStatus.processing: return 'Processing';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.delivered: return 'Delivered';
    }
  }
}

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double total;
  final AddressModel address;
  final OrderStatus status;
  final DateTime placedAt;
  final String paymentMethod; // 'Cash on Delivery' or 'Card'

  const OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.status,
    required this.placedAt,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'items': items.map((e) => e.toMap()).toList(),
        'total': total,
        'address': address.toMap(),
        'status': status.name,
        'placedAt': placedAt.toIso8601String(),
        'paymentMethod': paymentMethod,
      };

  factory OrderModel.fromMap(Map<dynamic, dynamic> map) {
    final itemsRaw = map['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: map['id'] as String,
      items: itemsRaw.map((e) => CartItemModel.fromMap(e as Map)).toList(),
      total: (map['total'] as num).toDouble(),
      address: AddressModel.fromMap(map['address'] as Map),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.placed,
      ),
      placedAt: DateTime.parse(map['placedAt'] as String),
      paymentMethod: (map['paymentMethod'] as String?) ?? 'Cash on Delivery',
    );
  }
}
