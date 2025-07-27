import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>>? cartItems;

  const CartPage({super.key, this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _cartItems = widget.cartItems ?? [];
  }

  double getCartTotal() {
    double total = 0;
    for (var item in _cartItems) {
      dynamic price = item['price'] ?? 0;
      int qty = (item['qty'] ?? 0).toInt();
      total +=
          (price is String ? double.tryParse(price) ?? 0 : price.toDouble()) *
              qty;
    }
    return total;
  }

  void removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void updateQuantity(int index, int newQty) {
    if (newQty <= 0) {
      removeItem(index);
    } else {
      setState(() {
        _cartItems[index]['qty'] = newQty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                var item = _cartItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text(
                    'Rp ${item['price']} x ${item['qty']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeItem(index),
                  ),
                );
              },
            ),
          ),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: Rp ${getCartTotal().toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/checkout');
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
