//
// Created by iMahfuzurX on 2/16/2023.
//
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiresIn;
  Timer? _autoLogout;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiresIn != null &&
        (_expiresIn as DateTime).isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final uri = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyChVxkz37oNqC7dZezSsYL77_SCs_IM_Yw');
    try {
      final response = await http.post(
        uri,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiresIn = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiresIn': _expiresIn?.toIso8601String(),
      });
      prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;
    final expiresIn = DateTime.parse(userData['expiresIn'] as String);
    if (expiresIn.isBefore(DateTime.now())) {
      // expired
      return false;
    }
    _token = userData['token'] as String;
    _userId = userData['userId'] as String;
    _expiresIn = expiresIn;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signUp(email, password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(email, password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiresIn = null;
    if (_autoLogout != null) {
      _autoLogout?.cancel();
      _autoLogout = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_autoLogout != null) {
      _autoLogout?.cancel();
    }
    final timeToLogout = _expiresIn?.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToLogout as int), logOut);
  }
}
