import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/products_detail_screen.dart';

import 'package:shop_app/screens/products_overview_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductsProvider(),
      child: MaterialApp(
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          '/products-detail': (ctx) => ProductsDetailScreen(),
        },
      ),
    );
  }
}
