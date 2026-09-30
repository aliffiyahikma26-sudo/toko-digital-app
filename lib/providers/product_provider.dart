import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper.instance;

  List<Product> _products = [];

  List<Product> get products => _products;

  // Mengambil produk dari database.
  Future<void> loadProducts() async {
    _products = await _dbHelper.getProducts();

    // Jika database kosong,
    // masukkan produk awal.
    if (_products.isEmpty) {
      await _insertInitialProducts();

      _products = await _dbHelper.getProducts();
    }

    notifyListeners();
  }

  // Produk awal Folio Bag.
  Future<void> _insertInitialProducts() async {
    final products = [
      Product(
        name: 'Tote Bag',
        price: 75000,
        image: 'assets/images/tote_bag.jpg',
        description:
            'Tote Bag dengan desain minimalis dan ruang yang luas. Cocok digunakan untuk aktivitas sehari-hari, kuliah, sekolah, maupun bepergian.',
      ),
      Product(
        name: 'Mini Shoulder Bag',
        price: 95000,
        image: 'assets/images/shoulder_bag.jpg',
        description:
            'Mini Shoulder Bag dengan ukuran praktis dan desain modern. Cocok untuk membawa barang-barang kecil saat bepergian.',
      ),
      Product(
        name: 'Sling Bag',
        price: 110000,
        image: 'assets/images/sling_bag.jpg',
        description:
            'Sling Bag bergaya simpel dengan ukuran yang nyaman digunakan. Cocok untuk jalan-jalan dan aktivitas santai.',
      ),
      Product(
        name: 'Backpack',
        price: 150000,
        image: 'assets/images/backpack.jpg',
        description:
            'Backpack dengan kapasitas cukup luas untuk membawa berbagai kebutuhan. Nyaman digunakan untuk sekolah, kuliah, maupun perjalanan.',
      ),
      Product(
        name: 'Laptop Bag',
        price: 175000,
        image: 'assets/images/laptop_bag.jpg',
        description:
            'Laptop Bag dengan desain simpel dan ruang khusus untuk membawa laptop serta perlengkapan kerja atau belajar.',
      ),
      Product(
        name: 'Canvas Bag',
        price: 85000,
        image: 'assets/images/canvas_bag.jpg',
        description:
            'Canvas Bag berbahan kanvas dengan tampilan casual. Cocok untuk kegiatan sehari-hari dan berbagai gaya.',
      ),
      Product(
        name: 'Mini Pouch',
        price: 45000,
        image: 'assets/images/mini_pouch.jpg',
        description:
            'Mini Pouch berukuran kecil dan praktis untuk menyimpan aksesori, alat tulis, kosmetik, atau barang kecil lainnya.',
      ),
      Product(
        name: 'Travel Pouch',
        price: 55000,
        image: 'assets/images/travel_pouch.jpg',
        description:
            'Travel Pouch praktis untuk membantu menyimpan dan mengatur barang-barang kecil selama perjalanan.',
      ),
    ];

    // Memasukkan produk ke database.
    for (final product in products) {
      await _dbHelper.insertProduct(product);
    }
  }
}