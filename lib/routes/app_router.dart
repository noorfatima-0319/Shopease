import 'package:go_router/go_router.dart';

import '../data/models/order_model.dart';
import '../presentation/cart/cart_screen.dart';
import '../presentation/checkout/checkout_screen.dart';
import '../presentation/checkout/order_confirmation_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/legal/privacy_policy_screen.dart';
import '../presentation/legal/terms_screen.dart';
import '../presentation/orders/orders_screen.dart';
import '../presentation/product_detail/product_detail_screen.dart';
import '../presentation/product_list/product_list_screen.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/wishlist/wishlist_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const productList = '/products';
  static const productDetail = '/product';
  static const cart = '/cart';
  static const wishlist = '/wishlist';
  static const checkout = '/checkout';
  static const orderConfirmation = '/order-confirmation';
  static const orders = '/orders';
  static const privacyPolicy = '/privacy-policy';
  static const terms = '/terms';
}

// Centralized named routes, so navigation reads as intent
// (go to product detail) rather than widget construction details.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: AppRoutes.productList,
      builder: (context, state) {
        final category = state.uri.queryParameters['category'];
        final query = state.uri.queryParameters['q'];
        return ProductListScreen(initialCategory: category, initialQuery: query);
      },
    ),
    GoRoute(
      path: '${AppRoutes.productDetail}/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailScreen(productId: id);
      },
    ),
    GoRoute(path: AppRoutes.cart, builder: (context, state) => const CartScreen()),
    GoRoute(path: AppRoutes.wishlist, builder: (context, state) => const WishlistScreen()),
    GoRoute(path: AppRoutes.checkout, builder: (context, state) => const CheckoutScreen()),
    GoRoute(
      path: AppRoutes.orderConfirmation,
      builder: (context, state) {
        final order = state.extra as OrderModel;
        return OrderConfirmationScreen(order: order);
      },
    ),
    GoRoute(path: AppRoutes.orders, builder: (context, state) => const OrdersScreen()),
    GoRoute(path: AppRoutes.privacyPolicy, builder: (context, state) => const PrivacyPolicyScreen()),
    GoRoute(path: AppRoutes.terms, builder: (context, state) => const TermsScreen()),
  ],
);
