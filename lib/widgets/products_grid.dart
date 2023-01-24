//
// Created by iMahfuzurX on 1/23/2023.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorite;
  const ProductsGrid(this.showFavorite, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<ProductsProvider>(context);
    final products = (showFavorite
        ? providerData.productsList
            .where((element) => element.isFavorite)
            .toList()
        : providerData.productsList);

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
