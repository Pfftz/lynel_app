import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> populateProducts() async {
    if (kDebugMode) {
      print('Starting to populate products...');
    }

    final List<Map<String, dynamic>> products = [
      {
        'name': 'Kemeja Batik Mega Mendung',
        'description':
            'Kemeja batik dengan motif mega mendung khas Cirebon. Terbuat dari katun premium.',
        'price': 250000,
        'currency': 'IDR',
        'category': 'Kemeja',
        'colors': ['Coklat', 'Hitam', 'Biru'],
        'sizes': ['M', 'L', 'XL'],
        'stock': 15,
        'featured': true,
        'material': 'Katun',
        'origin': 'Cirebon',
        'pattern': 'Mega Mendung',
        'imageUrl':
            'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400',
        'tags': ['batik', 'kemeja', 'formal'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Kain Batik Parang',
        'description':
            'Kain batik dengan motif parang klasik. Cocok untuk berbagai keperluan.',
        'price': 180000,
        'currency': 'IDR',
        'category': 'Kain',
        'colors': ['Coklat', 'Hitam'],
        'sizes': ['2.5m', '3m'],
        'stock': 20,
        'featured': true,
        'material': 'Katun',
        'origin': 'Yogyakarta',
        'pattern': 'Parang',
        'imageUrl':
            'https://images.unsplash.com/photo-1618563981847-30b8e5d1fd04?w=400',
        'tags': ['batik', 'kain', 'traditional'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Outer Batik Modern',
        'description':
            'Outer batik dengan desain modern yang stylish dan nyaman dipakai.',
        'price': 320000,
        'currency': 'IDR',
        'category': 'Outer',
        'colors': ['Navy', 'Coklat', 'Hitam'],
        'sizes': ['S', 'M', 'L', 'XL'],
        'stock': 12,
        'featured': false,
        'material': 'Katun',
        'origin': 'Solo',
        'pattern': 'Modern',
        'imageUrl':
            'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        'tags': ['batik', 'outer', 'modern'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Dress Batik Kawung',
        'description':
            'Dress batik dengan motif kawung yang elegan dan feminin.',
        'price': 280000,
        'currency': 'IDR',
        'category': 'Dress',
        'colors': ['Merah', 'Coklat', 'Biru'],
        'sizes': ['S', 'M', 'L'],
        'stock': 8,
        'featured': true,
        'material': 'Sutra',
        'origin': 'Yogyakarta',
        'pattern': 'Kawung',
        'imageUrl':
            'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=400',
        'tags': ['batik', 'dress', 'elegant'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Kemeja Batik Casual',
        'description':
            'Kemeja batik casual untuk kegiatan sehari-hari. Nyaman dan stylish.',
        'price': 195000,
        'currency': 'IDR',
        'category': 'Kemeja',
        'colors': ['Biru', 'Hijau', 'Coklat'],
        'sizes': ['M', 'L', 'XL', 'XXL'],
        'stock': 25,
        'featured': false,
        'material': 'Katun',
        'origin': 'Pekalongan',
        'pattern': 'Casual',
        'imageUrl':
            'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400',
        'tags': ['batik', 'kemeja', 'casual'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Blouse Batik Wanita',
        'description':
            'Blouse batik wanita dengan motif yang cantik dan elegan. Cocok untuk acara formal.',
        'price': 225000,
        'currency': 'IDR',
        'category': 'Blouse',
        'colors': ['Pink', 'Ungu', 'Coklat'],
        'sizes': ['S', 'M', 'L', 'XL'],
        'stock': 18,
        'featured': true,
        'material': 'Katun',
        'origin': 'Pekalongan',
        'pattern': 'Bunga',
        'imageUrl':
            'https://images.unsplash.com/photo-1583744946564-b52ac1c389c8?w=400',
        'tags': ['batik', 'blouse', 'wanita', 'formal'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Sarung Batik Premium',
        'description':
            'Sarung batik premium dengan motif tradisional yang indah.',
        'price': 350000,
        'currency': 'IDR',
        'category': 'Sarung',
        'colors': ['Hitam', 'Coklat', 'Navy'],
        'sizes': ['Standard'],
        'stock': 10,
        'featured': false,
        'material': 'Sutra',
        'origin': 'Solo',
        'pattern': 'Tradisional',
        'imageUrl':
            'https://images.unsplash.com/photo-1583744946564-b52ac1c389c8?w=400',
        'tags': ['batik', 'sarung', 'premium', 'traditional'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Kemeja Batik Anak',
        'description':
            'Kemeja batik khusus untuk anak-anak dengan motif yang ceria dan warna-warna cerah.',
        'price': 150000,
        'currency': 'IDR',
        'category': 'Anak',
        'colors': ['Merah', 'Biru', 'Hijau'],
        'sizes': ['XS', 'S', 'M'],
        'stock': 30,
        'featured': true,
        'material': 'Katun',
        'origin': 'Yogyakarta',
        'pattern': 'Anak',
        'imageUrl':
            'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?w=400',
        'tags': ['batik', 'kemeja', 'anak', 'colorful'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    try {
      // Check if products already exist
      final existingProducts =
          await _firestore.collection('products').limit(1).get();
      if (existingProducts.docs.isNotEmpty) {
        if (kDebugMode) {
          print('⚠️  Products already exist in database. Skipping population.');
          print(
              'If you want to repopulate, delete all products first from Firebase Console.');
        }
        return;
      }

      // Add products to Firestore
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        await _firestore.collection('products').add(product);
        if (kDebugMode) {
          print('✅ Added product ${i + 1}: ${product['name']}');
        }
      }

      if (kDebugMode) {
        print(
            '\n🎉 Successfully added ${products.length} products to Firebase!');
        print('Your app is now ready to use with sample data.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding products: $e');
      }
      rethrow;
    }
  }

  static Future<void> clearAllProducts() async {
    try {
      if (kDebugMode) {
        print('🗑️  Clearing all products...');
      }
      final products = await _firestore.collection('products').get();

      for (var doc in products.docs) {
        await doc.reference.delete();
      }

      if (kDebugMode) {
        print('✅ Cleared ${products.docs.length} products');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing products: $e');
      }
      rethrow;
    }
  }
}
