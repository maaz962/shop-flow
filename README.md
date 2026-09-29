# 🛍️ ShopFlow

### Multi-Vendor E-Commerce Mobile Application built with Flutter & Firebase

ShopFlow is a Flutter-based multi-vendor e-commerce application with separate experiences for **Customers, Sellers, and Administrators**.

The application uses **GetX** for state management and **Firebase** for authentication, database, and notifications, with **Stripe** integrated for payments.

---

## ✨ Features

### 👤 Customer

* User registration, login and logout
* Browse products
* Product search
* Category-based filtering
* Product details
* Shopping cart with quantity and stock validation
* Checkout
* Stripe payment integration
* Order history
* Order status tracking
* Wishlist
* Product ratings and reviews
* Edit and delete personal reviews
* Profile and settings
* Light/Dark theme support
* Push/local notifications

### 🏪 Seller

* Seller dashboard
* Add products
* Edit products
* Delete products
* View own products
* Centralized category selection
* Seller order management
* Update order status
* Store profile
* Seller statistics
* Notifications
* Seller settings

### 🛡️ Admin

* Admin dashboard
* User management
* Enable/disable users
* Seller management
* Product management
* Edit/delete products
* Centralized category management
* Create, activate and deactivate categories
* Order management
* Update order status
* Dashboard statistics
* Revenue and order overview

---

## ⭐ Ratings & Reviews

Customers can:

* Give products a rating from 1–5 stars
* Write reviews
* Edit their own reviews
* Delete their own reviews
* View reviews from other customers

Product ratings are automatically recalculated when reviews are added, updated, or deleted.

Reviews are stored separately in Firestore.

---

## 🗂️ Centralized Category System

ShopFlow uses a centralized category system managed by the Admin.

```text
Admin
  │
  ├── Create / Manage Categories
  │
  ▼
Firestore
  │
  └── categories
        │
        ▼
Seller → Select Category → Product
        │
        ▼
Customer → Category Filter
```

Sellers cannot create arbitrary product categories. They select from the active categories managed by the Admin.

---

## 🛒 Cart & Orders

The cart system supports:

* Add/remove products
* Increase/decrease quantity
* Stock validation
* Subtotal calculation
* Item count

Orders contain:

* Customer
* Seller(s)
* Products
* Total amount
* Order status
* Payment status
* Delivery address
* Creation date

---

## 💳 Payments

ShopFlow uses **Stripe** for payment processing.

The application includes:

* Payment Sheet integration
* Payment Intent creation
* Checkout payment flow
* Payment status tracking

> **Production note:** Stripe secret credentials should be handled through a secure backend/server environment rather than directly inside the mobile application.

---

## 🔔 Notifications

ShopFlow uses Firebase Cloud Messaging for notification functionality.

Notifications are designed for events such as:

* New orders
* Order status updates
* Seller/customer notifications

FCM tokens are associated with users through Firestore.

---

## 🔥 Firebase

The project currently uses Firebase services including:

* Firebase Authentication
* Cloud Firestore
* Firebase Cloud Messaging

Main Firestore collections include:

```text
users
products
categories
orders
reviews
```

---

## 🏗️ Architecture

ShopFlow follows a structured Flutter architecture:

```text
lib/
├── app/
│   ├── routes/
│   ├── theme/
│   └── utils/
│
├── controllers/
├── models/
├── services/
├── views/
│   ├── admin/
│   ├── seller/
│   └── customer/
│
└── main.dart
```

### State Management

The application uses **GetX** for:

* State management
* Dependency injection
* Navigation
* Controllers

Examples:

```text
AuthController
FirestoreProductController
CartController
OrderController
CategoryController
ReviewController
PaymentController
AdminController
StoreProfileController
ThemeController
```

---

## 🛠️ Technology Stack

| Technology               | Purpose                       |
| ------------------------ | ----------------------------- |
| Flutter                  | Mobile application            |
| Dart                     | Programming language          |
| GetX                     | State management & navigation |
| Firebase Auth            | Authentication                |
| Cloud Firestore          | Database                      |
| Firebase Cloud Messaging | Notifications                 |
| Stripe                   | Payments                      |
| Android                  | Mobile platform               |

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/maaz962/shop-flow.git
cd shop-flow
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Add your Firebase configuration for the required platforms.

### 4. Configure Stripe

Configure the Stripe environment according to the project's payment setup.

### 5. Run the application

```bash
flutter run
```

---

## 🔐 Security

Firestore rules provide role-based access for major application resources.

The application distinguishes between:

```text
Customer
Seller
Admin
```

Admin-only operations include category management and administrative product/order/user management.

For production deployment, sensitive payment and notification credentials should be moved to a secure backend environment.

---

## 📌 Current Project Status

### Implemented

* [x] Customer authentication
* [x] Product browsing
* [x] Search & categories
* [x] Cart
* [x] Checkout
* [x] Stripe payment integration
* [x] Orders
* [x] Wishlist
* [x] Ratings & reviews
* [x] Seller dashboard
* [x] Seller product management
* [x] Seller order management
* [x] Store profile
* [x] Admin dashboard
* [x] User management
* [x] Seller management
* [x] Product management
* [x] Category management
* [x] Order management
* [x] Notifications
* [x] Firebase integration

---

## 🔮 Future Improvements

Some areas planned for further production-level improvement include:

* Secure backend payment verification
* Server-side order and stock validation
* Improved notification backend
* Advanced admin analytics
* Product image upload optimization
* Pagination and performance improvements
* Automated testing
* Production security hardening

---

## 👨‍💻 Developer

**Muhammad Maaz**

Flutter Developer | Firebase | Full-Stack Development

GitHub:
https://github.com/maaz962

---

## 📄 License

This project is developed for learning, development, and portfolio purposes.
