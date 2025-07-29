# WastraNusa - Traditional Indonesian Batik E-Commerce App 🇮🇩

A comprehensive Flutter e-commerce application specializing in traditional Indonesian batik products. Built with Firebase backend, featuring user authentication, product management, shopping cart, and a beautiful Nusantara-inspired design.

![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)

## 🌟 Features

### 🛍️ Customer Features
- **User Authentication** - Secure login/register with Firebase Auth
- **Product Browsing** - Browse batik products by categories (Kemeja, Kain, Outer, Dress)
- **Product Details** - Detailed product information with image gallery
- **Shopping Cart** - Add/remove items with persistent storage
- **Search & Filter** - Search products and filter by categories
- **Order Management** - Place orders and track purchase history
- **Responsive Design** - Works on mobile, tablet, and desktop

### 👨‍💼 Admin Features
- **Product Management** - Add, edit, delete products
- **Image Upload** - Support for multiple image hosting services
- **Inventory Control** - Stock management and product status
- **Sample Data** - Populate with sample batik products
- **Admin Dashboard** - Comprehensive product management interface

### 🎨 Design Features
- **Nusantara Theme** - Authentic Indonesian color palette
- **Cultural Branding** - Traditional batik-inspired UI elements
- **Modern UX** - Clean, intuitive user interface
- **Accessibility** - Readable fonts and proper color contrast
- **Multi-platform** - Android, iOS, Web, Windows, macOS, Linux

## 🛠️ Technology Stack

### Frontend
- **Flutter 3.8.1** - Cross-platform UI toolkit
- **Dart 3.8.1** - Programming language
- **Material Design 3** - Google's design system
- **Google Fonts** - Custom typography (DM Serif Display, Poppins)

### Backend & Services
- **Firebase Core** - Backend infrastructure
- **Firebase Auth** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - File storage
- **Shared Preferences** - Local data persistence

### Additional Libraries
- **HTTP** - Network requests
- **Image URL Helper** - Smart image URL conversion
- **Custom Cart Service** - Shopping cart management

## 🏗️ Project Architecture

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase configuration
├── pages/                       # UI screens
│   ├── theme.dart              # Nusantara theme definition
│   ├── login_page.dart         # Authentication screen
│   ├── home_page.dart          # Main landing page
│   ├── product_list_page.dart  # Product catalog
│   ├── detail_produk_page.dart # Product details
│   ├── cart_page.dart          # Shopping cart
│   ├── checkout_page.dart      # Order checkout
│   └── admin_panel_page.dart   # Admin dashboard
├── services/                    # Business logic
│   ├── auth_service.dart       # Authentication service
│   ├── cart_service.dart       # Cart management
│   ├── product_service.dart    # Product operations
│   └── database_seeder.dart    # Sample data seeding
├── utils/                       # Helper utilities
│   └── image_url_helper.dart   # Image URL conversion
├── widgets/                     # Reusable components
└── models/                      # Data models
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Firebase project setup
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Pfftz/lynel_app.git
   cd lynel_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Storage
   - Download configuration files:
     - `google-services.json` for Android (place in `android/app/`)
     - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
   - Update `lib/firebase_options.dart` with your project configuration

4. **Configure Firebase Authentication**
   - Enable Email/Password authentication
   - Optionally enable Google Sign-In
   - Set up security rules for Firestore

5. **Run the application**
   ```bash
   flutter run
   ```

### Firebase Configuration

#### 1. Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Products collection - read for all, write for admin only
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Users collection - users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Orders collection - users can read/write their own orders
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

#### 2. Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## 🎨 Building the Nusantara Theme from Zero

### Step 1: Color Palette Design
The authentic Indonesian color scheme was carefully crafted:

```dart
// Traditional Indonesian colors
const Color nusantaraBeige = Color(0xFFFDF7F0);  // Warm rice paper
const Color earthBrown = Color(0xFF8B4513);      // Traditional earth
const Color goldenAmber = Color(0xFFD4A574);     // Golden spices
const Color deepTeak = Color(0xFF654321);        // Teak wood
const Color batikIndigo = Color(0xFF2E4A62);     // Batik indigo dye
```

