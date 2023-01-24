//
// Created by iMahfuzurX on 1/23/2023.
//
import 'package:flutter/material.dart';
import 'package:shop_app/widgets/products_grid.dart';

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
        ],
      ),
      drawer: const Drawer(),
      body: ProductsGrid(_showFavorites),
    );
  }
}
