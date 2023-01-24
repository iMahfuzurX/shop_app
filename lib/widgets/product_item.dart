//
// Created by iMahfuzurX on 1/23/2023.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        leading: Consumer<Product>(
            builder: ((context, product, child) => IconButton(
                  onPressed: () => product.toggleFavorite(),
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Colors.red,
                ))),
        title: Text(product.title),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart),
          color: Colors.red,
        ),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed('/products-detail', arguments: product.id),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
