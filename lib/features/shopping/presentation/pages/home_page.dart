import 'package:flutter/material.dart';
import 'package:freshket_app/features/shopping/presentation/pages/cart_page.dart';
import 'package:freshket_app/features/shopping/presentation/pages/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: ProductPage(),
      bottomNavigationBar: NavigationBar(
        indicatorColor: colorScheme.primaryContainer,
        onDestinationSelected: (int index) {
          _onItemTapped(index);
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.stars), label: "Shopping"),
          NavigationDestination(icon: Icon(Icons.star), label: "Cart"),
        ],
      ),
    );
  }
}
