import 'package:admin/binding.dart';
import 'package:admin/core/constant/app_theam.dart';
import 'package:admin/core/localization/change.dart';
import 'package:admin/core/localization/translation.dart';
import 'package:admin/core/services/services.dart';
import 'package:admin/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

  await Hive.initFlutter();
  await initialServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final LocaleController controller = Get.put(LocaleController());
        final String langCode = controller.languge?.languageCode ?? "ar";
        final bool isDark = controller.myServices.box.get("isDark") ?? false;

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: controller.languge,
          translations: MyTranslation(),
          theme: AppTheme.lightTheme(langCode),
          darkTheme: AppTheme.darkTheme(langCode),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          initialBinding: MyBinding(),
          getPages: routes,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
