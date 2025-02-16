import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/presentation/pages/product_page.dart';
import 'package:freshket_app/features/shopping/presentation/provider/cart_provider.dart';
import 'package:freshket_app/features/shopping/presentation/provider/product_provider.dart';
import 'package:freshket_app/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => getIt<ProductProvider>(), 
        ),
        ChangeNotifierProvider(
          create: (context) => getIt<CartProvider>(), 
        ),
      ],
      child: MainApp(),
  )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProductPage()
    );
  }
}
