
import 'package:dio/dio.dart';
import 'package:freshket_app/core/constants/constants.dart';
import 'package:freshket_app/core/errors/exceptions.dart';
import 'package:freshket_app/features/shopping/data/models/product_model.dart';

abstract class ProductDataSource {
   Future<Map<String, dynamic>> fetchProducts(String? nextCursor);
   Future<List<ProductModel>> fetchRecommendedProducts();
}

class ProductDataSourceImpl implements ProductDataSource {
  final Dio dio;

  ProductDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> fetchProducts(String? nextCursor) async {
    nextCursor ??= "";
    final response = await dio.get('${ApiConfig.products}?cursor=$nextCursor');

    if (response.statusCode == 200) {

      final data = response.data;
      return {
        'items': data['items'],
        'nextCursor': data['nextCursor'],
      };
    } else {
      throw ServerException();
    }
  }
  
  @override
  Future<List<ProductModel>> fetchRecommendedProducts() async {
    final response = await dio.get(ApiConfig.recommendedProducts);

    if (response.statusCode == 200) {

      final data = response.data;
      return (data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } else {
      throw ServerException();
    }
  }
}