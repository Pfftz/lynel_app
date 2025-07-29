import 'package:flutter/material.dart';

class FirebaseImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String fallbackAsset;

  const FirebaseImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackAsset = 'assets/images/sample_batik.jpg',
  });

  @override
  Widget build(BuildContext context) {
    // Check if imageUrl is valid
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallbackImage();
    }

    String cleanUrl = imageUrl!.trim();
    
    // Handle Firebase Storage URLs
    if (cleanUrl.contains('firebase') || cleanUrl.contains('googleapis')) {
      return Image.network(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingWidget();
        },
        errorBuilder: (context, error, stackTrace) {
          print('Firebase image loading error: $error');
          print('Image URL: $cleanUrl');
          return _buildErrorWidget();
        },
      );
    }
    
    // For other URLs, try regular network image
    return Image.network(
      cleanUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingWidget();
      },
      errorBuilder: (context, error, stackTrace) {
        print('Network image loading error: $error');
        print('Image URL: $cleanUrl');
        return _buildFallbackImage();
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
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
            'Failed to load',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      fallbackAsset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(
            Icons.image,
            size: 32,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
