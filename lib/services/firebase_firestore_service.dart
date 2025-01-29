import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Import the foundation package

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Products').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error getting products: $e');
      return [];
    }
  }

  // Get all departments
  Future<List<String>> getDepartments() async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('Department').doc('departmentsDoc').get();
      if (docSnapshot.exists) {
        return List<String>.from(docSnapshot['departments']);
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error getting departments: $e');
      return [];
    }
  }

// Delete products with missing department or image URL
  Future<void> deleteProductsWithMissingDepartmentOrImageUrl() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Products').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
        if (productData['departments'] == null ||
            productData['departments'].isEmpty ||
            productData['imageUrl'] == null ||
            productData['imageUrl'].isEmpty) {
          await doc.reference.delete();
          debugPrint(
              'Product with missing department or image URL deleted: ${doc.id}');
        }
      }
      debugPrint(
          'Completed checking for products with missing department or image URL');
    } catch (e) {
      debugPrint(
          'Error checking for products with missing department or image URL: $e');
    }
  }
}
