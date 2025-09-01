import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:munchups_app/splash.dart';
import 'package:munchups_app/core/di/injection_container.dart' as di;
import 'package:provider/provider.dart';

// Import your provider classes
import 'package:munchups_app/presentation/providers/app_provider.dart';
import 'package:munchups_app/presentation/providers/auth_provider.dart';
import 'package:munchups_app/presentation/providers/cart_provider.dart';
import 'package:munchups_app/presentation/providers/data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  log('🚀 Starting app initialization...');

  // Initialize dependency injection
  try {
    await di.init();
    log('✅ Dependency injection initialized');
  } catch (e) {
    log('❌ Error initializing DI: $e');
  }

  // Test if providers can be created from DI
  try {
    final appProvider = di.sl<AppProvider>();
    final authProvider = di.sl<AuthProvider>();
    final cartProvider = di.sl<CartProvider>();
    final dataProvider = di.sl<DataProvider>();

    log('✅ All providers created successfully from DI');
    log('AppProvider: ${appProvider.runtimeType}');
    log('AuthProvider: ${authProvider.runtimeType}');
    log('CartProvider: ${cartProvider.runtimeType}');
    log('DataProvider: ${dataProvider.runtimeType}');
  } catch (e) {
    log('❌ Error creating providers from DI: $e');
    log('❌ Stack trace: ${StackTrace.current}');
  }

  try {
    Stripe.publishableKey =
    'pk_live_51I59QPKSvZKZ5ivnEEOI3it3x12CoZWG3fDpHyG1vQ8zql6qvOwDfLYQpRZDmxGnpsvkRYuoJNVHK3Ocd3EfWaPw00KKlxnIVk';
    await Stripe.instance.applySettings();
    log('✅ Stripe initialized');
  } catch (e) {
    log('❌ Error initializing Stripe: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log('🏗️ Building MyApp widget...');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (context) {
            log('📦 Creating AppProvider...');
            try {
              final provider = di.sl<AppProvider>();
              log('✅ AppProvider created successfully');
              return provider;
            } catch (e) {
              log('❌ Error creating AppProvider: $e');
              rethrow;
            }
          },
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            log('📦 Creating AuthProvider...');
            try {
              final provider = di.sl<AuthProvider>();
              log('✅ AuthProvider created successfully');
              return provider;
            } catch (e) {
              log('❌ Error creating AuthProvider: $e');
              rethrow;
            }
          },
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) {
            log('📦 Creating CartProvider...');
            try {
              final provider = di.sl<CartProvider>();
              log('✅ CartProvider created successfully');
              return provider;
            } catch (e) {
              log('❌ Error creating CartProvider: $e');
              rethrow;
            }
          },
        ),
        ChangeNotifierProvider<DataProvider>(
          create: (context) {
            log('📦 Creating DataProvider...');
            try {
              final provider = di.sl<DataProvider>();
              log('✅ DataProvider created successfully');
              return provider;
            } catch (e) {
              log('❌ Error creating DataProvider: $e');
              rethrow;
            }
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Munchups',
        darkTheme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.dark,
          primaryColor: const Color(0xff272A3D),
          primaryColorDark: const Color(0xff272A3D),
          scaffoldBackgroundColor: const Color(0xff272A3D),
          bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: Color(0xff272A3D),
              backgroundColor: Color(0xff272A3D)),
        ),
        themeMode: ThemeMode.dark,
        home: const SplashPage(),
      ),
    );
  }
}