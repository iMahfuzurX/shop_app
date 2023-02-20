//
// Created by iMahfuzurX on 1/23/2023.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/products_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        leading: Consumer<Product>(
            builder: ((context, product, child) => IconButton(
                  onPressed: () async {
                    try {
                      await product.toggleFavorite(
                        authData.token as String,
                        authData.userId as String,
                      );
                    } catch (error) {
                      scaffold.showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    }
                  },
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Colors.red,
                ))),
        title: Text(product.title),
        trailing: IconButton(
          onPressed: () {
            cart.addItem(product.id, product.price, product.title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Item added to cart'),
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  }),
            ));
          },
          icon: const Icon(Icons.shopping_cart),
          color: Colors.red,
        ),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                ProductsDetailScreen.routeName,
                arguments: product.id),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
