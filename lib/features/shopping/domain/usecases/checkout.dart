import 'package:freshket_app/features/shopping/domain/repositories/cart_repository.dart';

class CheckoutUseCase {
  final CartRepository cartRepository;

  CheckoutUseCase(this.cartRepository);

  Future<bool> call(List<int> productIds) async {
    return await cartRepository.checkout(productIds);
  }
}
