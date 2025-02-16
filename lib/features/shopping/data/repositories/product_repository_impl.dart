import 'package:dartz/dartz.dart';
import 'package:freshket_app/core/connection/network_info.dart';
import 'package:freshket_app/core/errors/exceptions.dart';
import 'package:freshket_app/core/errors/failure.dart';
import 'package:freshket_app/features/shopping/data/datasources/remote/product_data_source.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource productDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({required this.networkInfo, required this.productDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchProducts(String? nextCursor) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await productDataSource.fetchProducts(nextCursor);

        print(response['items']);
        
        if (response['items'] != null && response['nextCursor'] != null) {
          return Right({
            'items': response['items'],
            'nextCursor': response['nextCursor'],
          });
        } else {
          return Left(ServerFailure(errorMessage: "Invalid response format"));
        }
      } on ServerException {
        return Left(ServerFailure(errorMessage: ""));
      }
    } else {
      return Left(ServerFailure(errorMessage: ""));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchRecommendedProducts() async {
  if (await networkInfo.isConnected!) {
    try {
      final response = await productDataSource.fetchRecommendedProducts();

      if (response.isNotEmpty) {
        List<ProductEntity> products = response.map((model) => model.toEntity()).toList();
        return Right(products);
      } else {
        return Left(ServerFailure(errorMessage: "Invalid response format"));
      }
    } on ServerException {
      return Left(ServerFailure(errorMessage: ""));
    }
  } else {
    return Left(ServerFailure(errorMessage: "No internet connection"));
  }
}

}
