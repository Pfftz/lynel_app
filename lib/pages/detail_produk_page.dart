import 'package:flutter/material.dart';
import '../utils/image_url_helper.dart';
import '../services/cart_service.dart';
import '../pages/theme.dart';

class DetailProdukPage extends StatefulWidget {
  const DetailProdukPage({super.key});

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  String? selectedColor;
  String? selectedSize;
  int quantity = 1;
  Map<String, dynamic>? product;
  String? productId;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      product = args['product'] as Map<String, dynamic>?;
      productId = args['productId'] as String?;

      // Set default selections only if product has colors/sizes
      if (product != null) {
        final colors = product!['colors'] as List?;
        final sizes = product!['sizes'] as List?;

        // Set default color if available
        if (colors?.isNotEmpty == true) {
          selectedColor = colors!.first.toString();
        }

        // Set default size if available
        if (sizes?.isNotEmpty == true) {
          selectedSize = sizes!.first.toString();
        }
      }
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Produk tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: nusantaraBeige,
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: earthBrown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: product!['imageUrl'] != null &&
                      product!['imageUrl'].isNotEmpty
                  ? Image.network(
                      ImageUrlHelper.getDirectImageUrl(product!['imageUrl']) ?? product!['imageUrl'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Image loading error: $error');
                        print('Original URL: ${product!['imageUrl']}');
                        print('Converted URL: ${ImageUrlHelper.getDirectImageUrl(product!['imageUrl'])}');
                        return Image.asset(
                          'lib/assets/sample_batik.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Gambar tidak dapat dimuat',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Gambar produk',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
            ),

            // Informasi Produk
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product!['name'] ?? 'Produk Batik',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(
                        product!['price'] ?? 0, product!['currency'] ?? 'IDR'),
                    style: const TextStyle(fontSize: 18, color: earthBrown),
                  ),
                  const SizedBox(height: 16),

                  if (product!['description'] != null &&
                      product!['description'].isNotEmpty) ...[
                    const Text(
                      'Deskripsi:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product!['description'],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Additional product info
                  if (product!['category'] != null)
                    _buildInfoRow('Kategori', product!['category']),
                  if (product!['material'] != null)
                    _buildInfoRow('Bahan', product!['material']),
                  if (product!['origin'] != null)
                    _buildInfoRow('Asal Daerah', product!['origin']),
                  if (product!['pattern'] != null)
                    _buildInfoRow('Motif', product!['pattern']),
                  if (product!['stock'] != null)
                    _buildInfoRow('Stok', '${product!['stock']} pcs'),

                  const SizedBox(height: 16),

                  // Warna selection
                  if (product!['colors'] != null &&
                      (product!['colors'] as List).isNotEmpty) ...[
                    const Text('Warna:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton<String>(
                        value: selectedColor,
                        hint: const Text('Pilih Warna'),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: (product!['colors'] as List)
                            .map((color) => DropdownMenuItem(
                                value: color.toString(),
                                child: Text(color.toString())))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedColor = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Size selection
                  if (product!['sizes'] != null &&
                      (product!['sizes'] as List).isNotEmpty) ...[
                    const Text('Ukuran:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton<String>(
                        value: selectedSize,
                        hint: const Text('Pilih Ukuran'),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: (product!['sizes'] as List)
                            .map((size) => DropdownMenuItem(
                                value: size.toString(),
                                child: Text(size.toString())))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedSize = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 8),
                  const Text('Jumlah:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                final maxStock = product!['stock'] ?? 999;
                                if (quantity < maxStock) {
                                  setState(() => quantity++);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Maksimal pembelian: $maxStock'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (product!['stock'] != null)
                        Text(
                          'Stok tersedia: ${product!['stock']}',
                          style: TextStyle(
                            color: (product!['stock'] as int) > 0
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (product!['stock'] ?? 0) > 0
                                ? earthBrown
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed:
                              (product!['stock'] ?? 0) > 0 ? _addToCart : null,
                          icon: const Icon(Icons.shopping_cart),
                          label: Text((product!['stock'] ?? 0) > 0
                              ? 'Tambah ke Keranjang'
                              : 'Stok Habis'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (product!['stock'] ?? 0) > 0
                                ? goldenAmber
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed:
                              (product!['stock'] ?? 0) > 0 ? _buyNow : null,
                          icon: const Icon(Icons.flash_on),
                          label: Text((product!['stock'] ?? 0) > 0
                              ? 'Beli Sekarang'
                              : 'Tidak Tersedia'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Product Features (if available)
                  if (product!['featured'] == true) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star,
                              color: Colors.orange.shade700, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Produk Unggulan',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Tags (if available)
                  if (product!['tags'] != null &&
                      (product!['tags'] as List).isNotEmpty) ...[
                    const Text(
                      'Tags:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: (product!['tags'] as List)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.brown.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag.toString(),
                                style: TextStyle(
                                  color: Colors.brown.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const Text(
                    'Ulasan:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Bagus banget kualitasnya!'),
                    subtitle: Text('⭐⭐⭐⭐⭐'),
                  ),
                ],
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _addToCart() async {
    // Validate selections
    if (product!['colors'] != null &&
        (product!['colors'] as List).isNotEmpty &&
        selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih warna terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (product!['sizes'] != null &&
        (product!['sizes'] as List).isNotEmpty &&
        selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih ukuran terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check stock
    final stock = product!['stock'] ?? 0;
    if (stock < quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok tidak mencukupi. Stok tersedia: $stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cartItem = {
      'name': product!['name'],
      'price': product!['price'],
      'currency': product!['currency'] ?? 'IDR',
      'qty': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'imageUrl': product!['imageUrl'],
      'productId': productId,
      'category': product!['category'],
      'material': product!['material'],
      'origin': product!['origin'],
    };

    try {
      // Add item to cart using CartService
      await CartService.instance.addItem(cartItem);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk berhasil ditambahkan ke keranjang!'),
            backgroundColor: Colors.green,
          ),
        );

        // Show option to continue shopping or go to cart
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Berhasil!'),
              content: const Text('Produk telah ditambahkan ke keranjang. Apa yang ingin Anda lakukan selanjutnya?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Lanjut Belanja'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: earthBrown,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Lihat Keranjang'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _buyNow() async {
    // Validate selections first
    if (product!['colors'] != null &&
        (product!['colors'] as List).isNotEmpty &&
        selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih warna terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (product!['sizes'] != null &&
        (product!['sizes'] as List).isNotEmpty &&
        selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih ukuran terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check stock
    final stock = product!['stock'] ?? 0;
    if (stock < quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok tidak mencukupi. Stok tersedia: $stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cartItem = {
      'name': product!['name'],
      'price': product!['price'],
      'currency': product!['currency'] ?? 'IDR',
      'qty': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'imageUrl': product!['imageUrl'],
      'productId': productId,
      'category': product!['category'],
      'material': product!['material'],
      'origin': product!['origin'],
    };

    // Navigate directly to checkout with single item
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: [cartItem],
    );
  }
}
