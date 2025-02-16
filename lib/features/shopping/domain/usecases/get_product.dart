import 'package:dartz/dartz.dart';
import 'package:freshket_app/core/errors/failure.dart';
import 'package:freshket_app/features/shopping/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository productRepository;

  GetProducts(this.productRepository);

  Future<Either<Failure, Map<String, dynamic>>> call(String? nextCursor) async {
    final response = await productRepository.fetchProducts(nextCursor);

    print(response);
    return response.fold(
      (failure) => Left(failure),
      (data) {
        return Right({
          'products': data['items'],
          'nextCursor': data['nextCursor'],
        });
      },
    );
  }
}
