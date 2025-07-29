# Lynel App - Indonesian Batik E-Commerce

A modern Flutter-based e-commerce application showcasing authentic Indonesian batik products. Built with Firebase backend integration, this app provides a seamless shopping experience for traditional batik clothing and accessories.

## 🎯 Overview

Lynel App is a comprehensive mobile e-commerce platform dedicated to promoting Indonesian cultural heritage through traditional batik products. The application features a beautiful Nusantara-inspired design with earth-tone colors and provides users with an intuitive shopping experience for authentic batik items.

## ✨ Features

### 🛍️ E-Commerce Core

-   **Product Catalog**: Browse extensive collection of batik products
-   **Product Details**: Detailed product information with high-quality images
-   **Shopping Cart**: Add, remove, and manage items with quantity controls
-   **Checkout Process**: Streamlined purchase flow with payment confirmation
-   **Category Filtering**: Filter products by type, origin, and pattern

### 🔐 User Authentication

-   **Firebase Authentication**: Secure user registration and login
-   **Profile Management**: User account management and preferences
-   **Session Management**: Persistent login sessions

### 👨‍💼 Admin Panel

-   **Product Management**: Add, edit, and remove products
-   **Inventory Control**: Manage stock levels and product availability
-   **Order Management**: Track and manage customer orders

### 🎨 Design & UX

-   **Nusantara Theme**: Traditional Indonesian color palette
-   **Responsive Design**: Optimized for various screen sizes
-   **Material Design**: Modern UI following Material Design principles
-   **Custom Typography**: Google Fonts integration for enhanced readability

### 🔧 Technical Features

-   **Firebase Integration**: Real-time database and cloud storage
-   **Image Optimization**: Smart image URL handling and caching
-   **State Management**: Efficient app state management
-   **Cross-Platform**: iOS and Android compatibility

## 🛠️ Tech Stack

### Frontend

-   **Flutter**: ^3.8.1 - Cross-platform mobile development framework
-   **Dart**: Programming language for Flutter development

### Backend & Services

-   **Firebase Core**: ^3.15.2 - Firebase SDK initialization
-   **Firebase Auth**: ^5.7.0 - User authentication
-   **Cloud Firestore**: ^5.6.12 - NoSQL database
-   **Firebase Storage**: ^12.4.10 - File storage and management

### UI/UX

-   **Google Fonts**: ^6.1.0 - Typography enhancement
-   **Cupertino Icons**: ^1.0.8 - iOS-style icons
-   **Material Design**: Built-in Flutter design system

### Utilities

-   **HTTP**: ^1.1.0 - Network requests
-   **Shared Preferences**: ^2.2.2 - Local data persistence

## 🚀 Getting Started

### Prerequisites

-   Flutter SDK (^3.8.1)
-   Dart SDK
-   Android Studio / VS Code
-   Firebase project setup
-   Android/iOS development environment

### Installation

1. **Clone the repository**

    ```bash
    git clone https://github.com/Pfftz/watra_nusa.git
    cd watra_nusa
    ```

2. **Install dependencies**

    ```bash
    flutter pub get
    ```

3. **Firebase Setup**

    - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
    - Enable Authentication, Firestore, and Storage
    - Download `google-services.json` for Android and place in `android/app/`
    - Download `GoogleService-Info.plist` for iOS and place in `ios/Runner/`
    - Configure Firebase options in `lib/firebase_options.dart`

4. **Run the application**
    ```bash
    flutter run
    ```

### Firebase Configuration

The app requires the following Firebase services:

-   **Authentication**: Email/password authentication
-   **Firestore Database**: Product and user data storage
-   **Firebase Storage**: Product image storage

Ensure your Firebase security rules are properly configured for production use.

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── pages/                    # Application screens
│   ├── home_page.dart       # Main product showcase
│   ├── login_page.dart      # User authentication
│   ├── register_page.dart   # User registration
│   ├── product_list_page.dart # Product catalog
│   ├── detail_produk_page.dart # Product details
│   ├── cart_page.dart       # Shopping cart
│   ├── checkout_page.dart   # Checkout process
│   ├── konfirmasi_pembayaran_page.dart # Payment confirmation
│   ├── admin_panel_page.dart # Admin dashboard
│   ├── image_debug_page.dart # Image testing utility
│   └── theme.dart           # App theme configuration
├── services/                # Business logic
│   ├── auth_service.dart    # Authentication service
│   ├── product_service.dart # Product management
│   ├── cart_service.dart    # Shopping cart logic
│   └── database_seeder.dart # Initial data population
├── utils/                   # Utility functions
│   └── image_url_helper.dart # Image URL processing
└── widgets/                 # Reusable components
    └── cart_icon.dart       # Shopping cart icon widget
```

## 🎨 Design System

The app follows a Nusantara-inspired design with the following color palette:

-   **Primary**: Earth Brown (`#8B4513`) - Traditional earth tones
-   **Secondary**: Golden Amber (`#D4A574`) - Warm accents
-   **Background**: Nusantara Beige (`#FDF7F0`) - Soft, warm background
-   **Surface**: Warm Cream (`#FAF0E6`) - Card and surface colors
-   **Accent**: Batik Indigo (`#2E4A62`) - Traditional batik blues

## 🔧 Configuration

### Environment Setup

1. Ensure Flutter is properly installed and configured
2. Set up Firebase project with required services
3. Configure platform-specific settings for Android and iOS

### Firebase Rules

Configure Firestore security rules for proper data access control:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Products collection - read access for all, write for admin only
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null &&
        resource.data.adminEmail == request.auth.token.email;
    }

    // User data - authenticated users only
    match /users/{userId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == userId;
    }
  }
}
```

## 🚀 Deployment

### Android

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

-   Indonesian batik artisans and cultural heritage
-   Flutter and Firebase teams for excellent development tools
-   Traditional Nusantara design inspiration
-   Open source community contributions

## 📞 Support

For support and questions:

-   Create an issue in the GitHub repository
-   Contact: [Your Contact Information]

---

**Lynel App** - Preserving Indonesian Heritage Through Digital Innovation 🇮🇩
