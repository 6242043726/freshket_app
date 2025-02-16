import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/presentation/provider/cart_provider.dart';
import 'package:freshket_app/features/shopping/presentation/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body:
          productProvider.products.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                controller: productProvider.scrollController,
                itemCount:
                    productProvider.recommendedProducts.length +
                    productProvider.products.length +
                    2 +
                    (productProvider.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHeader("Recommended Products");
                  }
                  if (index <= productProvider.recommendedProducts.length) {
                    ProductEntity product =
                        productProvider.recommendedProducts[index - 1];
                    return _buildProductItem(
                      context,
                      product,
                      cartProvider,
                      "recommended",
                    );
                  }
                  if (index == productProvider.recommendedProducts.length + 1) {
                    return _buildHeader("Latest Products");
                  }
                  if (index <
                      (productProvider.recommendedProducts.length +
                          productProvider.products.length +
                          1)) {
                    ProductEntity product =
                        productProvider.products[index -
                            productProvider.recommendedProducts.length -
                            2];
                    return _buildProductItem(
                      context,
                      product,
                      cartProvider,
                      "product",
                    );
                  }
                  if (index ==
                      productProvider.recommendedProducts.length +
                          productProvider.products.length +
                          2) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 10),
                          Text('Loading..'),
                        ],
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
    );
  }
}

Widget _buildHeader(String title) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildProductItem(
  BuildContext context,
  ProductEntity product,
  CartProvider cartProvider,
  String type,
) {
  int quantity = cartProvider.getQuantity(product, type);
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  return ListTile(
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        'assets/images/img_placeholder.png',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    ),
    title: Text(
      product.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimaryFixedVariant,
      ),
    ),
    subtitle: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${product.price.toStringAsFixed(2)}",
            style: TextStyle(
              color: colorScheme.onPrimaryFixedVariant,
              fontSize: 20,
            ),
          ),
          TextSpan(
            text: " / unit",
            style: TextStyle(color: colorScheme.onPrimaryFixedVariant),
          ),
        ],
      ),
    ),

    trailing:
        quantity > 0
            ? _buildQuantityChanger(
              context,
              cartProvider,
              product,
              quantity,
              type,
            )
            : ElevatedButton(
              onPressed: () {
                cartProvider.addToCart(product, type);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    colorScheme.primary, // Set the background color here
                foregroundColor: Colors.white,
              ),
              child: Text("Add to Cart"),
            ),
  );
}

Widget _buildQuantityChanger(
  BuildContext context,
  CartProvider cartProvider,
  ProductEntity productEntity,
  int quantity,
  String type,
) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 36.0,
        height: 36.0,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.remove, color: Colors.white),
          onPressed: () {
            cartProvider.decreaseQuantity(productEntity, type);
          },
          iconSize: 24.0,
          padding: EdgeInsets.all(0),
        ),
      ),
      Container(
        width: 24.0,
        child: Text(
          "${cartProvider.getQuantity(productEntity, type)}",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      Container(
        width: 36.0,
        height: 36.0,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            cartProvider.increaseQuantity(productEntity, type);
          },
          iconSize: 24.0,
          padding: EdgeInsets.all(0),
        ),
      ),
    ],
  );
}
