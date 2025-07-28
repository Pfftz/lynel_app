import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CartIcon extends StatefulWidget {
  final VoidCallback? onTap;
  final Color? iconColor;

  const CartIcon({
    super.key,
    this.onTap,
    this.iconColor,
  });

  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  final CartService _cartService = CartService.instance;
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  Future<void> _loadCartCount() async {
    await _cartService.loadCart();
    if (mounted) {
      setState(() {
        _itemCount = _cartService.itemCount;
      });
    }
  }

  void _updateCartCount() {
    if (mounted) {
      setState(() {
        _itemCount = _cartService.itemCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _updateCartCount(); // Update count when tapped
        widget.onTap?.call();
      },
      child: Stack(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            color: widget.iconColor ?? Colors.grey[700],
          ),
          if (_itemCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  _itemCount > 99 ? '99+' : _itemCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
