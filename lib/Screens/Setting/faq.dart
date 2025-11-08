import 'package:flutter/material.dart';
import 'package:munchups_app/Comman widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/settings_provider.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadFaq();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: TextStrings.textKey['faq']!)),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (settingsProvider.isFaqLoading && settingsProvider.faq == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: DynamicColor.primaryColor,
              ),
            );
          }

          if (settingsProvider.faqError.isNotEmpty &&
              settingsProvider.faq == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(settingsProvider.faqError),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        settingsProvider.loadFaq(forceRefresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final faq = settingsProvider.faq;
          if (faq == null) {
            return const Center(child: Text('No FAQ available'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(faq.content),
            ),
          );
        },
      ),
    );
  }
}
