import 'package:flutter/services.dart';

class HttpException implements Exception {
  String message;

  HttpException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
    // return super.toString();
  }
}
