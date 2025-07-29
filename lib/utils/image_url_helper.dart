class ImageUrlHelper {
  /// Converts various image URL formats to direct image URLs that can be loaded by Flutter
  static String? getDirectImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }

    final cleanUrl = url.trim();

    // Handle Imgur URLs
    if (cleanUrl.contains('imgur.com')) {
      return _convertImgurUrl(cleanUrl);
    }

    // Handle Firebase Storage URLs
    if (cleanUrl.contains('firebasestorage.googleapis.com') || 
        cleanUrl.contains('googleapis.com')) {
      return cleanUrl;
    }

    // For other URLs, return as-is
    return cleanUrl;
  }

  /// Converts Imgur album/gallery URLs to direct image URLs
  static String _convertImgurUrl(String url) {
    try {
      // Handle different Imgur URL formats:
      // https://imgur.com/a/zE52Ogp#Lc0lrJH -> https://i.imgur.com/Lc0lrJH.jpg
      // https://imgur.com/a/albumId -> First image from album (not directly convertible)
      // https://imgur.com/imageId -> https://i.imgur.com/imageId.jpg
      
      // Extract hash fragment (image ID after #)
      if (url.contains('#')) {
        final parts = url.split('#');
        if (parts.length > 1) {
          final imageId = parts[1];
          return 'https://i.imgur.com/$imageId.jpg';
        }
      }

      // Extract direct image ID from single image URL
      final uri = Uri.parse(url);
      if (uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last;
        
        // Skip album URLs (they start with 'a/')
        if (uri.path.contains('/a/')) {
          // For album URLs without hash, we can't get direct image
          // Return a placeholder or the original URL
          return url;
        }
        
        // Single image URL
        if (!lastSegment.contains('.')) {
          return 'https://i.imgur.com/$lastSegment.jpg';
        }
      }

      return url;
    } catch (e) {
      print('Error converting Imgur URL: $e');
      return url;
    }
  }

  /// Validates if a URL is likely to be a working image URL
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    final cleanUrl = url.trim().toLowerCase();
    
    // Check for common image extensions
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final hasImageExtension = imageExtensions.any((ext) => cleanUrl.contains(ext));
    
    // Check for known image hosting domains
    final knownDomains = [
      'i.imgur.com',
      'firebasestorage.googleapis.com',
      'storage.googleapis.com',
      'images.unsplash.com',
      'via.placeholder.com'
    ];
    final hasKnownDomain = knownDomains.any((domain) => cleanUrl.contains(domain));
    
    return hasImageExtension || hasKnownDomain;
  }
}
