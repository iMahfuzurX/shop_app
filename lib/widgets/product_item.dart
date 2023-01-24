//
// Created by iMahfuzurX on 1/23/2023.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/products_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
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
          onPressed: () {
            cart.addItem(product.id, product.price, product.title);
          },
          icon: const Icon(Icons.shopping_cart),
          color: Colors.red,
        ),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ProductsDetailScreen.routeName, arguments: product.id),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
