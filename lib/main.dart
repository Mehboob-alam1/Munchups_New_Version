import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:munchups_app/splash.dart';
import 'package:munchups_app/Component/providers/main_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    Stripe.publishableKey =
        'pk_live_51I59QPKSvZKZ5ivnEEOI3it3x12CoZWG3fDpHyG1vQ8zql6qvOwDfLYQpRZDmxGnpsvkRYuoJNVHK3Ocd3EfWaPw00KKlxnIVk';
    //'pk_test_Qv6FioIn5wfwiVyeQ059x3TQ';
    //'pk_test_51IkRuXSEb0HOYnTN5QorZqn7wdyy2FbzTxXxaD8xA6Aj1zRQcm7BGDbuantkgUcSzgXTHzafnZQcGe13aKCE5K3d00Bru6jU7e';
    await Stripe.instance.applySettings();
  } catch (e) {
    log('Error initializing Stripe: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MainProvider(
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
          // dialogTheme:  const DialogTheme(
          //     surfaceTintColor: Color(0xff272A3D),
          //     backgroundColor: Color(0xff272A3D)),
        ),
        themeMode: ThemeMode.dark,
        home: const SplashPage(),
      ),
    );
  }
}
