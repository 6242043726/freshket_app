import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/presentation/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                cartProvider.cartItems.isEmpty
                    ? Center(child: Text("Your cart is empty"))
                    : ListView.builder(
                      itemCount: cartProvider.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartProvider.cartItems[index];
                        final product = cartItem['product'] as ProductEntity;
                        final type = cartItem['type'] as String;

                        return Dismissible(
                          key: Key("${type}_${product.id}"),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            cartProvider.removeFromCart(product, type);
                          },
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text(
                              "\$${product.price.toStringAsFixed(2)}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    cartProvider.decreaseQuantity(
                                      product,
                                      type,
                                    );
                                  },
                                ),
                                Text(
                                  "${cartProvider.getQuantity(product, type)}",
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    cartProvider.increaseQuantity(
                                      product,
                                      type,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
