import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

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

      // App Bar
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8F4F0),
        foregroundColor: const Color(0xFF3E342F),
        elevation: 0,
      ),

      // Isi keranjang
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          // Jika keranjang kosong.
          if (cart.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Color(0xFF8B6F5A),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E342F),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Yuk pilih produk terlebih dahulu.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF665A53),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Daftar produk.
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // =========================
                            // FOTO PRODUK
                            // =========================
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 90,
                                height: 90,
                                color: const Color(0xFFF0E8E1),
                                child: item.image.isNotEmpty
                                    ? Image.asset(
                                        item.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 40,
                                            color: Color(0xFF8B6F5A),
                                          );
                                        },
                                      )
                                    : const Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 40,
                                        color: Color(0xFF8B6F5A),
                                      ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // =========================
                            // INFORMASI PRODUK
                            // =========================
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nama produk.
                                  Text(
                                    item.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3E342F),
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  // Harga satuan.
                                  Text(
                                    formatRupiah(item.price),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF8B6F5A),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Tombol jumlah.
                                  Row(
                                    children: [
                                      // Tombol -
                                      InkWell(
                                        onTap: () {
                                          context
                                              .read<CartProvider>()
                                              .decreaseQuantity(item);
                                        },
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFF8B6F5A),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.remove,
                                            size: 18,
                                            color: Color(0xFF8B6F5A),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      // Jumlah.
                                      Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF3E342F),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      // Tombol +
                                      InkWell(
                                        onTap: () {
                                          context
                                              .read<CartProvider>()
                                              .increaseQuantity(item);
                                        },
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8B6F5A),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // =========================
                            // HAPUS + SUBTOTAL
                            // =========================
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Tombol hapus.
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<CartProvider>()
                                        .removeItem(item);
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                  tooltip: 'Hapus',
                                ),

                                const SizedBox(height: 8),

                                // Subtotal.
                                Text(
                                  formatRupiah(item.subtotal),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E342F),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // =========================
              // TOTAL DAN PEMBAYARAN
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, -3),
                      color: Color(0x22000000),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      // Total pembayaran.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E342F),
                            ),
                          ),
                          Text(
                            formatRupiah(cart.total),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B6F5A),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Tombol pembayaran.
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Mengosongkan keranjang.
                            await context
                                .read<CartProvider>()
                                .clearCart();

                            // Mengecek halaman masih aktif.
                            if (!context.mounted) {
                              return;
                            }

                            // Menampilkan pesan berhasil.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Pembayaran berhasil!',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.payment,
                          ),
                          label: const Text(
                            'Bayar Sekarang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B6F5A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}