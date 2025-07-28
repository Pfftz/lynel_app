import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import Firebase Auth for auth state listening
import 'package:firebase_auth/firebase_auth.dart';

// Import halaman dari pages
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/detail_produk_page.dart';
import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
import 'pages/konfirmasi_pembayaran_page.dart';
import 'pages/register_page.dart';
import 'pages/admin_panel_page.dart';
import 'pages/product_list_page.dart';
import 'pages/image_debug_page.dart';

// Import screens untuk fallback atau admin
// import 'screens/home_screen.dart';

// Theme dari pages
import 'pages/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WatraNusaApp());
}

class WatraNusaApp extends StatelessWidget {
  const WatraNusaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WastraNusa',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        // '/home_screen': (context) =>
        //     const HomeScreen(), // Fallback to screens version
        '/detail': (context) => const DetailProdukPage(),
        '/cart': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as List<Map<String, dynamic>>?;
          return CartPage(cartItems: args);
        },
        '/checkout': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as List<Map<String, dynamic>>?;
          return CheckoutPage(cartItems: args ?? []);
        },
        '/konfirmasi': (context) => const KonfirmasiPembayaranPage(),
        '/admin': (context) => const AdminPanelPage(),
        '/products': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ProductListPage(
            category: args?['category'],
            title: args?['title'] ?? 'Produk',
            sortBy: args?['sortBy'],
          );
        },
        '/debug': (context) => const ImageDebugPage(),
      },
    );
  }
}

// Auth wrapper to handle authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData) {
          return const HomePage();
        }

        // User is not logged in
        return const LoginPage();
      },
    );
  }
}
