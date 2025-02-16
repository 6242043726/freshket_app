import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, int> _cartItems = {};
  final List<ProductEntity> _productsInCart = [];

  List<ProductEntity> get cartItems => _productsInCart;

  void addToCart(ProductEntity product) {
    _cartItems[product.id] = (_cartItems[product.id] ?? 0) + 1;
    _productsInCart.add(product);
    notifyListeners();
  }

  void increaseQuantity(ProductEntity product) {
    _cartItems[product.id] = (_cartItems[product.id] ?? 0) + 1;
    notifyListeners();
  }

  void decreaseQuantity(ProductEntity product) {
    _cartItems[product.id] = (_cartItems[product.id] ?? 0) - 1;
    notifyListeners();
  }

  int getQuantity(ProductEntity product) => _cartItems[product.id] ?? 0;
}