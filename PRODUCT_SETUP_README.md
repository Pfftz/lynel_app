# Product Setup Instructions

## Adding Products to Firestore (Manual Method)

Since you already have Firebase set up, follow these steps to add sample products:

### Step 1: Access Firestore Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: `my-flutter-shop-lynel`
3. Click on "Firestore Database" in the left sidebar
4. If prompted, choose "Start in test mode" for now

### Step 2: Create Products Collection

1. Click "Start collection" or the "+" button
2. Enter collection ID: `products`
3. Click "Next"

### Step 3: Add Sample Products

Add these products one by one:

#### Product 1: Wireless Headphones

-   **Document ID**: Leave auto-generated or use `product_1`
-   **Fields**:
    -   `name` (string): `Wireless Headphones`
    -   `description` (string): `High-quality wireless headphones with noise cancellation`
    -   `price` (number): `89.99`
    -   `imageUrl` (string): `https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop`

#### Product 2: Smartphone

-   **Document ID**: Leave auto-generated or use `product_2`
-   **Fields**:
    -   `name` (string): `Smartphone`
    -   `description` (string): `Latest model smartphone with advanced camera`
    -   `price` (number): `699.99`
    -   `imageUrl` (string): `https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop`

#### Product 3: Laptop

-   **Document ID**: Leave auto-generated or use `product_3`
-   **Fields**:
    -   `name` (string): `Laptop`
    -   `description` (string): `Powerful laptop for work and gaming`
    -   `price` (number): `1299.99`
    -   `imageUrl` (string): `https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop`

#### Product 4: Coffee Mug

-   **Document ID**: Leave auto-generated or use `product_4`
-   **Fields**:
    -   `name` (string): `Coffee Mug`
    -   `description` (string): `Ceramic coffee mug with elegant design`
    -   `price` (number): `19.99`
    -   `imageUrl` (string): `https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=400&fit=crop`

#### Product 5: Running Shoes

-   **Document ID**: Leave auto-generated or use `product_5`
-   **Fields**:
    -   `name` (string): `Running Shoes`
    -   `description` (string): `Comfortable running shoes for daily exercise`
    -   `price` (number): `129.99`
    -   `imageUrl` (string): `https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop`

### Step 4: Security Rules (Optional for Development)

If you encounter permission errors, temporarily update your Firestore rules:

1. Go to "Rules" tab in Firestore
2. Replace the rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

3. Click "Publish"

**Note**: This allows authenticated users to read/write all data. For production, implement more restrictive rules.

## Using Your Own Images

### Free Image Sources:

1. **Unsplash** (https://unsplash.com) - Professional photos
2. **Pixabay** (https://pixabay.com) - Free images and illustrations
3. **Pexels** (https://pexels.com) - High-quality stock photos

### Getting Direct Image URLs:

1. Find an image on any free image site
2. Right-click on the image
3. Select "Copy image address" or "Copy link address"
4. Use that URL in the `imageUrl` field

### Alternative: Using Firebase Storage (Advanced)

If you want to host your own images:

1. Upload images to Firebase Storage
2. Get the download URL
3. Use that URL in your products

## Testing the App

After adding products:

1. Run your Flutter app: `flutter run`
2. Sign up for a new account or log in
3. Navigate to the home screen to see featured products
4. Tap "Products" or "View All" to see the full products list
5. Images should load automatically from the URLs you provided

## Troubleshooting

### Products Not Showing:

-   Check Firestore rules allow read access for authenticated users
-   Verify collection name is exactly `products`
-   Check that field names match exactly: `name`, `description`, `price`, `imageUrl`

### Images Not Loading:

-   Verify the image URLs are direct links (end with .jpg, .png, etc.)
-   Test the URLs in a browser to ensure they work
-   Some sites may block hotlinking - use Unsplash URLs provided above

### Authentication Issues:

-   Ensure Email/Password is enabled in Firebase Auth
-   Check that firebase_options.dart has correct configuration
-   Verify google-services.json is in the correct location
