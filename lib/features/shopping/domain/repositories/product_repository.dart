import 'package:dartz/dartz.dart';
import 'package:freshket_app/core/errors/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, Map<String, dynamic>>> fetchProducts(String? nextCursor);
}