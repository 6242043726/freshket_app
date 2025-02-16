import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';
import 'package:freshket_app/features/shopping/presentation/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
                            color: Colors.red[900],
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            cartProvider.removeFromCart(product, type);
                          },
                          child: ListTile(
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
                                    style: TextStyle(
                                      color: colorScheme.onPrimaryFixedVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Row(
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
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      cartProvider.decreaseQuantity(
                                        product,
                                        type,
                                      );
                                    },
                                    iconSize: 24.0,
                                    padding: EdgeInsets.all(0),
                                  ),
                                ),
                                Container(
                                  width: 24.0,
                                  child: Text(
                                    "${cartProvider.getQuantity(product, type)}",
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
                                      cartProvider.increaseQuantity(
                                        product,
                                        type,
                                      );
                                    },
                                    iconSize: 24.0,
                                    padding: EdgeInsets.all(0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow(
                  context,
                  "Subtotal",
                  cartProvider.subtotal,
                  isBold: true,
                ),
                _buildSummaryRow(
                  context,
                  "Promotion discount",
                  cartProvider.discount,
                  isDiscount: true,
                  isBold: true,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${cartProvider.total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 40,
                          color: colorScheme.onPrimaryFixedVariant,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          bool success =  await cartProvider.checkout();
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Something went wrong'),
                                backgroundColor: Colors.red[900],
                                action: SnackBarAction(
                                  label: 'x',
                                  onPressed: () {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          "Checkout",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    double amount, {
    bool isBold = false,
    bool isDiscount = false,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: colorScheme.onPrimaryFixedVariant,
            ),
          ),
          Text(
            "${isDiscount ? "- " : ""}${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color:
                  isDiscount
                      ? Colors.red[900]
                      : colorScheme.onPrimaryFixedVariant,
            ),
          ),
        ],
      ),
    );
  }
}
