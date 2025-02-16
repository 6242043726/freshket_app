import 'package:dartz/dartz.dart';
import 'package:freshket_app/core/errors/failure.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/domain/repositories/product_repository.dart';

class GetRecommendedProducts {
  final ProductRepository repository;

  GetRecommendedProducts(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    final response = await repository.fetchRecommendedProducts();
    return response.fold(
      (failure) => Left(failure),
      (data) {
        return Right(data);
      },
    ); 
  }
}