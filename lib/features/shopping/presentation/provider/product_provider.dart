import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/data/models/product_model.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/domain/usecases/get_product.dart';

class ProductProvider extends ChangeNotifier {
  final GetProducts getProducts;

  List<ProductEntity> _products = [];
  bool _isLoading = false;
  String? _nextCursor;

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;

  final ScrollController scrollController = ScrollController();

  ProductProvider(this.getProducts) {
    scrollController.addListener(_scrollListener);
    fetchProducts();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchProducts();
    }
  }

  Future<void> fetchProducts() async {
    if (_isLoading || _nextCursor == "end") return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await getProducts(_nextCursor);

      result.fold((failure) => print(failure.errorMessage), (data) {
        final newProducts = data['products'] as List<dynamic>;
        final newCursor = data['nextCursor'] as String?;

        if (newProducts.isNotEmpty) {
          _nextCursor = newCursor;

          List<ProductEntity> productsToAdd =
              newProducts.map((item) {
                return ProductModel.fromJson(item).toEntity();
              }).toList();

          _products = [..._products, ...productsToAdd];
        } else {
          _nextCursor = "end";
        }
      });

      notifyListeners();
    } catch (error) {
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
