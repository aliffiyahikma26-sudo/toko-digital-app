import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();

    // Memuat produk dan keranjang setelah halaman selesai dibuat.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
      context.read<CartProvider>().loadCart();
    });
  }

  // Mengubah angka menjadi format Rupiah.
  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        title: const Text(
          'FOLIO BAG',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                // Tombol menuju halaman keranjang.
                IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CartPage(),
                      ),
                    );
                  },
                ),

                // Jumlah jenis produk dalam keranjang.
                if (cartProvider.items.isNotEmpty)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B6F5A),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartProvider.items.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      // =====================================================
      // ISI HALAMAN
      // =====================================================
      body: productProvider.products.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =================================================
                // HEADER
                // =================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    24,
                    20,
                    8,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Find Your Style',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E342F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Bags for Every Journey',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.brown.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // GRID PRODUK
                // =================================================
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,

                      // Menjaga kartu agar tidak overflow.
                      childAspectRatio: 0.72,
                    ),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product =
                          productProvider.products[index];

                      return Card(
                        clipBehavior: Clip.antiAlias,

                        // =================================================
                        // KLIK KARTU → DETAIL PRODUK
                        // =================================================
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailPage(
                                  product: product,
                                ),
                              ),
                            );
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                // =================================================
                                // GAMBAR PRODUK
                                // =================================================
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFF0E8E1,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      child: Image.asset(
                                        product.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const Center(
                                            child: Icon(
                                              Icons
                                                  .shopping_bag_outlined,
                                              size: 65,
                                              color:
                                                  Color(
                                                0xFF8B6F5A,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // =================================================
                                // NAMA PRODUK
                                // =================================================
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Color(0xFF3E342F),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                // =================================================
                                // HARGA
                                // =================================================
                                Text(
                                  formatRupiah(product.price),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        Color(0xFF8B6F5A),
                                  ),
                                ),

                                const SizedBox(height: 9),

                                // =================================================
                                // TOMBOL TAMBAH
                                // =================================================
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    // Mencegah tombol ikut
                                    // membuka detail produk.
                                    onPressed: () async {
                                      await context
                                          .read<CartProvider>()
                                          .addToCart(product);

                                      if (!context.mounted) {
                                        return;
                                      }

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${product.name} ditambahkan ke keranjang',
                                          ),
                                          duration:
                                              const Duration(
                                            seconds: 1,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Tambah',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}