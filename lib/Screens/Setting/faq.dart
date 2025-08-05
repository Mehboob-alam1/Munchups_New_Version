import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Setting/Models/faq_model.dart';

import '../../Component/Strings/strings.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  String faq = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: TextStrings.textKey['faq']!)),
      body: FutureBuilder<FaqModel>(
          future: GetApiServer().faqApi(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: DynamicColor.primaryColor,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('No FAQ available'));
                } else if (snapshot.data!.success != 'true') {
                  return const Center(child: Text('No FAQ available'));
                } else if (snapshot.data!.faq == 'NA') {
                  return const Center(child: Text('No FAQ available'));
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.getSize20(context: context),
                            left: SizeConfig.getSize20(context: context),
                            right: SizeConfig.getSize20(context: context)),
                        child: Text(snapshot.data!.faq, style: white15bold)
                        // Column(
                        //   children: [
                        //     const SizedBox(height: 30),
                        //     customWidget(
                        //         number: 1,
                        //         question: 'It is a long established fact that a reader?',
                        //         answer:
                        //             'There are many variations of passages of Lorem Ipsum available, but the majority.'),
                        //     const SizedBox(height: 20),
                        //     customWidget(
                        //         number: 2,
                        //         question: 'It is a long established fact that a reader?',
                        //         answer:
                        //             'There are many variations of passages of Lorem Ipsum available, but the majority.'),
                        //     const SizedBox(height: 20),
                        //     customWidget(
                        //         number: 3,
                        //         question: 'It is a long established fact that a reader?',
                        //         answer:
                        //             'There are many variations of passages of Lorem Ipsum available, but the majority.'),
                        //     const SizedBox(height: 20),
                        //     customWidget(
                        //         number: 4,
                        //         question: 'It is a long established fact that a reader?',
                        //         answer:
                        //             'There are many variations of passages of Lorem Ipsum available, but the majority.'),
                        //     const SizedBox(height: 20),
                        //     customWidget(
                        //         number: 5,
                        //         question: 'It is a long established fact that a reader?',
                        //         answer:
                        //             'There are many variations of passages of Lorem Ipsum available, but the majority.'),
                        //     const SizedBox(height: 20),
                        //     customWidget(
                        //         number: 6,
                        //         question: 'It is a long established fact that a reader?',
                        //         answer:
                        //             'There are many variations of passages of Lorem Ipsum available, but the majority.'),
                        //     const SizedBox(height: 20),
                        //     customWidget(
                        //         number: 7,
                        //         question: 'It is a long established fact that a reader?',
                        //         answer:
                        //             'There are many variations of passages of Lorem Ipsum available, but the majority.'),
                        //   ],
                        // ),
                        ),
                  );
                }
            }
          }),
    );
  }

  Widget customWidget(
      {required int number, required String question, required String answer}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text('Q$number: ', style: white15bold)),
            Expanded(
                flex: 9,
                child: Text(question,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: DynamicColor.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    )))
          ],
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text('Ans: ', style: white15bold)),
            Expanded(
                flex: 9,
                child: Text(answer,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: DynamicColor.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    )))
          ],
        ),
      ],
    );
  }
}
