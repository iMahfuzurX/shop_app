//
// Created by iMahfuzurX on 2/13/2023.
//
class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}