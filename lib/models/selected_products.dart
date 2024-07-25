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

  void toggleSelection(Product productId) {
    if (_selectedProducts.contains(productId)) {
      _selectedProducts.remove(productId);
    } else {
      _selectedProducts.add(productId);
    }
    debugPrint('_selectedProductIds ${_selectedProducts.toString()}');
    notifyListeners();
  }
}
