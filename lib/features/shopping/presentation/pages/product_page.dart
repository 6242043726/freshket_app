import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/presentation/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      body:
          productProvider.products.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                controller: productProvider.scrollController,
                itemCount: productProvider.recommendedProducts.length + productProvider.products.length + 2,
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
                  );
                }
                if (index == productProvider.recommendedProducts.length + 1) {
                  return _buildHeader("Products");
                }
                if (index < (productProvider.recommendedProducts.length +
                    productProvider.products.length +
                    1)) {
                  ProductEntity product = productProvider.products[index - 
                      productProvider.recommendedProducts.length - 2];
                  return _buildProductItem(
                    context,
                    product,
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
  ) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
                'assets/images/img_placeholder.png', 
                width: 50, 
                height: 50, 
                fit: BoxFit.cover, 
                
              )
      ),
      title: Text(product.name),
      subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
    );
  }