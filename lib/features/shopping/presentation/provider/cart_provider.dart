import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _cartItems = {};
  final Map<String, ProductEntity> _productsInCart = {};

  List<Map<String, dynamic>> get cartItems =>
      _cartItems.entries.map((entry) {
        final product = _productsInCart[entry.key];
        return {
          "product": product,
          "type": entry.key.split("_")[0],
          "quantity": entry.value,
        };
      }).toList();

  void addToCart(ProductEntity product, String type) {
    String key = "${type}_${product.id}";
    _cartItems[key] = (_cartItems[key] ?? 0) + 1;
    _productsInCart[key] = product;
    notifyListeners();
  }

  void removeFromCart(ProductEntity product, String type) {
    String key = "${type}_${product.id}";
    _cartItems.remove(key);
    _productsInCart.remove(key);
    notifyListeners();
  }

  void increaseQuantity(ProductEntity product, String type) {
    String key = "${type}_${product.id}";
    if (_cartItems.containsKey(key)) {
      _cartItems[key] = _cartItems[key]! + 1;
    }
    notifyListeners();
  }

  void decreaseQuantity(ProductEntity product, String type) {
    String key = "${type}_${product.id}";
    if (_cartItems.containsKey(key) && _cartItems[key]! > 1) {
      _cartItems[key] = _cartItems[key]! - 1;
    } else {
      removeFromCart(product, type);
    }
    notifyListeners();
  }

  int getQuantity(ProductEntity product, String type) {
    return _cartItems["${type}_${product.id}"] ?? 0;
  }
}
