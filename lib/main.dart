import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/manage_product_screen.dart';
import 'package:shop_app/screens/orderpage_screen.dart';
import 'package:shop_app/screens/products_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider(
            Provider.of<Auth>(ctx, listen: false).token ?? '',
            Provider.of<Auth>(ctx, listen: false).userId ?? '',
            [],
          ),
          update: (ctx, auth, previousProducts) => ProductsProvider(
            auth.token ?? '',
            auth.userId ?? '',
            previousProducts == null ? [] : previousProducts.productsList,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(
            Provider.of<Auth>(ctx, listen: false).token ?? '',
            Provider.of<Auth>(ctx, listen: false).userId ?? '',
            [],
          ),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token ?? '',
            auth.userId ?? '',
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder()
          })),
          debugShowCheckedModeBanner: false,
          // initialRoute: AuthScreen.routeName,
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, autoLoginSnapshot) =>
                      autoLoginSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            // AuthScreen.routeName: (ctx) => AuthScreen(),
            // ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductsDetailScreen.routeName: (ctx) => ProductsDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderPageScreen.routeName: (ctx) => OrderPageScreen(),
            ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
