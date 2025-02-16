abstract class CartRepository {
  Future<bool> checkout(List<int> productIds);
}