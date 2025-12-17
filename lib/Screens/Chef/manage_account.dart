import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAccountPageForChefAndGrocer extends StatefulWidget {
  const ManageAccountPageForChefAndGrocer({super.key});

  @override
  State<ManageAccountPageForChefAndGrocer> createState() =>
      _ManageAccountPageForChefAndGrocerState();
}

class _ManageAccountPageForChefAndGrocerState
    extends State<ManageAccountPageForChefAndGrocer> with WidgetsBindingObserver {
  dynamic userData;
  bool isLoading = false;
  String? stripeAccountId;
  bool _hasOpenedStripe = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserDetail();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Quando l'app torna in foreground dopo aver aperto Stripe
    if (state == AppLifecycleState.resumed && _hasOpenedStripe) {
      log('App resumed after Stripe - refreshing user data...');
      _hasOpenedStripe = false;
      
      // Aspetta un po' per assicurarsi che Stripe abbia completato
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          refreshUserData();
        }
      });
    }
  }

  getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('data').toString());
      stripeAccountId = userData['stripe_account_id']?.toString();
    });
  }

  Future<void> refreshUserData() async {
    try {
      log('Refreshing user data to check Stripe account status...');
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userType = prefs.getString('user_type');
      
      if (userData != null && userType != null) {
        setState(() {
          isLoading = true;
        });
        
        // Chiama l'API per ottenere il profilo aggiornato dal server
        try {
          final profileData = await GetApiServer().getProfileApi(context);
          log('Profile data refreshed: $profileData');
          
          if (profileData != null && profileData['success'] == 'true') {
            // Aggiorna i dati locali
            final updatedUserData = profileData['profile_data'] ?? profileData['data'] ?? profileData;
            
            // Salva i dati aggiornati
            await prefs.setString('data', jsonEncode(updatedUserData));
            
            // Ricarica i dati nella UI
            setState(() {
              userData = updatedUserData;
              stripeAccountId = updatedUserData['stripe_account_id']?.toString();
            });
            
            if (mounted) {
              if (stripeAccountId != null && stripeAccountId!.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('✅ Stripe account connected successfully!'),
                    backgroundColor: DynamicColor.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Stripe account status updated.'),
                    backgroundColor: DynamicColor.primaryColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          }
        } catch (e) {
          log('Error fetching profile: $e');
          // Fallback: ricarica solo i dati locali
          getUserDetail();
        }
        
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error refreshing user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Manage Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.getSize20(context: context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: SizeConfig.getSize40(context: context)),
              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: DynamicColor.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 64,
                  color: DynamicColor.primaryColor,
                ),
              ),
              SizedBox(height: SizeConfig.getSize30(context: context)),
              // Title
              Text(
                'Connect Payment Account',
                style: primary25bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.getSize20(context: context)),
              // Description
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getSize20(context: context)),
                child: Column(
                  children: [
                    Text(
                      'Connect your Stripe account to receive payments from customers.',
                      style: white15bold,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    Text(
                      'You will be redirected to Stripe.com to complete the setup process.',
                      style: white14w5.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.getSize40(context: context)),
              // Status card if already connected
              if (stripeAccountId != null && stripeAccountId!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getSize20(context: context)),
                  decoration: BoxDecoration(
                    color: DynamicColor.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: DynamicColor.green,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: DynamicColor.green,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Connected',
                              style: white15bold.copyWith(
                                color: DynamicColor.green,
                              ),
                            ),
                            Text(
                              'Your Stripe account is connected',
                              style: white14w5.copyWith(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: SizeConfig.getSize30(context: context)),
              // Connect Button
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getSize20(context: context)),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DynamicColor.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading ? null : connectStripeAccount,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.link, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    stripeAccountId != null &&
                                            stripeAccountId!.isNotEmpty
                                        ? 'Reconnect Account'
                                        : 'Connect Stripe Account',
                                    style: white15bold,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.getSize20(context: context)),
              // Info
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getSize20(context: context)),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Secure connection powered by Stripe',
                        style: white14w5.copyWith(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> connectStripeAccount() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Call backend API to create Stripe Connect account and get onboarding link
      final body = {
        'user_id': userData['user_id'].toString(),
        'user_type': userData['user_type']?.toString() ?? 'chef',
        'email': userData['email']?.toString() ?? '',
      };

      log('=== CONNECT STRIPE ACCOUNT ===');
      log('User ID: ${body['user_id']}');
      log('User Type: ${body['user_type']}');
      log('Email: ${body['email']}');
      log('Calling API...');

      final response = await PostApiServer().connectStripeAccountApi(body);

      log('API Response received: $response');

      // Check if response indicates success
      if (response['success'] == 'true' || response['success'] == true) {
        final accountLink = response['account_link_url']?.toString() ?? 
                           response['url']?.toString() ?? 
                           response['link']?.toString();
        
        if (accountLink != null && accountLink.isNotEmpty) {
          // Save account ID if provided
          if (response['account_id'] != null) {
            final newAccountId = response['account_id'].toString();

            // Update local state
            setState(() {
              stripeAccountId = newAccountId;
            });

            // Persist updated user data in SharedPreferences
            try {
              final prefs = await SharedPreferences.getInstance();
              final raw = prefs.getString('data');
              if (raw != null) {
                final current = jsonDecode(raw);
                current['stripe_account_id'] = newAccountId;
                await prefs.setString('data', jsonEncode(current));
              }
            } catch (e) {
              log('Error updating local user data with stripe_account_id: $e');
            }
          }

          // Mark that we're opening Stripe (so we can refresh when app resumes)
          _hasOpenedStripe = true;

          // Open Stripe onboarding URL
          await Utils.launchUrls(accountLink, context);

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Redirecting to Stripe... Complete the setup and return to the app.'),
                backgroundColor: DynamicColor.green,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        } else {
          throw Exception('No account link URL received from server');
        }
      } else {
        // Extract error message from response
        String errorMsg = response['msg']?.toString() ?? 
                         response['message']?.toString() ?? 
                         'Failed to connect Stripe account';
        
        // Check if Stripe SDK is missing
        if (response['stripe_sdk_missing'] == true || 
            response['error']?.toString() == 'stripe_sdk_missing' ||
            errorMsg.contains('Stripe PHP SDK not installed')) {
          errorMsg = '⚠️ Stripe SDK Not Installed\n\n'
                    'The Stripe PHP SDK is not installed on the server.\n\n'
                    'Please install it:\n'
                    '1. Via SSH: cd /public_html/webservice && composer require stripe/stripe-php\n'
                    '2. Or download from: https://github.com/stripe/stripe-php/archive/refs/heads/master.zip\n'
                    '3. Extract to: /public_html/webservice/vendor/stripe-php/\n\n'
                    'Then try again.';
        } 
        // Check if the error indicates endpoint not found
        else if (response['error']?.toString().contains('404') == true ||
            response['error']?.toString().contains('Not Found') == true ||
            errorMsg.contains('endpoint not found') ||
            errorMsg.contains('does not exist')) {
          errorMsg = '⚠️ Backend Endpoint Missing\n\n'
                    'The server endpoint "connect_stripe_account.php" does not exist.\n\n'
                    'Please contact your backend developer to:\n'
                    '1. Create the endpoint at: https://munchups.com/webservice/connect_stripe_account.php\n'
                    '2. Configure Stripe Secret Key: sk_test_N950jTKYw562aEty72yLlaEZ\n'
                    '3. See STRIPE_BACKEND_SETUP.md for implementation details';
        } else if (errorMsg.isEmpty || errorMsg == 'Failed to connect Stripe account') {
          errorMsg = 'Server endpoint not found or server error. Please contact customer support.';
        }
        
        throw Exception(errorMsg);
      }
    } catch (e) {
      log('Error connecting Stripe account: $e');
      String errorMessage = 'Failed to connect Stripe account';
      
      // Extract error message from exception
      String errorString = e.toString();
      
      // Remove "Exception: " prefix if present
      if (errorString.startsWith('Exception: ')) {
        errorString = errorString.substring(11);
      }
      
      // Use the error message from the exception if it's meaningful
      if (errorString.isNotEmpty && 
          !errorString.contains('Exception') &&
          errorString.length > 5) {
        errorMessage = errorString;
      } else if (errorString.contains('FormatException') || 
                 errorString.contains('Unexpected character')) {
        errorMessage = 'Server endpoint not found. Please contact customer support.';
      } else if (errorString.contains('HTML') || 
                 errorString.contains('404') ||
                 errorString.contains('Not Found')) {
        errorMessage = 'Server endpoint not found. Please contact customer support.';
      } else if (errorString.contains('500') || 
                 errorString.contains('Server error')) {
        errorMessage = 'Server error. Please contact customer support.';
      } else if (errorString.contains('Network error') ||
                 errorString.contains('SocketException') ||
                 errorString.contains('TimeoutException')) {
        errorMessage = errorString; // Use the network error message as is
      } else {
        errorMessage = 'Server endpoint not found or server error. Please contact customer support.';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
