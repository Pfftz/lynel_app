import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Get all products
  Stream<QuerySnapshot> getProducts() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get products with limit (for featured products)
  Stream<QuerySnapshot> getFeaturedProducts({int limit = 5}) {
    return _firestore.collection(_collection).limit(limit).snapshots();
  }

  // Get single product by ID
  Future<DocumentSnapshot> getProduct(String productId) {
    return _firestore.collection(_collection).doc(productId).get();
  }

  // Add new product
  Future<DocumentReference> addProduct({
    required String name,
    required String description,
    required double price,
    required String imageUrl,
  }) {
    return _firestore.collection(_collection).add({
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update product
  Future<void> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
  }) {
    return _firestore.collection(_collection).doc(productId).update({
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete product
  Future<void> deleteProduct(String productId) {
    return _firestore.collection(_collection).doc(productId).delete();
  }

  // Search products by name
  Stream<QuerySnapshot> searchProducts(String searchTerm) {
    return _firestore
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: searchTerm)
        .where('name', isLessThan: '${searchTerm}z')
        .snapshots();
  }

  // Get products by price range
  Stream<QuerySnapshot> getProductsByPriceRange({
    double? minPrice,
    double? maxPrice,
  }) {
    Query query = _firestore.collection(_collection);

    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    return query.snapshots();
  }

  // Update product availability (if you add this field later)
  Future<void> updateProductAvailability(String productId, bool isAvailable) {
    return _firestore.collection(_collection).doc(productId).update({
      'isAvailable': isAvailable,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
