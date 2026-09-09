import 'package:admin/core/functions/fcm_config.dart';
import 'package:admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:hive/hive.dart';

class MyServices extends GetxService {
  late Box box;

  Future<MyServices> init() async {
    box = await Hive.openBox('appBox');

    Future.microtask(() async {
      try {
        await requestPermissionAndSetupFCM();
      } catch (e) {
        debugPrint("FCM Setup Exception (non-fatal): $e");
      }
    });

    return this;
  }
}

Future<void> initialServices() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization exception: $e");
  }

  try {
    await setupFCMChannels();
  } catch (e) {
    debugPrint("FCM Channels exception: $e");
  }

  await Get.putAsync<MyServices>(() => MyServices().init());
}
