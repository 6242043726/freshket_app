import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:freshket_app/core/constants/constants.dart';
import 'package:freshket_app/core/errors/exceptions.dart';

abstract class ProductDataSource {
   Future<Map<String, dynamic>> fetchProducts(String? nextCursor);
}

class ProductDataSourceImpl implements ProductDataSource {
  final Dio dio;

  ProductDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> fetchProducts(String? nextCursor) async {
    nextCursor ??= "";
    final response = await dio.get('$BASE_URL/products?cursor=$nextCursor');

    if (response.statusCode == 200) {

      final data = json.decode(response.data);
      return {
        'items': data['items'],
        'nextCursor': data['nextCursor'],
      };
    } else {
      throw ServerException();
    }
  }
}