### Step 2: Typography Selection
```dart
// Google Fonts selection for cultural authenticity
textTheme: GoogleFonts.dmSerifDisplayTextTheme().copyWith(
  bodyLarge: GoogleFonts.poppins(),
  bodyMedium: GoogleFonts.poppins(),
  bodySmall: GoogleFonts.poppins(),
)
```

### Step 3: Component Theming
Every Material Design component was customized to reflect Indonesian aesthetics:
- Warm, earthy button colors
- Traditional gradient backgrounds
- Cultural iconography integration
- Accessible contrast ratios

## 🛒 Implementing the Shopping Cart System

### Step 1: Cart Service Architecture
```dart
class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final ValueNotifier<List<CartItem>> _cartItems = ValueNotifier([]);
  ValueNotifier<List<CartItem>> get cartItems => _cartItems;
}
```

### Step 2: Persistent Storage
```dart
Future<void> _saveCart() async {
  final prefs = await SharedPreferences.getInstance();
  final cartJson = _cartItems.value.map((item) => item.toJson()).toList();
  await prefs.setString('cart_items', jsonEncode(cartJson));
}
```

### Step 3: Real-time Updates
The cart system uses `ValueNotifier` for reactive updates across the app, ensuring the UI stays synchronized with cart state changes.

## 🔐 Authentication System Implementation

### Step 1: Firebase Auth Setup
```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  bool get isAdmin => currentUser?.email == 'admin@wastranusa.com';
}
```

### Step 2: Login Flow
1. User enters credentials
2. Firebase authentication validates
3. User session persists automatically
4. Admin privileges checked for dashboard access

### Step 3: Security Implementation
- Email verification for new accounts
- Password strength requirements
- Admin role-based access control
- Secure password reset functionality

## 🏪 Product Management System

### Step 1: Data Structure
```dart
// Product model with comprehensive fields
{
  'name': String,
  'description': String,
  'price': double,
  'currency': String,
  'category': String,
  'imageUrl': String,
  'stock': int,
  'featured': bool,
  'colors': List<String>,
  'sizes': List<String>,
  'material': String,
  'origin': String,
  'pattern': String,
  'tags': List<String>,
  'createdAt': Timestamp,
  'updatedAt': Timestamp,
}
```

### Step 2: Image Handling
Smart image URL conversion system supporting:
- Imgur URLs (album and direct)
- Firebase Storage URLs  
- Unsplash URLs
- Custom image hosting services

```dart
class ImageUrlHelper {
  static String? getDirectImageUrl(String? url) {
    // Convert various URL formats to direct image URLs
    if (url?.contains('imgur.com') == true) {
      return _convertImgurUrl(url!);
    }
    return url;
  }
}
```

### Step 3: Admin Interface
Comprehensive product management with:
- CRUD operations
- Real-time preview
- Bulk data seeding
- Image validation
- Stock management

## 📊 Database Architecture

### Collections Structure

#### Products Collection
```
products/
├── {productId}/
    ├── name: string
    ├── description: string
    ├── price: number
    ├── currency: string
    ├── category: string
    ├── imageUrl: string
    ├── stock: number
    ├── featured: boolean
    ├── colors: array
    ├── sizes: array
    ├── material: string
    ├── origin: string
    ├── pattern: string
    ├── tags: array
    ├── createdAt: timestamp
    └── updatedAt: timestamp
```

#### Users Collection
```
users/
├── {userId}/
    ├── email: string
    ├── name: string
    ├── isAdmin: boolean
    ├── createdAt: timestamp
    └── lastLogin: timestamp
```

#### Orders Collection
```
orders/
├── {orderId}/
    ├── userId: string
    ├── items: array
    ├── totalAmount: number
    ├── currency: string
    ├── status: string
    ├── shippingAddress: object
    ├── paymentMethod: string
    ├── createdAt: timestamp
    └── updatedAt: timestamp
```

## 🔧 Development Process

