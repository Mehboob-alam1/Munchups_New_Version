# Provider State Management Migration Guide

This document outlines the migration of the Munchups Flutter app from traditional state management to the Provider pattern, and how it now fits into the upgraded Clean Architecture powered by GetIt (DI) and Dio (HTTP).

## 🚀 Executive Summary
- Migrated legacy `setState` + ad‑hoc API usage to a modern, scalable **Provider** approach
- Introduced **Clean Architecture** with clear separation of Presentation, Domain, and Data layers
- Added **GetIt** for dependency injection and **Dio** for robust networking
- Centralized session, cart, and data flows; removed direct UI coupling to storage/network
- Added comprehensive docs and examples to accelerate onboarding and future work

## Overview

The app has been migrated from using:
- Direct API calls in widgets
- `setState()` for local state
- Direct `SharedPreferences` access
- Manual state synchronization

To using:
- **Provider** for centralized state management
- **ChangeNotifier** for reactive state updates
- **Consumer** / `context.read` / `context.watch` for accessing state
- Centralized providers that delegate to Domain Use Cases and Repositories

## New Provider Architecture (Presentation Layer)

Providers now live under `lib/presentation/providers/` and are wired via GetIt in the DI container.

### 1. AppProvider (`lib/presentation/providers/app_provider.dart`)
Manages global app state including:
- User authentication status
- Theme preferences
- Global app data (API keys, currency, etc.)
- Text controllers
- Utility methods

**Key Methods:**
- `initializeApp()`
- `saveUserData()`
- `logout()`
- `setThemeMode()`

### 2. AuthProvider (`lib/presentation/providers/auth_provider.dart`)
Handles authentication and session management via Domain Use Cases:
- Login, Register, Verify OTP, Forgot Password
- Session persistence via Local Data Source

**Key Methods:**
- `login(email, password)`
- `register(userData)`
- `verifyOtp(otp, email)`
- `forgotPassword(email)`
- `logout()`

### 3. CartProvider (`lib/presentation/providers/cart_provider.dart`)
Manages shopping cart state and persistence:
- Add/remove items
- Update quantities
- Cart totals & counts

**Key Methods:**
- `addItem(item)`
- `updateQuantity(itemId, quantity)`
- `removeItem(itemId)`
- `clearCart()`
- `isItemInCart(itemId)`

### 4. DataProvider (`lib/presentation/providers/data_provider.dart`)
Coordinates app data flows through Use Cases:
- Home data fetching (chefs/grocers)
- User profiles
- Search
- Notifications

**Key Methods:**
- `fetchHomeData()`
- `fetchUserProfile()`
- `searchUsers(query)`
- `fetchNotifications()`
- `refreshAllData()`

## How Providers Are Wired (GetIt + MultiProvider)
- DI container: `lib/core/di/injection_container.dart`
- App entry: `lib/main.dart` wraps `MaterialApp` with `MainProvider` (`lib/presentation/providers/main_provider.dart`) which registers providers via GetIt

```dart
return MainProvider(
  child: MaterialApp(...),
);
```

## Usage Examples

### Accessing Providers
```dart
// Non-listening access (for actions)
final auth = context.read<AuthProvider>();
final cart = context.read<CartProvider>();

// Listening access (for UI updates)
final authListen = context.watch<AuthProvider>();
final dataListen = context.watch<DataProvider>();
```

### Using Consumer for UI Updates
```dart
Consumer<CartProvider>(
  builder: (context, cartProvider, child) {
    return Text('Cart: ${cartProvider.cartCount} items');
  },
)
```

### Performing Actions
```dart
// Login
final ok = await context.read<AuthProvider>().login(email, password);

// Add to cart
await context.read<CartProvider>().addItem(cartItem);

// Fetch data
await context.read<DataProvider>().fetchHomeData();
```

### Error/Loading Patterns
```dart
Consumer<DataProvider>(
  builder: (context, p, child) {
    if (p.isLoading) return const CircularProgressIndicator();
    if (p.error.isNotEmpty) return Text('Error: ${p.error}');
    return YourWidget();
  },
)
```

## Migration Changes Made (Highlights)
- `lib/main.dart`: App wrapped with `MainProvider`; DI initialization before `runApp()`
- `lib/splash.dart`: Provider-based initialization; removed direct `SharedPreferences` access from UI
- `lib/Screens/Buyer/Home/buyer_home.dart`: Reactive UI with `Consumer`; data via `DataProvider`
- `lib/Screens/Auth/login.dart`: Auth via `AuthProvider`; improved callbacks & layout
- `lib/Comman widgets/add_to_card.dart`: Refactored to CartProvider pattern

## Post‑Migration Upgrade: Clean Architecture + GetIt + Dio
- Data layer moved to `lib/data/...` (Dio API, Local storage, Repositories)
- Domain layer at `lib/domain/...` (Use Cases, Entities, Repository contracts)
- Presentation layer providers delegate to Use Cases
- DI container (`lib/core/di/injection_container.dart`) wires everything together

## Benefits
1. **Centralized State** with clear ownership
2. **Reactive UI** without manual synchronization
3. **Separation of Concerns** improves maintainability
4. **Testability** with mockable use cases/repositories
5. **Performance** via granular rebuilds
6. **Scalability** due to Clean Architecture + DI

## Run & Build Instructions
1. Fetch deps: `flutter pub get`
2. Generate JSON models: `flutter pub run build_runner build --delete-conflicting-outputs`
3. Run the app: `flutter run`

## Troubleshooting
- Provider not found: ensure screen is under `MainProvider`
- JSON errors: regenerate with build_runner (step 2)
- Network errors: verify base URL and connectivity

## Conclusion
The Provider migration, combined with Clean Architecture, GetIt, and Dio, establishes a professional, scalable foundation. The app is now easier to extend, test, and maintain while delivering a smoother developer workflow.
