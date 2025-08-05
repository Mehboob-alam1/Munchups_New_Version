import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:share_plus/share_plus.dart';

import '../../Comman widgets/app_bar/back_icon_appbar.dart';

class InviteUser extends StatefulWidget {
  const InviteUser({super.key});

  @override
  State<InviteUser> createState() => _InviteUserState();
}

class _InviteUserState extends State<InviteUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['invite_user']!)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text('Share with Friends', style: primary25bold),
          const SizedBox(height: 5),
          Text('Invite your friends deserves to', style: white15Normal),
          Text('Live Life Batter', style: white15Normal),
          SizedBox(height: SizeConfig.getSize30(context: context)),
          SizedBox(
            child: Image.asset('assets/images/referral.webp'),
          ),
          SizedBox(height: SizeConfig.getSize60(context: context)),
          CommanButton(
              heroTag: 1,
              shap: 10.0,
              width: MediaQuery.of(context).size.width * 0.5,
              buttonName: 'Invite Now'.toUpperCase(),
              onPressed: () {
                Share.share('https://play.google.com/store');
                //PageNavigateScreen().push(context, const MainHomePage());
              })
        ],
      ),
    );
  }
}
