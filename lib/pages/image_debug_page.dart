import 'package:flutter/material.dart';
import '../utils/image_url_helper.dart';

class ImageDebugPage extends StatelessWidget {
  const ImageDebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Test your actual Imgur URLs
    final testUrls = [
      'https://imgur.com/a/zE52Ogp#Lc0lrJH',
      'https://imgur.com/a/zE52Ogp#ZDVsWPB',
      'https://imgur.com/a/zE52Ogp#7chuiYR',
      'https://imgur.com/a/wastranusa-GZUZH35#mwGqqXS',
      'https://via.placeholder.com/300', // Test URL that should work
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Debug'),
      ),
      body: ListView.builder(
        itemCount: testUrls.length,
        itemBuilder: (context, index) {
          final originalUrl = testUrls[index];
          final convertedUrl = ImageUrlHelper.getDirectImageUrl(originalUrl);
          
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Test ${index + 1}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Original: $originalUrl', style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('Converted: $convertedUrl', style: const TextStyle(fontSize: 12, color: Colors.blue)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: convertedUrl != null ? Image.network(
                      convertedUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.red[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              Text('Error: $error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        );
                      },
                    ) : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Text('No URL to load'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
