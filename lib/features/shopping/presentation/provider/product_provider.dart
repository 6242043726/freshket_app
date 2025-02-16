import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/data/models/product_model.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/domain/usecases/get_product.dart';
import 'package:freshket_app/features/shopping/domain/usecases/get_recommended_product.dart';

class ProductProvider extends ChangeNotifier {
  final GetProducts getProducts;
  final GetRecommendedProducts getRecommendedProducts;

  List<ProductEntity> _products = [];
  List<ProductEntity> _recommendedProducts = [];

  bool _isLoading = false;
  String? _nextCursor;

  bool _isRecommendedError = false;

  List<ProductEntity> get products => _products;
  List<ProductEntity> get recommendedProducts => _recommendedProducts;
  bool get isLoading => _isLoading;
  bool get isRecommendedError => _isRecommendedError;

  final ScrollController scrollController = ScrollController();

  ProductProvider(this.getProducts, this.getRecommendedProducts) {
    scrollController.addListener(_scrollListener);
    fetchProducts();
    fetchRecommendedProducts();
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

      result.fold((failure) => print(failure), (data) {
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

  Future<void> fetchRecommendedProducts() async {
    try {
      final result = await getRecommendedProducts();
      result.fold((failure) => _isRecommendedError = true, (data) {
        _recommendedProducts = data;
      });
    } catch (error) {
      _isRecommendedError = true;
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
