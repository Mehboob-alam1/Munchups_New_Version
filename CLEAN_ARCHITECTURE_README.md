# Clean Architecture Implementation Guide

This document outlines the implementation of Clean Architecture in the Munchups Flutter app, including GetIt dependency injection and Dio for HTTP requests.

## ✨ Executive Summary
- Introduced **Clean Architecture** (Presentation / Domain / Data / Core)
- Implemented **GetIt** for dependency injection
- Switched networking to **Dio** with interceptors and timeouts
- Centralized error handling (`Either<Failure, T>`) and domain use cases
- Upgraded Providers to consume use cases instead of talking to APIs directly

## 🏗️ **Architecture Overview**

The app follows Clean Architecture principles with the following layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Providers     │  │     Widgets     │  │   Screens   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Use Cases     │  │   Entities      │  │ Repositories│ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │ Repositories    │  │   Data Sources  │  │   Models    │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      CORE LAYER                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   DI Container  │  │   Error Handling│  │   Network   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 📁 **Project Structure**

```
lib/
├── core/
│   ├── di/
│   │   └── injection_container.dart
│   ├── error/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   └── usecases/
│       └── usecase.dart
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   │   ├── api_service.dart
│   │   │   └── network_info.dart
│   │   └── local/
│   │       └── local_storage.dart
│   ├── models/
│   │   ├── auth_response_model.dart
│   │   ├── user_profile_model.dart
│   │   ├── home_data_model.dart
│   │   ├── search_response_model.dart
│   │   └── notification_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── cart_repository_impl.dart
│       └── data_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── login_params.dart
│   │   ├── cart_item.dart
│   │   └── user.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── cart_repository.dart
│   │   └── data_repository.dart
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   ├── register_usecase.dart
│       │   ├── verify_otp_usecase.dart
│       │   └── forgot_password_usecase.dart
│       ├── cart/
│       │   ├── add_to_cart_usecase.dart
│       │   ├── remove_from_cart_usecase.dart
│       │   └── update_cart_usecase.dart
│       └── data/
│           ├── fetch_home_data_usecase.dart
│           ├── fetch_user_profile_usecase.dart
│           ├── search_users_usecase.dart
│           └── fetch_notifications_usecase.dart
└── presentation/
    ├── providers/
    │   ├── main_provider.dart
    │   ├── app_provider.dart
    │   ├── auth_provider.dart
    │   ├── cart_provider.dart
    │   └── data_provider.dart
    ├── screens/
    └── widgets/
```

## 🔧 **Dependencies Added**
- GetIt, Dio, Dartz, Connectivity Plus, JSON Annotation
- Dev: JSON Serializable, Build Runner

## 🧭 **How It Works (High-Level)**
1. UI talks to Providers (Presentation)
2. Providers invoke Use Cases (Domain)
3. Use Cases call Repositories (Domain) implemented in Data layer
4. Data layer uses Dio (Remote) and SharedPreferences (Local)
5. All components resolved via GetIt (DI)

## ▶️ Run Instructions
1. `flutter pub get`
2. `flutter pub run build_runner build --delete-conflicting-outputs`
3. `flutter run`

## 💼 Client-Facing Highlights
- Enterprise-grade structure for long-term scalability
- Faster onboarding with clear layering and docs
- Safer changes due to isolated responsibilities
- Easier testing, mocking, and iteration speed

## 🚨 Common Issues & Solutions
- GetIt not initialized: call `await di.init()` before `runApp()`
- Provider not found: ensure widget tree is wrapped by `MainProvider`
- JSON errors: run Build Runner (step 2)
- Network errors: verify base URL and connectivity

## 🎯 Outcome
This upgrade transforms the codebase into a maintainable, testable, and scalable application foundation. It sets the team up for rapid feature delivery with reduced risk.
