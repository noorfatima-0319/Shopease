import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'injection/injection_container.dart';
import 'presentation/cart/cubit/cart_cubit.dart';
import 'presentation/wishlist/cubit/wishlist_cubit.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(AppConstants.cartBox);
  await Hive.openBox(AppConstants.wishlistBox);
  await Hive.openBox(AppConstants.ordersBox);
  await Hive.openBox(AppConstants.addressBox);

  setupInjection();

  runApp(const ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // CartCubit and WishlistCubit are provided once, at the very top of
    // the app, so every screen shares the same instance instead of each
    // screen creating its own and drifting out of sync.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<CartCubit>()),
        BlocProvider.value(value: sl<WishlistCubit>()),
      ],
      child: MaterialApp.router(
        title: 'ShopEase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
