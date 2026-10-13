# ShopEase

A Flutter e-commerce app built for the Week 3 internship task at DawoodTech
NextGen: **ShopEase - E-Commerce App with BLoC & Online Payments**.

**Live Demo:**  https://noorfatima-0319.github.io/Shopease/
**GitHub Repository:** https://github.com/noorfatima-0319/Shopease
**Release APK:** <add a link to your GitHub Release / Firebase App Distribution build here>

## Overview

ShopEase is a product catalogue and shopping app: browse products by
category, search and sort, view product detail with real reviews, manage a
cart and wishlist that survive app restarts, and complete a checkout with a
delivery address and a working Cash on Delivery payment flow.

## Features

- Home with a promo banner, category chips, a featured products row and a
  new arrivals grid
- Product list with live search, category filter, sort (price, rating),
  and a filter sheet for price range and minimum rating
- Product detail with a swipeable image carousel, real product reviews
  pulled from the API, stock status, quantity selector and an
  add-to-cart button with a confirmation animation
- Cart and wishlist, both persisted locally with Hive so they survive an
  app restart
- Checkout with a validated delivery address form and Cash on Delivery
  payment
- Order history with a visual status timeline (Placed, Processing, Shipped,
  Delivered)
- Privacy Policy and Terms and Conditions screens, linked from checkout
- Shimmer loading placeholders while data loads, and cached network images
  so previously-loaded pictures don't re-download on every scroll
- Hero animation from the product image on tap through to its detail page
- Light and dark theme

## A note on payments

The task allows either a Stripe PaymentSheet checkout or Cash on Delivery.
A real Stripe PaymentSheet needs a PaymentIntent created by a server that
holds the Stripe secret key; the secret key must never be embedded in the
app itself. This build implements the **Cash on Delivery** path fully and
working end to end, and includes the UI entry point for Card payment,
disabled with an explanatory note, as the natural place a server-backed
Stripe integration would plug in later.

## Architecture

The app follows a layered, clean-architecture style structure:

```
lib/
├── main.dart
├── core/                 # theme, constants, network client, shared widgets
├── data/
│   ├── models/           # ProductModel, CartItemModel, OrderModel, etc.
│   ├── datasources/      # ProductRemoteDataSource (Dio), *LocalDataSource (Hive)
│   └── repositories/     # concrete implementations of the domain interfaces
├── domain/
│   └── repositories/     # abstract repository interfaces
├── presentation/
│   ├── home/              # HomeCubit + HomeScreen
│   ├── product_list/      # ProductListCubit + ProductListScreen
│   ├── product_detail/    # ProductDetailCubit + ProductDetailScreen
│   ├── cart/               # CartCubit + CartScreen
│   ├── wishlist/           # WishlistCubit + WishlistScreen
│   ├── checkout/           # CheckoutCubit + CheckoutScreen + OrderConfirmationScreen
│   ├── orders/              # OrdersCubit + OrdersScreen
│   ├── legal/               # PrivacyPolicyScreen, TermsScreen
│   └── splash/
├── injection/             # get_it dependency injection setup
└── routes/                # go_router named routes
```

Widgets only read Cubit state and dispatch Cubit method calls; filtering,
sorting, cart totals and order logic all live in the Cubits and
repositories, not in the widget tree.

## State management

Each feature has its own `Cubit` (from `flutter_bloc`), with an immutable
state class and a `copyWith` method. Screens use `BlocProvider` to create
a Cubit scoped to that screen, and `BlocBuilder` to rebuild only the parts
of the UI that depend on that state.

## Technologies Used

- Flutter & Dart
- `flutter_bloc` - Cubit-based state management
- `get_it` - dependency injection
- `dio` - HTTP client for the product API ([DummyJSON](https://dummyjson.com))
- `hive` / `hive_flutter` - local persistence for cart, wishlist, orders and address
- `go_router` - named routes and navigation
- `shimmer` - loading placeholders
- `cached_network_image` - cached, smooth-scrolling product images
- `google_fonts` - typography

## Data source

Product data comes from the public [DummyJSON](https://dummyjson.com) API,
including real product reviews returned by that API. No review, rating or
customer count in this app is fabricated.

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/noorfatima-0319/Shopease.git
   cd shopease
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Building a release APK

```bash
flutter build apk --release
```
The APK is produced at `build/app/outputs/flutter-apk/app-release.apk`.
Upload it as a GitHub Release asset (or Firebase App Distribution) so it
can be downloaded and installed directly.


## What is intentionally out of scope for this build

- Live Stripe PaymentSheet checkout (needs a deployed server; see the note
  above)
- Coupon codes and shareable product deep links (listed as bonus features
  in the task)

## Author

**Noor Fatima**
BS Information Technology, Government College University Faisalabad
