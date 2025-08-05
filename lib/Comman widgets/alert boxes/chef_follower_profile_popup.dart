import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';

class ChefFollowerProfilePopup extends StatefulWidget {
  dynamic data;
  ChefFollowerProfilePopup({super.key, required this.data});

  @override
  State<ChefFollowerProfilePopup> createState() =>
      _ChefFollowerProfilePopupState();
}

class _ChefFollowerProfilePopupState extends State<ChefFollowerProfilePopup> {
  dynamic data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Center(
        child: Text('User Detail', style: primary17w6),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.32,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  color: DynamicColor.black.withOpacity(0.3),
                  child: CustomNetworkImage(
                    url: data['image'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(data['first_name'] + ' ' + data['last_name'],
                style: white17Bold),
            const SizedBox(height: 5),
            ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0.0,
              horizontalTitleGap: 8.0,
              minVerticalPadding: 0.0,
              leading: const Icon(
                Icons.location_on,
                color: DynamicColor.lightGrey,
                size: 22,
              ),
              title: Text(
                formatAddress(data['address']),
                style: primary13bold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  const Icon(
                    Icons.call,
                    color: DynamicColor.lightGrey,
                    size: 22,
                  ),
                  const SizedBox(width: 5),
                  Text(formatMobileNumber(data['phone']), style: green13bold),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        CommanButton(
            hight: 40.0,
            width: 100.0,
            buttonName: 'Ok',
            buttonBGColor: DynamicColor.primaryColor,
            onPressed: () {
              PageNavigateScreen().back(context);
            },
            shap: 100),
      ],
    );
  }
}
