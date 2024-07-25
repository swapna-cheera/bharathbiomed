import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductFullScreenScreen extends StatelessWidget {
  final List<Product> selectedProducts;

  const ProductFullScreenScreen({super.key, required this.selectedProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Viewer')),
      body: PageView.builder(
        itemCount: selectedProducts.length,
        itemBuilder: (context, index) {
          final product = selectedProducts[index];
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(product.imageUrl),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ); // Replace with actual image URLs
        },
      ),
    );
  }
}
