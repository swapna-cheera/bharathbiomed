import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

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
    await db.execute('''
    CREATE TABLE products (
      id TEXT PRIMARY KEY,
      name TEXT,
      departments TEXT,
      imageUrl TEXT,
      info TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE departments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE
    )
    ''');
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await instance.database;

    // Convert List to JSON string
    product['departments'] = jsonEncode(product['departments']);

    await db.insert('products', product,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Future<List<Map<String, dynamic>>> getProducts() async {
  //   final db = await instance.database;
  //   return await db.query('products');
  // }
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await instance.database;
    List<Map<String, dynamic>> products = await db.query('products');

    // Convert departments JSON string back to a list
    for (var product in products) {
      if (product['departments'] != null) {
        product['departments'] = jsonDecode(product['departments']);
      }
    }

    return products;
  }

  Future<void> insertDepartment(String department) async {
    final db = await instance.database;
    await db.insert('departments', {'name': department},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<String>> getDepartments() async {
    final db = await instance.database;
    final result = await db.query('departments', columns: ['name']);
    return result.map((e) => e['name'] as String).toList();
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('ALTER TABLE products ADD COLUMN info TEXT');
    }
  }
}
