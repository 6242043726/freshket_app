import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/presentation/pages/product_page.dart';
import 'package:freshket_app/features/shopping/presentation/provider/product_provider.dart';
import 'package:freshket_app/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (context) => getIt<ProductProvider>(),
      child: MainApp(),
    ),
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
