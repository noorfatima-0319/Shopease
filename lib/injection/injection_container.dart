import 'package:get_it/get_it.dart';

import '../core/network/dio_client.dart';
import '../data/datasources/address_local_datasource.dart';
import '../data/datasources/cart_local_datasource.dart';
import '../data/datasources/order_local_datasource.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/datasources/wishlist_local_datasource.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../data/repositories/product_repository_impl.dart';
import '../data/repositories/wishlist_repository_impl.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/repositories/wishlist_repository.dart';
import '../presentation/cart/cubit/cart_cubit.dart';
import '../presentation/wishlist/cubit/wishlist_cubit.dart';

final GetIt sl = GetIt.instance;

// Registered once in main() before runApp. Every Cubit asks get_it
// for its repository instead of constructing one itself.
void setupInjection() {
  // Network
  sl.registerLazySingleton(() => DioClient().dio);

  // Data sources
  sl.registerLazySingleton(() => ProductRemoteDataSource(sl()));
  sl.registerLazySingleton(() => CartLocalDataSource());
  sl.registerLazySingleton(() => WishlistLocalDataSource());
  sl.registerLazySingleton(() => OrderLocalDataSource());
  sl.registerLazySingleton(() => AddressLocalDataSource());

  // Repositories
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<WishlistRepository>(() => WishlistRepositoryImpl(sl()));
  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(sl(), sl()));

  // Cart and Wishlist cubits are app-wide singletons so every screen
  // reads the same state: a change anywhere (e.g. adding a product
  // from Product Detail) updates badges and lists everywhere else
  // immediately, with no manual refresh-on-navigation needed.
  sl.registerLazySingleton(() => CartCubit(sl<CartRepository>()));
  sl.registerLazySingleton(() => WishlistCubit(sl<WishlistRepository>()));
}
