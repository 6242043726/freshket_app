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
                itemCount: productProvider.products.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHeader("Products");
                  } else {
                    return ListTile(
                      title: Text(productProvider.products[index - 1].name),
                    );
                  }
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
