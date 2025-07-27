import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutPage({super.key, required this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _alamatController = TextEditingController();
  String selectedKurir = 'JNE';
  String selectedPayment = 'Transfer Bank';

  double getTotal() {
    double total = 0;
    for (var item in widget.cartItems) {
      dynamic price = item['price'] ?? 0;
      int qty = (item['qty'] ?? 0).toInt();
      total +=
          (price is String ? double.tryParse(price) ?? 0 : price.toDouble()) *
              qty;
    }
    return total;
  }

  double getShippingCost() {
    switch (selectedKurir) {
      case 'JNE':
        return 15000;
      case 'J&T':
        return 12000;
      case 'SiCepat':
        return 10000;
      default:
        return 15000;
    }
  }

  double getGrandTotal() {
    return getTotal() + getShippingCost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Alamat Pengiriman:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Jl. Soekarno Hatta No.99, Bandung',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            const Text('Pilih Kurir:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedKurir,
              isExpanded: true,
              items: ['JNE', 'SiCepat', 'J&T']
                  .map((kurir) =>
                      DropdownMenuItem(value: kurir, child: Text(kurir)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedKurir = val!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Ringkasan Pesanan:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...widget.cartItems.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item['name']),
                  subtitle: Text('${item['qty']} barang x Rp ${item['price']}'),
                  trailing: Text('Rp ${item['price'] * item['qty']}'),
                )),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Rp ${getTotal()}',
                    style: const TextStyle(fontSize: 16, color: Colors.brown)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (_alamatController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Alamat tidak boleh kosong')),
                    );
                    return;
                  }
                  // Lanjut ke halaman konfirmasi
                  Navigator.pushNamed(context, '/konfirmasi');
                },
                child: const Text('Bayar Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
