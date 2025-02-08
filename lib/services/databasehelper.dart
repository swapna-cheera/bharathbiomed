import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('localdb.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: 1, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT,
        departments TEXT,
        imageUrl TEXT,
        info TEXT
      )
      ''');
      debugPrint("Table 'products' created.");

      await db.execute('''
      CREATE TABLE departments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
      ''');
      debugPrint("Table 'departments' created.");
    } catch (e) {
      debugPrint("Error creating database: $e");
    }
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await instance.database;

    // Convert List to JSON string
    product['departments'] = jsonEncode(product['departments']);

    try {
      await db.insert(
        'products',
        product,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint("Product inserted: $product");
    } catch (e) {
      debugPrint("Error inserting product: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await instance.database;

    try {
      List<Map<String, dynamic>> products = await db.query('products');

      // Convert departments JSON string back to a list
      for (var product in products) {
        if (product['departments'] != null) {
          product = {
            ...product,
            'departments': jsonDecode(product['departments']),
          };
        }
      }

      debugPrint("Products retrieved: $products");
      return products;
    } catch (e) {
      debugPrint("Error retrieving products: $e");
      return [];
    }
  }

  Future<void> insertDepartment(String department) async {
    final db = await instance.database;

    try {
      await db.insert('departments', {'name': department},
          conflictAlgorithm: ConflictAlgorithm.ignore);
      debugPrint("Department inserted: $department");
    } catch (e) {
      debugPrint("Error inserting department: $e");
    }
  }

  Future<List<String>> getDepartments() async {
    final db = await instance.database;

    try {
      final result = await db.query('departments', columns: ['name']);
      List<String> departments =
          result.map((e) => e['name'] as String).toList();

      debugPrint("Departments retrieved: $departments");
      return departments;
    } catch (e) {
      debugPrint("Error retrieving departments: $e");
      return [];
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      try {
        await db.execute('ALTER TABLE products ADD COLUMN info TEXT');
        debugPrint("Table 'products' upgraded with new column 'info'.");
      } catch (e) {
        debugPrint("Error upgrading database: $e");
      }
    }
  }
}
