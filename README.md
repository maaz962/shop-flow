# 🛒 ShopFlow

**ShopFlow** is a modern e-commerce application built with **Flutter and Firebase**, designed with a scalable **MVC architecture** and **GetX** for state management.

The project supports both **customer and seller workflows**, with an admin panel currently under development. The goal is to build a complete, production-style e-commerce platform while following clean project structure, reusable components, and real-world development practices.

---

## 🚀 Features

### 👤 Authentication & User Roles

* User registration and login
* Firebase Authentication
* Role-based navigation
* Customer and Seller roles
* Admin role support
* Automatic navigation according to user role
* User profile information stored in Firestore

### 🛍️ Customer Features

* Browse products
* Product details
* Product categories
* Product search
* Product ratings
* Product discounts
* Stock information
* Add products to cart
* Update cart quantities
* Stock validation
* Wishlist
* Checkout
* Order placement
* View personal orders
* Order information and status

### 🏪 Seller Features

* Seller dashboard
* View seller's own products
* Add products
* Edit products
* Delete products
* Product ownership using Firebase Authentication UID
* Seller-specific product management
* Store profile section
* Seller order management *(in development)*

### 👑 Admin Panel

The Admin Panel is currently being developed.

Implemented/planned modules include:

* Admin authentication
* Admin dashboard
* Total users
* Total sellers
* Total products
* Total orders
* Revenue statistics
* User management
* Seller management
* Product management

---

## 🔥 Firebase Integration

ShopFlow uses Firebase as its backend.

### Firebase Services

* **Firebase Authentication** — user authentication and role-based access
* **Cloud Firestore** — users, products and orders
* **Firebase Storage** — product media *(planned/ongoing)*
* **Firebase Cloud Messaging (FCM)** — push notifications *(currently being integrated)*

### Notification Flow

The planned notification system follows this workflow:

```text
Customer places order
        ↓
Seller receives notification
        ↓
Seller updates order status
        ↓
Customer receives notification
```

---

## 🏗️ Architecture

ShopFlow follows an **MVC architecture with GetX**.

```text
lib/
│
├── app/
│   ├── bindings/
│   ├── routes/
│   ├── theme/
│   └── utils/
│
├── controllers/
│   ├── auth_controller.dart
│   ├── cart_controller.dart
│   ├── firestore_product_controller.dart
│   ├── order_controller.dart
│   ├── theme_controller.dart
│   ├── wishlist_controller.dart
│   ├── store_profile_controller.dart
│   └── admin_controller.dart
│
├── models/
│   ├── user_model.dart
│   ├── product_model.dart
│   └── order_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── order_service.dart
│   ├── storage_service.dart
│   └── user_service.dart
│
├── views/
│   ├── home/
│   ├── products/
│   ├── seller/
│   ├── cart/
│   ├── checkout/
│   ├── orders/
│   ├── profile/
│   ├── settings/
│   ├── welcome/
│   └── splash/
│
└── widgets/
    ├── auth_button_skeleton.dart
    ├── product_skeleton.dart
    └── product_card.dart
```

---

## 🧠 State Management

ShopFlow uses **GetX** for:

* Reactive state management
* Dependency injection
* Navigation
* Controllers
* Observable lists and variables

Example:

```dart
final products = <ProductModel>[].obs;
```

This allows the UI to react automatically whenever the product list changes.

---

## 📦 Product Model

Products contain information such as:

* Product ID
* Owner ID
* Title
* Description
* Price
* Discount percentage
* Rating
* Stock
* Brand
* Category
* Thumbnail
* Product images
* Reviews
* Firestore document ID

Each seller's products are associated with their Firebase Authentication UID, allowing seller-specific product management.

---

## 🛒 Cart & Orders

The cart system supports:

* Add to cart
* Remove from cart
* Increase/decrease quantity
* Stock validation
* Item count
* Subtotal calculation

Orders store information such as:

* Customer
* Products
* Quantities
* Total amount
* Order status
* Order date

---