### Phase 1: Project Setup (Week 1)
1. **Flutter Project Initialization**
   ```bash
   flutter create lynel_app
   cd lynel_app
   ```

2. **Dependencies Installation**
   - Firebase integration
   - UI/UX libraries
   - State management
   - Local storage

3. **Project Structure Organization**
   - Folder architecture setup
   - Import organization
   - Asset management

### Phase 2: Authentication System (Week 2)
1. **Firebase Auth Setup**
   - Project configuration
   - Security rules implementation
   - Email/password authentication

2. **UI Implementation**
   - Login page design
   - Registration flow
   - Password reset functionality
   - Admin role management

### Phase 3: Core Features (Week 3-4)
1. **Product Catalog**
   - Database schema design
   - Product list UI
   - Search and filtering
   - Category navigation

2. **Product Details**
   - Detailed product view
   - Image gallery
   - Add to cart functionality
   - Stock validation

### Phase 4: Shopping Cart (Week 5)
1. **Cart Service Implementation**
   - Singleton pattern
   - Local persistence
   - State management
   - Real-time updates

2. **Cart UI Development**
   - Modern card-based design
   - Quantity management
   - Price calculations
   - Empty state handling

### Phase 5: Admin Panel (Week 6)
1. **Product Management**
   - CRUD operations
   - Image upload handling
   - Bulk operations
   - Data validation

2. **Dashboard Implementation**
   - Admin authentication
   - Sample data seeding
   - Product statistics
   - User management

### Phase 6: Design System (Week 7)
1. **Nusantara Theme Creation**
   - Color palette research
   - Typography selection
   - Component styling
   - Cultural authenticity

2. **UI/UX Polish**
   - Accessibility improvements
   - Animation integration
   - Responsive design
   - Cross-platform testing

### Phase 7: Testing & Deployment (Week 8)
1. **Quality Assurance**
   - Unit testing
   - Integration testing
   - User acceptance testing
   - Performance optimization

2. **Deployment Preparation**
   - Build configuration
   - Store preparation
   - Documentation
   - Release planning

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Test Structure
```
test/
├── unit/
│   ├── services/
│   ├── utils/
│   └── models/
├── widget/
│   ├── pages/
│   └── components/
└── integration/
    ├── auth_flow_test.dart
    ├── cart_flow_test.dart
    └── admin_flow_test.dart
```

## 📱 Platform Support

| Platform | Status | Features |
|----------|--------|----------|
| Android | ✅ Full Support | All features including payments |
| iOS | ✅ Full Support | All features including payments |
| Web | ✅ Full Support | All features except payments |
| Windows | ✅ Beta | Basic features |
| macOS | ✅ Beta | Basic features |
| Linux | ✅ Beta | Basic features |

## 🌍 Internationalization

The app supports multiple languages and regions:
- **Indonesian (ID)** - Primary language
- **English (EN)** - International support
- **Javanese (JV)** - Regional support

## 🔐 Security Features

- **Data Encryption** - All sensitive data encrypted
- **Secure Authentication** - Firebase Auth with security rules
- **Input Validation** - Comprehensive form validation
- **XSS Protection** - Cross-site scripting prevention
- **Admin Role Security** - Restricted admin access
- **API Rate Limiting** - DDoS protection

## 📈 Performance Optimization

- **Image Optimization** - Smart image loading and caching
- **Lazy Loading** - On-demand content loading
- **State Management** - Efficient state updates
- **Database Indexing** - Optimized Firestore queries
- **Code Splitting** - Modular architecture
- **Memory Management** - Proper resource disposal

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Dart/Flutter style guide
- Write comprehensive tests
- Update documentation
- Maintain cultural authenticity
- Ensure accessibility compliance

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Indonesian Batik Artists** - For cultural inspiration
- **Flutter Team** - For the amazing framework
- **Firebase Team** - For robust backend services
- **Google Fonts** - For beautiful typography
- **Unsplash** - For high-quality product images
- **Indonesian Ministry of Culture** - For batik pattern references


**Built with ❤️ for Indonesian Batik Culture**

*Preserving tradition through modern technology*
