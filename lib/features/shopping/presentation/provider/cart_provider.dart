import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/domain/usecases/checkout.dart';

class CartProvider extends ChangeNotifier {
  final CheckoutUseCase checkoutUseCase;
  CartProvider({required this.checkoutUseCase});

  final Map<String, int> _cartItems = {};
  final Map<String, ProductEntity> _productsInCart = {};

  bool _isCheckoutSuccess = false;

  bool get isCheckoutSuccess => _isCheckoutSuccess;

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

  double get subtotal {
    double total = 0.0;
    _cartItems.forEach((key, quantity) {
      final product = _productsInCart[key];
      if (product != null) {
        total += product.price * quantity;
      }
    });
    return total;
  }

  double get discount {
    double totalDiscount = 0.0;
    _cartItems.forEach((key, quantity) {
      final product = _productsInCart[key];
      if (product != null) {
        int discountPairs = quantity ~/ 2;
        totalDiscount += discountPairs * product.price * 0.1;
      }
    });
    return totalDiscount;
  }

  double get total => subtotal - discount;

  Future<bool> checkout() async {
    List<int> productIds =
        cartItems.map((item) => item["product"]?.id as int).toList();

    bool success = await checkoutUseCase(productIds);

    if (success) {
      _isCheckoutSuccess = true;
      clearCart();
    }
    return success;
  }

  void clearCart() {
    _cartItems.clear();
    _productsInCart.clear();
    notifyListeners();
  }
}
