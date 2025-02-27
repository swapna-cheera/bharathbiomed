import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../models/selected_products.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final int sNumber;

  const ProductItem(this.product, this.sNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    final selectedProducts =
        Provider.of<SelectedProductsChangeNotifier>(context);
    final isSelected = selectedProducts.isSelected(product);

    return InkWell(
      onTap: () {
        selectedProducts.toggleSelection(product);
      },
      child: Container(
        width: MediaQuery.of(context).size.height /
            3, // Adjust the width as needed
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(product.imageUrl),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(70),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            if (sNumber > 0)
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Text(
                    sNumber.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
