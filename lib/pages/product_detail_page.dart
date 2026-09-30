import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  // Format harga menjadi Rupiah.
  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // ISI DETAIL
      // =====================================================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // FOTO PRODUK BESAR
            // =================================================
            Container(
              width: double.infinity,
              height: 380,
              color: const Color(0xFFF0E8E1),
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
              ),
            ),

            // =================================================
            // INFORMASI PRODUK
            // =================================================
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama produk.
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E342F),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Harga produk.
                  Text(
                    formatRupiah(product.price),
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B6F5A),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Judul deskripsi.
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E342F),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Deskripsi produk.
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF665A53),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // TOMBOL TAMBAH KE KERANJANG
                  // =================================================
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      label: const Text(
                        'Tambah ke Keranjang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        // Menambahkan produk ke keranjang.
                        await context
                            .read<CartProvider>()
                            .addToCart(product);

                        if (!context.mounted) {
                          return;
                        }

                        // Menampilkan pesan berhasil.
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.name} ditambahkan ke keranjang',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}