//
// Created by iMahfuzurX on 1/23/2023.
//
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  }) {}

  void _setFavValue(bool fav) {
    isFavorite = fav;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    _setFavValue(!isFavorite);

    final Uri uri = Uri.https(
        'shoppeio-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products/$id.json');

    try {
      final response = await http.patch(uri,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        // failed roll back
        _setFavValue(oldStatus);
        throw HttpException('Cannot save favorite! Failed');
      }
    } catch (error) {
      // error
      _setFavValue(oldStatus);
    }
  }
}
