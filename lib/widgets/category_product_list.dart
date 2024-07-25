import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/selected_products.dart';
import '../models/product.dart';
import 'product_item.dart';

class CategoryProductList extends StatelessWidget {
  final String category;
  final List<Product> products;

  const CategoryProductList(
      {super.key, required this.category, required this.products});

  @override
  Widget build(BuildContext context) {
    final selectedProductsProvider =
        Provider.of<SelectedProductsChangeNotifier>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (ctx, i) {
              final product = products[i];
              final isSelected =
                  selectedProductsProvider.selectedProducts.contains(product);
              final selectionNumber = isSelected
                  ? selectedProductsProvider.selectedProducts.indexOf(product) +
                      1
                  : null;
              return ProductItem(products[i], selectionNumber ?? 0);
            },
          ),
        ),
      ],
    );
  }
}
