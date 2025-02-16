import 'package:dartz/dartz.dart';
import 'package:freshket_app/core/errors/failure.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, Map<String, dynamic>>> fetchProducts(String? nextCursor);

  Future<Either<Failure, List<ProductEntity>>> fetchRecommendedProducts();
}