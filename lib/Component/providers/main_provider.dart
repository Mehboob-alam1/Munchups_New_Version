import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'auth_provider.dart';
import 'cart_provider.dart';
import 'data_provider.dart';

class MainProvider extends StatelessWidget {
  final Widget child;

  const MainProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: child,
    );
  }
}

// Extension methods for easy access to providers
extension ProviderExtension on BuildContext {
  AppProvider get appProvider => Provider.of<AppProvider>(this, listen: false);
  AuthProvider get authProvider => Provider.of<AuthProvider>(this, listen: false);
  CartProvider get cartProvider => Provider.of<CartProvider>(this, listen: false);
  DataProvider get dataProvider => Provider.of<DataProvider>(this, listen: false);

  // Listenable versions for UI updates
  AppProvider get appProviderListen => Provider.of<AppProvider>(this);
  AuthProvider get authProviderListen => Provider.of<AuthProvider>(this);
  CartProvider get cartProviderListen => Provider.of<CartProvider>(this);
  DataProvider get dataProviderListen => Provider.of<DataProvider>(this);
}
