import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:munchups_app/Apis/get_apis.dart';

class NotificationController {
  int totalNotiCount = 0;
  ValueNotifier<int> totalCount = ValueNotifier<int>(0);
  Timer timer = Timer(const Duration(seconds: 0), () {});
  static AudioPlayer beepFile = AudioPlayer();

  Future getAllNotificationListApi(BuildContext context) async {
    try {
      await beepFile
          .setAsset('assets/sound/mixkit-software-interface-start-2574.wav');
      await GetApiServer().countNotificationApi().then((value) {
        if (value['notification_count'] > totalNotiCount) {
          beepFile.play();
        } else {
          beepFile.pause();
        }

        totalNotiCount = value['notification_count'];
        totalCount.value = value['notification_count'];
      });
    } catch (e) {
      totalNotiCount = 0;
      timer.cancel();
    }
  }

  void startTimer(BuildContext context) {
    getAllNotificationListApi(context);

    timer.cancel();
    try {
      timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        getAllNotificationListApi(context);
      });
    } catch (e) {
      log('notify = ' + e.toString());
      timer.cancel();
      timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        getAllNotificationListApi(context);
      });
      log('error = ' + e.toString());
    }
  }

  void closeTimer(BuildContext context) {
    beepFile.dispose();
    timer.cancel();
    totalNotiCount = 0;
  }
}
