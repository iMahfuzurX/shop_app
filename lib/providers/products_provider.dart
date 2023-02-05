//
// Created by iMahfuzurX on 1/23/2023.
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'product_provider.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final List<Product> _productsList = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  final List<String> _favIds = [];

  List<Product> get productsList {
    return [..._productsList];
  }

  List<String> get favIds {
    return [..._favIds];
  }

  Future<void> addProduct(Product product) {
    final Uri uri = Uri.https('shoppeio-default-rtdb.asia-southeast1.firebasedatabase.app', 'products.json');
    return http
        .post(uri,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite,
            }))
        .then((response) {
      final Product newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _productsList.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print('erroroccured ${error.toString()}');
      throw error;
    });
  }

  void updateProduct(String id, Product product) {
    final i = _productsList.indexWhere((element) => element.id == id);
    _productsList[i] = product;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _productsList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void addFavs(String id) {
    _favIds.add(id);
    notifyListeners();
  }

  Product getProductById(String id) {
    return _productsList.firstWhere((element) => element.id == id);
  }
}
