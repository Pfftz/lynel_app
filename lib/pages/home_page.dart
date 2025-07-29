import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'admin_panel_page.dart';
import 'theme.dart';
import '../utils/image_url_helper.dart';
import '../widgets/cart_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final user = authService.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Stack(
          children: [
            // Background dengan gradien Nusantara
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      earthBrown,
                      deepTeak,
                    ],
                  ),
                ),
              ),
            ),

            // Overlay gambar dengan opacity 0.2
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/mega_mendung.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Konten header
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WastraNusa',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: Theme.of(context).textTheme.headlineLarge?.fontFamily,
                        letterSpacing: 1,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: CartIcon(
                            iconColor: Colors.white,
                            onTap: () {
                              Navigator.pushNamed(context, '/cart');
                            },
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/cart');
                          },
                          tooltip: 'Keranjang',
                        ),
                        if (authService.isAdmin)
                          IconButton(
                            icon: Icon(Icons.admin_panel_settings, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AdminPanelPage()),
                              );
                            },
                            tooltip: 'Admin Panel',
                          ),
                        IconButton(
                          icon: Icon(Icons.logout, color: Colors.white),
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
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    warmCream,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: earthBrown.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang di WastraNusa!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: earthBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${user?.email ?? 'Tamu'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: deepTeak,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Temukan koleksi batik dan tekstil Nusantara terbaik',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Banner
            Container(
              margin: const EdgeInsets.all(16),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    goldenAmber.withOpacity(0.8),
                    earthBrown,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: earthBrown.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/banner_batik.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  goldenAmber,
                                  earthBrown,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Koleksi Batik Eksklusif',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Karya seni tradisional Indonesia',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Kategori
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kategori',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: earthBrown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/products', arguments: {
                        'title': 'Semua Produk',
                        'sortBy': 'all',
                      });
                    },
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
                  ];

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    categories = ['Semua', ...snapshot.data!.toList()];
                  } else {
                    categories = ['Semua', ...categories];
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: categories
                        .map((category) =>
                            _categoryTile(context, category, _getCategoryIcon(category), theme))
                        .toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Produk Unggulan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Produk Unggulan',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/products', arguments: {
                        'title': 'Produk Unggulan',
                        'sortBy': 'featured',
                      });
                    },
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
                          return Center(
                              child: Text(
                            'Tidak ada produk tersedia',
                            style: theme.textTheme.bodyMedium,
                          ));
                        }

                        final products = fallbackSnapshot.data!.docs;
                        return _buildProductList(context, products);
                      },
                    );
                  }

                  final products = snapshot.data!.docs;
                  return _buildProductList(context, products);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Produk Terbaru
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Produk Terbaru',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/products', arguments: {
                        'title': 'Produk Terbaru',
                        'sortBy': 'newest',
                      });
                    },
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .limit(10) // Get more to sort client-side
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text(
                      'Tidak ada produk tersedia',
                      style: theme.textTheme.bodyMedium,
                    ));
                  }

                  // Sort products by createdAt client-side and take top 5
                  List<QueryDocumentSnapshot> products = snapshot.data!.docs.toList();
                  products.sort((a, b) {
                    final dataA = a.data() as Map<String, dynamic>;
                    final dataB = b.data() as Map<String, dynamic>;
                    final dateA = dataA['createdAt'] as Timestamp?;
                    final dateB = dataB['createdAt'] as Timestamp?;
                    
                    // If both have no createdAt, maintain original order
                    if (dateA == null && dateB == null) return 0;
                    // If only A has no createdAt, put it after B
                    if (dateA == null) return 1;
                    // If only B has no createdAt, put it after A
                    if (dateB == null) return -1;
                    
                    // Both have createdAt, sort by date (newest first)
                    return dateB.compareTo(dateA);
                  });
                  
                  // Take only the first 5 products
                  final limitedProducts = products.take(5).toList();
                  return _buildProductList(context, limitedProducts);
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        backgroundColor: earthBrown,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        tooltip: 'Keranjang Belanja',
      ),
    );
  }

  static Widget _buildProductList(
      BuildContext context, List<QueryDocumentSnapshot> products) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16, right: 8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index].data() as Map<String, dynamic>;
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 12),
          child: _buildProductCard(context, product, products[index].id),
        );
      },
    );
  }

  static Widget _categoryTile(BuildContext context, String label, IconData icon, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        if (label == 'Semua') {
          Navigator.pushNamed(context, '/products', arguments: {
            'title': 'Semua Produk',
            'sortBy': 'all',
          });
        } else {
          Navigator.pushNamed(context, '/products', arguments: {
            'category': label,
            'title': 'Kategori $label',
            'sortBy': 'all',
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: label == 'Semua' 
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.secondary.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: label == 'Semua' 
              ? Border.all(color: theme.colorScheme.primary, width: 1)
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon, 
              color: label == 'Semua' 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: label == 'Semua' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildProductCard(
      BuildContext context, Map<String, dynamic> product, String productId) {
    final theme = Theme.of(context);
    
    // Debug print to see the product data
    print('Product data: $product');
    print('Product imageUrl: ${product['imageUrl']}');
    
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
                        product['imageUrl'].toString().isNotEmpty
                    ? Builder(
                        builder: (context) {
                          final rawImageUrl = product['imageUrl'].toString();
                          final imageUrl = ImageUrlHelper.getDirectImageUrl(rawImageUrl);
                          
                          print('Raw image URL: $rawImageUrl');
                          print('Converted image URL: $imageUrl');
                          
                          if (imageUrl == null || imageUrl.isEmpty) {
                            return Image.asset(
                              'assets/images/sample_batik.jpg',
                              fit: BoxFit.cover,
                            );
                          }
                          
                          return Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            headers: const {
                              'User-Agent': 'Mozilla/5.0 (compatible; Flutter app)',
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Loading...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('Image loading error: $error');
                              print('Image URL: $imageUrl');
                              print('Stack trace: $stackTrace');
                              
                              // Fallback to asset image on error
                              return Image.asset(
                                'assets/images/sample_batik.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.image_not_supported,
                                          size: 32,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'No image',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/sample_batik.jpg',
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(
                          product['price'] ?? 0, product['currency'] ?? 'IDR'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
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

      if (categories.isEmpty) {
        categories.addAll(['Kemeja', 'Kain', 'Outer', 'Dress']);
      }

      return categories;
    } catch (e) {
      return {'Kemeja', 'Kain', 'Outer', 'Dress'};
    }
  }

  static IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'semua':
        return Icons.grid_view;
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
