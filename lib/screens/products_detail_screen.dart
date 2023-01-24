//
// Created by iMahfuzurX on 1/23/2023.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductsDetailScreen extends StatelessWidget {
  const ProductsDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final productItem = Provider.of<ProductsProvider>(context, listen: false)
        .getProductById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(productItem.title),
      ),
    );
  }
}
