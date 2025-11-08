import 'package:flutter/material.dart';
import 'package:munchups_app/Comman widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/settings_provider.dart';

class TermsAndConditonPage extends StatefulWidget {
  TermsAndConditonPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditonPage> createState() => _TermsAndConditonPageState();
}

class _TermsAndConditonPageState extends State<TermsAndConditonPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['terms&con']!)),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (settingsProvider.isContentLoading &&
              settingsProvider.content == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: DynamicColor.primaryColor,
              ),
            );
          }

          if (settingsProvider.contentError.isNotEmpty &&
              settingsProvider.content == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(settingsProvider.contentError),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        settingsProvider.loadContent(forceRefresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final content = settingsProvider.content;
          if (content == null) {
            return const Center(
                child: Text('No Terms and Conditions available'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(content.termsConditions),
            ),
          );
        },
      ),
    );
  }
}
