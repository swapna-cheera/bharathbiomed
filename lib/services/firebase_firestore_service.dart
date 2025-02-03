import 'package:bharathbiomedpharma/services/databasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      // Check local database first
      List<Map<String, dynamic>> localProducts =
          await DatabaseHelper.instance.getProducts();
      if (localProducts.isNotEmpty) {
        return localProducts;
      }

      // If local database is empty, fetch from Firebase
      QuerySnapshot querySnapshot =
          await _firestore.collection('Products').get();
      List<Map<String, dynamic>> products = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      // Save products to local database
      for (var product in products) {
        await DatabaseHelper.instance.insertProduct(product);
      }

      return products;
    } catch (e) {
      debugPrint('Error getting products: $e');
      return [];
    }
  }

  // Get all departments
  Future<List<String>> getDepartments() async {
    try {
      // Check local database first
      List<String> localDepartments =
          await DatabaseHelper.instance.getDepartments();
      if (localDepartments.isNotEmpty) {
        return localDepartments;
      }

      // If local database is empty, fetch from Firebase
      DocumentSnapshot docSnapshot =
          await _firestore.collection('Department').doc('departmentsDoc').get();
      if (docSnapshot.exists) {
        List<String> departments =
            List<String>.from(docSnapshot['departments']);

        // Save departments to local database
        for (var department in departments) {
          await DatabaseHelper.instance.insertDepartment(department);
        }

        return departments;
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

  // Sync data from Firebase to local database
  Future<void> syncData() async {
    try {
      // Sync products
      QuerySnapshot productQuerySnapshot =
          await _firestore.collection('Products').get();
      for (var doc in productQuerySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        await DatabaseHelper.instance.insertProduct(data);
      }
      debugPrint('Products synchronized from Firebase to local database');

      // Sync departments
      DocumentSnapshot departmentDocSnapshot =
          await _firestore.collection('Department').doc('departmentsDoc').get();
      if (departmentDocSnapshot.exists) {
        List<String> departments =
            List<String>.from(departmentDocSnapshot['departments']);
        for (var department in departments) {
          await DatabaseHelper.instance.insertDepartment(department);
        }
      }
      debugPrint('Departments synchronized from Firebase to local database');
    } catch (e) {
      debugPrint('Error synchronizing data: $e');
    }
  }
}
