//
// Created by iMahfuzurX on 1/23/2023.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions { Favourite, All }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final carts = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                setState(() {
                  _showFavorites =
                      (value == FilterOptions.Favourite ? true : false);
                });
              },
              itemBuilder: (ctx) => [
                    const PopupMenuItem(
                        value: FilterOptions.Favourite,
                        child: Text('Only Favourite')),
                    const PopupMenuItem(
                      value: FilterOptions.All,
                      child: Text('Show All'),
                    ),
                  ]),
          Consumer<CartProvider>(
            builder: (ctx, cart, child) => Badge(
                child: child as Widget,
                value: '${cart.itemCount}',
                color: Theme.of(context).colorScheme.secondary),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }, icon: Icon(Icons.shopping_cart)),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: ProductsGrid(_showFavorites),
    );
  }
}
