import 'package:admin/core/constant/app_theam.dart';
import 'package:admin/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  Locale? languge;
  MyServices myServices = Get.find<MyServices>();

  ThemeData get appTheme {
    String langCode = languge?.languageCode ?? "ar";
    bool isDark = myServices.box.get("isDark") ?? false;
    return isDark ? AppTheme.darkTheme(langCode) : AppTheme.lightTheme(langCode);
  }

  void changeLang(String langcode) {
    myServices.box.put("lang", langcode);
    final locale = Locale(langcode);
    languge = locale;
    Get.updateLocale(locale);

    bool isDark = myServices.box.get("isDark") ?? false;
    Get.changeTheme(
      isDark ? AppTheme.darkTheme(langcode) : AppTheme.lightTheme(langcode),
    );
  }

  void changeTheme() {
    bool isDark = myServices.box.get("isDark") ?? false;
    myServices.box.put("isDark", !isDark);

    String langCode = myServices.box.get("lang") ?? "ar";

    Get.changeTheme(
      !isDark ? AppTheme.darkTheme(langCode) : AppTheme.lightTheme(langCode),
    );
    update();
  }

  @override
  void onInit() {
    String? box = myServices.box.get("lang");
    if (box == "ar") {
      languge = const Locale("ar");
    } else if (box == "en") {
      languge = const Locale("en");
    } else {
      String deviceLang = Get.deviceLocale?.languageCode ?? "ar";
      languge = Locale(deviceLang);
      myServices.box.put("lang", deviceLang);
    }

    super.onInit();
  }
}