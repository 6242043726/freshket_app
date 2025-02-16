import 'package:dio/dio.dart';
import 'package:freshket_app/features/shopping/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final Dio dio;

  CartRepositoryImpl(this.dio);

  @override
  Future<bool> checkout(List<int> productIds) async {
    try {
      final response = await dio.post(
        '/orders/checkout',
        data: {'products': productIds},
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print("DioException: $e");
      return false;
    }
  }
}
