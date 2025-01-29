import 'package:flutter/material.dart';
import 'product.dart';

class SelectedProductsChangeNotifier with ChangeNotifier {
  final List<Product> _selectedProducts = [];

  List<Product> get selectedProducts {
    return _selectedProducts;
  }

  bool isSelected(Product product) {
    return _selectedProducts.contains(product);
  }

  void toggleSelection(Product product) {
    if (_selectedProducts.contains(product)) {
      _selectedProducts.remove(product);
    } else {
      _selectedProducts.add(product);
    }
    debugPrint('_selectedProductIds ${_selectedProducts.toString()}');
    notifyListeners();
  }
}
