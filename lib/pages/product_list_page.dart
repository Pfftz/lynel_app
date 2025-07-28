import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme.dart';
import '../utils/image_url_helper.dart';

class ProductListPage extends StatefulWidget {
  final String? category;
  final String title;
  final String? sortBy; // 'newest', 'featured', 'all'

  const ProductListPage({
    super.key,
    this.category,
    required this.title,
    this.sortBy,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: nusantaraBeige,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: earthBrown,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getProductStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada produk ditemukan',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.category != null 
                        ? 'Belum ada produk di kategori "${widget.category}"'
                        : 'Belum ada produk tersedia',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Process and sort the data client-side
          List<QueryDocumentSnapshot> products = snapshot.data!.docs;
          
          // Apply additional filtering if needed
          if (widget.sortBy == 'featured' && widget.category != null && widget.category!.isNotEmpty) {
            products = products.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['category'] == widget.category;
            }).toList();
          }
          
          // Apply client-side sorting
          if (widget.sortBy == 'newest' && widget.category != null && widget.category!.isNotEmpty) {
            products.sort((a, b) {
              final dataA = a.data() as Map<String, dynamic>;
              final dataB = b.data() as Map<String, dynamic>;
              final dateA = dataA['createdAt'] as Timestamp?;
              final dateB = dataB['createdAt'] as Timestamp?;
              
              if (dateA == null && dateB == null) return 0;
              if (dateA == null) return 1;
              if (dateB == null) return -1;
              
              return dateB.compareTo(dateA); // Descending order (newest first)
            });
          } else if (widget.sortBy == 'all' && widget.category != null && widget.category!.isNotEmpty) {
            products.sort((a, b) {
              final dataA = a.data() as Map<String, dynamic>;
              final dataB = b.data() as Map<String, dynamic>;
              final nameA = dataA['name'] as String? ?? '';
              final nameB = dataB['name'] as String? ?? '';
              return nameA.compareTo(nameB);
            });
          }

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada produk ditemukan',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.category != null 
                        ? 'Belum ada produk di kategori "${widget.category}"'
                        : 'Belum ada produk tersedia',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              final productId = products[index].id;
              return _buildProductCard(context, product, productId, theme);
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getProductStream() {
    // Use the simplest possible queries to avoid composite index requirements
    if (widget.sortBy == 'featured' && (widget.category == null || widget.category!.isEmpty)) {
      // Only featured products, no category filter
      return FirebaseFirestore.instance
          .collection('products')
          .where('featured', isEqualTo: true)
          .snapshots();
    } else if (widget.category != null && widget.category!.isNotEmpty) {
      // Category filter only, no orderBy to avoid composite index
      return FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: widget.category)
          .snapshots();
    } else if (widget.sortBy == 'newest') {
      // Newest products only, no category filter
      return FirebaseFirestore.instance
          .collection('products')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      // All products, no filters
      return FirebaseFirestore.instance
          .collection('products')
          .snapshots();
    }
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product, 
      String productId, ThemeData theme) {
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
              flex: 3,
              child: Container(
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
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 32,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'No image',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
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
              flex: 2,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (product['category'] != null)
                      Text(
                        product['category'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    const Spacer(),
                    Text(
                      _formatCurrency(
                          product['price'] ?? 0, product['currency'] ?? 'IDR'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
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

  String _formatCurrency(dynamic price, String currency) {
    if (currency == 'IDR') {
      return 'Rp ${(price ?? 0).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    } else {
      return '\$${(price ?? 0).toStringAsFixed(2)}';
    }
  }
}
