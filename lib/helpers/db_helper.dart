import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';
import '../models/cart_item.dart';

class DBHelper {
  // Membuat satu instance DBHelper.
  static final DBHelper instance = DBHelper._init();

  // Menyimpan koneksi database.
  static Database? _database;

  DBHelper._init();

  // Mengambil database.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('toko_digital_v4.db');

    return _database!;
  }

  // Membuka database.
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Membuat tabel database.
  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    // Tabel master produk.
    await db.execute('''
      CREATE TABLE master_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        image TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');

    // Tabel keranjang.
    // Sekarang image ikut disimpan.
    await db.execute('''
      CREATE TABLE local_cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        image TEXT NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
  }

  // =========================
  // PRODUCT
  // =========================

  // Mengambil semua produk.
  Future<List<Product>> getProducts() async {
    final db = await database;

    final result = await db.query(
      'master_products',
      orderBy: 'id ASC',
    );

    return result
        .map((map) => Product.fromMap(map))
        .toList();
  }

  // Menambahkan produk.
  Future<int> insertProduct(Product product) async {
    final db = await database;

    return await db.insert(
      'master_products',
      product.toMap(),
    );
  }

  // =========================
  // CART
  // =========================

  // Mengambil semua isi keranjang.
  Future<List<CartItem>> getCartItems() async {
    final db = await database;

    final result = await db.query(
      'local_cart',
      orderBy: 'id ASC',
    );

    return result
        .map((map) => CartItem.fromMap(map))
        .toList();
  }

  // Menambahkan produk ke keranjang.
  Future<int> insertCartItem(CartItem item) async {
    final db = await database;

    return await db.insert(
      'local_cart',
      item.toMap(),
    );
  }

  // Mengubah jumlah produk.
  Future<int> updateCartQuantity(
    int id,
    int quantity,
  ) async {
    final db = await database;

    return await db.update(
      'local_cart',
      {
        'quantity': quantity,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus satu produk dari keranjang.
  Future<int> deleteCartItem(int id) async {
    final db = await database;

    return await db.delete(
      'local_cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Mengosongkan semua keranjang.
  Future<void> clearCart() async {
    final db = await database;

    await db.delete('local_cart');
  }
}