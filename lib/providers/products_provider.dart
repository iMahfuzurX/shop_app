//
// Created by iMahfuzurX on 1/23/2023.
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product_provider.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _productsList = [];

  final List<String> _favIds = [];

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._productsList);

  List<Product> get productsList {
    return [..._productsList];
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final String filterSegment =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var uri = Uri.parse(
        'https://shoppeio-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterSegment');
    try {
      final response = await http.get(uri);
      final Map<String, dynamic>? extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      uri = Uri.parse(
          'https://shoppeio-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(uri);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _productsList = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final Uri uri = Uri.parse(
        'https://shoppeio-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(uri,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final Product newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _productsList.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('erroroccured ${error.toString()}');
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final i = _productsList.indexWhere((element) => element.id == id);
    if (i >= 0) {
      try {
        final Uri uri = Uri.parse(
            'https://shoppeio-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
        await http.patch(uri,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
        _productsList[i] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final Uri uri = Uri.parse(
        'https://shoppeio-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProdIndex =
        _productsList.indexWhere((element) => element.id == id);
    Product? existingProduct = _productsList[existingProdIndex];
    _productsList.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(uri);
    if (response.statusCode >= 400) {
      _productsList.insert(existingProdIndex, existingProduct as Product);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  /*Future<void> deleteProduct(String id) async {
    final Uri uri = Uri.https(
        'shoppeio-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products/$id.json');
    await http.delete(uri);
    _productsList.removeWhere((element) => element.id == id);
    notifyListeners();
  }*/

  void addFavs(String id) {
    _favIds.add(id);
    notifyListeners();
  }

  Product getProductById(String id) {
    return _productsList.firstWhere((element) => element.id == id);
  }
}
