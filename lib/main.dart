import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/product_page.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(const FolioBagApp());
}

class FolioBagApp extends StatelessWidget {
  const FolioBagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Folio Bag',
        theme: ThemeData(
          useMaterial3: true,

          // Warna utama Folio Bag
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B6F5A),
          ),

          // Font utama
          fontFamily: 'Poppins',

          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Color(0xFFF8F4F0),
            foregroundColor: Color(0xFF3E342F),
            elevation: 0,
          ),

          cardTheme: CardThemeData(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B6F5A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: const ProductPage(),
      ),
    );
  }
}