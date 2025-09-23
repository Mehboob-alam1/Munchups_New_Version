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
import 'Component/providers/auth_flow_provider.dart';

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
    final authFlowProvider = di.sl<AuthFlowProvider>();

    log('✅ All providers created successfully from DI');
    log('AppProvider: ${appProvider.runtimeType}');
    log('AuthProvider: ${authProvider.runtimeType}');
    log('CartProvider: ${cartProvider.runtimeType}');
    log('DataProvider: ${dataProvider.runtimeType}');
    log('AuthFlowProvider: ${authFlowProvider.runtimeType}');
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AppProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CartProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<DataProvider>()),
        // Use DI for AuthFlowProvider
        ChangeNotifierProvider(create: (_) => di.sl<AuthFlowProvider>()),
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log('🏗️ Building MyApp widget...');

    return MaterialApp(
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
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final authFlowProvider = Provider.of<AuthFlowProvider>(context, listen: false);
    await authFlowProvider.initializeAuthState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthFlowProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isInitialized) {
          return const SplashScreen(); // Show splash while initializing
        }

        String nextScreen = authProvider.getNextScreen();
        
        switch (nextScreen) {
          case 'login':
            return const LoginPage();
          case 'register':
            return const RegisterPage();
          case 'otp':
            return OtpPage(
              emailId: authProvider.getOtpEmail(),
              type: authProvider.getOtpType(),
            );
          case 'forgot_password':
            return const ForgetPasswordPage();
          case 'reset_password':
            return ResetPasswordPage(
              email: authProvider.getOtpEmail(),
            );
          case 'home':
            return const HomePage(); // Your main app screen
          default:
            return const LoginPage();
        }
      },
    );
  }
}