import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  // Mengakses database.
  final DBHelper _dbHelper = DBHelper.instance;

  // Menyimpan daftar produk dalam keranjang.
  List<CartItem> _items = [];

  // Getter untuk mengambil isi keranjang.
  List<CartItem> get items => _items;

  // =========================
  // LOAD CART
  // =========================

  // Mengambil data keranjang dari SQLite.
  Future<void> loadCart() async {
    _items = await _dbHelper.getCartItems();

    notifyListeners();
  }

  // =========================
  // ADD TO CART
  // =========================

  // Menambahkan produk ke keranjang.
  Future<void> addToCart(Product product) async {
    // Mengecek apakah produk sudah ada.
    final index = _items.indexWhere(
      (item) => item.productId == product.id,
    );

    if (index != -1) {
      // Jika sudah ada, jumlah ditambah 1.
      final item = _items[index];

      item.quantity++;

      await _dbHelper.updateCartQuantity(
        item.id!,
        item.quantity,
      );
    } else {
      // Jika belum ada, buat item baru.
      final item = CartItem(
        productId: product.id!,
        name: product.name,
        price: product.price,

        // Foto produk ikut disimpan.
        image: product.image,

        quantity: 1,
      );

      await _dbHelper.insertCartItem(item);
    }

    // Memuat ulang data keranjang.
    await loadCart();
  }

  // =========================
  // INCREASE
  // =========================

  // Menambah jumlah produk.
  Future<void> increaseQuantity(CartItem item) async {
    item.quantity++;

    await _dbHelper.updateCartQuantity(
      item.id!,
      item.quantity,
    );

    await loadCart();
  }

  // =========================
  // DECREASE
  // =========================

  // Mengurangi jumlah produk.
  Future<void> decreaseQuantity(CartItem item) async {
    if (item.quantity > 1) {
      // Jika jumlah lebih dari 1,
      // cukup kurangi jumlahnya.
      item.quantity--;

      await _dbHelper.updateCartQuantity(
        item.id!,
        item.quantity,
      );
    } else {
      // Jika jumlah hanya 1,
      // produk dihapus dari keranjang.
      await _dbHelper.deleteCartItem(
        item.id!,
      );
    }

    await loadCart();
  }

  // =========================
  // DELETE
  // =========================

  // Menghapus satu produk.
  Future<void> removeItem(CartItem item) async {
    await _dbHelper.deleteCartItem(
      item.id!,
    );

    await loadCart();
  }

  // =========================
  // CLEAR CART
  // =========================

  // Mengosongkan seluruh keranjang.
  Future<void> clearCart() async {
    await _dbHelper.clearCart();

    await loadCart();
  }

  // =========================
  // TOTAL
  // =========================

  // Menghitung total harga semua produk.
  int get total {
    return _items.fold(
      0,
      (sum, item) => sum + item.subtotal,
    );
  }
}
