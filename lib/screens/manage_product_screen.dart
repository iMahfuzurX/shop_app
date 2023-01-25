//
// Created by iMahfuzurX on 1/25/2023.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/manage_products_item.dart';

class ManageProductScreen extends StatelessWidget {
  static final String routeName = '/manage-products';
  const ManageProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (ctx, i) => Column(
            children: [
              ManageProductItem(
                  title: productsData.productsList[i].title,
                  imageUrl: productsData.productsList[i].imageUrl),
              Divider(),
            ],
          ),
          itemCount: productsData.productsList.length,
        ),
      ),
    );
  }
}
