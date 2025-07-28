import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String _cartKey = 'cart_items';
  static CartService? _instance;
  static CartService get instance => _instance ??= CartService._();
  
  CartService._();
  
  List<Map<String, dynamic>> _cartItems = [];
  
  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);
  
  int get itemCount => _cartItems.fold<int>(0, (sum, item) => sum + (item['qty'] as int? ?? 0));
  
  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      dynamic price = item['price'] ?? 0;
      int qty = (item['qty'] ?? 0).toInt();
      total += (price is String ? double.tryParse(price) ?? 0 : price.toDouble()) * qty;
    }
    return total;
  }
  
  // Load cart from local storage
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> cartList = json.decode(cartJson);
        _cartItems = cartList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      print('Error loading cart: $e');
      _cartItems = [];
    }
  }
  
  // Save cart to local storage
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(_cartItems);
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }
  
  // Add item to cart
  Future<void> addItem(Map<String, dynamic> item) async {
    // Check if item already exists with same product ID, color, and size
    final existingIndex = _cartItems.indexWhere((cartItem) =>
        cartItem['productId'] == item['productId'] &&
        cartItem['selectedColor'] == item['selectedColor'] &&
        cartItem['selectedSize'] == item['selectedSize']);
    
    if (existingIndex != -1) {
      // Update quantity of existing item
      _cartItems[existingIndex]['qty'] = (_cartItems[existingIndex]['qty'] ?? 0) + (item['qty'] ?? 1);
    } else {
      // Add new item
      _cartItems.add(item);
    }
    
    await _saveCart();
  }
  
  // Remove item from cart
  Future<void> removeItem(int index) async {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      await _saveCart();
    }
  }
  
  // Update item quantity
  Future<void> updateQuantity(int index, int quantity) async {
    if (index >= 0 && index < _cartItems.length) {
      if (quantity <= 0) {
        await removeItem(index);
      } else {
        _cartItems[index]['qty'] = quantity;
        await _saveCart();
      }
    }
  }
  
  // Clear entire cart
  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
  }
  
  // Get formatted currency
  static String formatCurrency(dynamic price, String currency) {
    if (currency == 'IDR') {
      return 'Rp ${(price ?? 0).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    } else {
      return '\$${(price ?? 0).toStringAsFixed(2)}';
    }
  }
}
