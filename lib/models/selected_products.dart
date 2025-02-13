import 'package:flutter/material.dart';
import 'product.dart';

class SelectedProductsChangeNotifier with ChangeNotifier {
  final List<Product> _selectedProducts = [];

  List<Product> get selectedProducts => List.unmodifiable(_selectedProducts);

  bool isSelected(Product product) => _selectedProducts.contains(product);

  void toggleSelection(Product product) {
    if (_selectedProducts.contains(product)) {
      _selectedProducts.remove(product);
    } else {
      _selectedProducts.add(product);
    }
    debugPrint('_selectedProducts ${_selectedProducts.toString()}');
    notifyListeners();
  }
}
