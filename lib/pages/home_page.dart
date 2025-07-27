import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'admin_panel_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'WastraNusa',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Admin Panel Button (only for admin users)
          if (authService.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings,
                  color: Colors.deepPurple),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPanelPage(),
                  ),
                );
              },
              tooltip: 'Admin Panel',
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.brown),
            onPressed: () async {
              try {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${user?.email ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                  ),
                ],
              ),
            ),

            // Banner
            Container(
              margin: const EdgeInsets.all(16),
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('lib/assets/banner_batik.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Kategori with Firebase data
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 80,
              child: FutureBuilder<Set<String>>(
                future: _getCategories(),
                builder: (context, snapshot) {
                  List<String> categories = [
                    'Kemeja',
                    'Kain',
                    'Outer',
                    'Dress'
                  ]; // Default categories

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    categories = snapshot.data!.toList();
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: categories
                        .map((category) =>
                            _categoryTile(category, _getCategoryIcon(category)))
                        .toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Produk Unggulan (Firebase)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Produk Unggulan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 250,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('featured', isEqualTo: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // Fallback to all products if no featured products
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .limit(5)
                          .snapshots(),
                      builder: (context, fallbackSnapshot) {
                        if (fallbackSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!fallbackSnapshot.hasData ||
                            fallbackSnapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('Tidak ada produk tersedia'));
                        }

                        final products = fallbackSnapshot.data!.docs;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product =
                                products[index].data() as Map<String, dynamic>;
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 12),
                              child: _buildProductCard(
                                  context, product, products[index].id),
                            );
                          },
                        );
                      },
                    );
                  }

                  final products = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product =
                          products[index].data() as Map<String, dynamic>;
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        child: _buildProductCard(
                            context, product, products[index].id),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static Widget _categoryTile(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.brown),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static Widget _buildProductCard(
      BuildContext context, Map<String, dynamic> product, String productId) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: {
          'product': product,
          'productId': productId,
        });
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                child: product['imageUrl'] != null &&
                        product['imageUrl'].isNotEmpty
                    ? Image.network(
                        product['imageUrl'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 32,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        'lib/assets/sample_batik.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image,
                              size: 32,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Produk Batik',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(
                          product['price'] ?? 0, product['currency'] ?? 'IDR'),
                      style: const TextStyle(color: Colors.brown),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatCurrency(dynamic price, String currency) {
    if (currency == 'IDR') {
      return 'Rp ${(price ?? 0).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    } else {
      return '\$${(price ?? 0).toStringAsFixed(2)}';
    }
  }

  // Get categories from Firebase products
  static Future<Set<String>> _getCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final categories = <String>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['category'] != null &&
            data['category'].toString().isNotEmpty) {
          categories.add(data['category'].toString());
        }
      }

      // Add default categories if none found
      if (categories.isEmpty) {
        categories.addAll(['Kemeja', 'Kain', 'Outer', 'Dress']);
      }

      return categories;
    } catch (e) {
      // Return default categories on error
      return {'Kemeja', 'Kain', 'Outer', 'Dress'};
    }
  }

  static IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'kemeja':
        return Icons.checkroom;
      case 'kain':
        return Icons.texture;
      case 'outer':
        return Icons.style;
      case 'dress':
        return Icons.dry_cleaning;
      default:
        return Icons.category;
    }
  }
}