## 🎨 UI & Reusable Components

ShopFlow uses reusable widgets to keep the UI consistent.

For example, the reusable `ProductCard` is designed to be shared across:

* Home
* Wishlist
* Search
* Category screens

The product card supports:

* Product image
* Discount badge
* Wishlist heart button
* Product title
* Price
* Rating
* Other product information

---

## 🔐 Security

Firebase Security Rules are being developed alongside the application.

The intended access model is:

```text
Customer
   ↓
Own profile + own orders

Seller
   ↓
Own products + seller-specific data

Admin
   ↓
Administrative management
```

The project is progressively moving toward stricter role-based Firestore access.

---

## 🛠️ Tech Stack

| Technology               | Purpose                                 |
| ------------------------ | --------------------------------------- |
| Flutter                  | Application development                 |
| Dart                     | Programming language                    |
| Firebase Auth            | Authentication                          |
| Cloud Firestore          | Database                                |
| Firebase Storage         | Media storage                           |
| Firebase Cloud Messaging | Push notifications                      |
| GetX                     | State management & dependency injection |
| MVC                      | Application architecture                |

---

## 📱 Screens

### Customer

* Splash Screen
* Welcome Screen
* Login
* Register
* Home
* Product Details
* Search
* Categories
* Wishlist
* Cart
* Checkout
* Orders
* Profile
* Settings

### Seller

* Seller Dashboard
* My Products
* Add Product
* Edit Product
* Seller Product Management
* Seller Orders *(in development)*
* Store Profile *(in development)*

### Admin

* Admin Dashboard
* Dashboard statistics
* User Management *(in development)*
* Seller Management *(in development)*
* Product Management *(in development)*

---

## 📌 Project Status

**ShopFlow is actively under development.**

### ✅ Completed

* Firebase project integration
* Firebase Authentication
* Role-based authentication flow
* Customer application flow
* Seller dashboard
* Product CRUD
* Seller-specific product filtering
* Product details
* Cart system
* Wishlist
* Checkout
* Order creation
* Order listing
* GetX state management
* MVC project structure
* Reusable Product Card
* Responsive UI improvements
* Initial Admin Panel development

### 🚧 In Progress

* Seller Order Management
* Admin Dashboard improvements
* Admin User Management
* Admin Seller Management
* Admin Product Management
* Firebase Cloud Messaging
* Push notification workflow
* Firebase Storage integration
* Advanced Firestore security rules

---

## 🔮 Future Improvements

* Product image/video uploads
* Complete seller store profiles
* Complete seller order management
* Complete admin panel
* Advanced search and filtering
* Payment gateway integration
* Push notifications
* Order tracking
* Product reviews
* Analytics
* Firebase App Check
* Crash reporting
* Production-ready security rules
* CI/CD

---

## ⚙️ Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/shopflow.git
```

### 2. Navigate to the project

```bash
cd shopflow
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Configure Firebase

Create a Firebase project and connect it with the Flutter application.

Configure:

* Firebase Authentication
* Cloud Firestore
* Firebase Storage
* Firebase Cloud Messaging

Add the required Firebase configuration files for your target platform.

### 5. Run the application

```bash
flutter run
```

---

## 📚 What I Am Learning Through ShopFlow

ShopFlow is not only an e-commerce project; it is also a practical project for learning real-world software development concepts.

Through this project, I am working with:

* Flutter development
* Dart
* MVC architecture
* GetX
* Firebase
* Firestore database design
* Authentication
* Role-based authorization
* CRUD operations
* State management
* Dependency injection
* Reusable widgets
* Responsive UI
* Push notifications
* Backend security
* Git & GitHub
* Real-world application architecture

---

## 👨‍💻 Author

**M. Maaz Arif**

BS Computer Science Student
Flutter & Full-Stack Developer in Progress

---

## ⭐ Project

If you find this project useful or interesting, consider giving the repository a ⭐.

ShopFlow is continuously evolving as I learn and implement more production-level Flutter and Firebase concepts.
