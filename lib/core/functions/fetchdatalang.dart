import 'package:admin/core/services/services.dart';
import 'package:get/get.dart';


fetchDataLang(columar, columen) {
  MyServices myServices = Get.find();
  String? languge = myServices.box.get("lang");
  if (languge == "ar") {
    return columar;
  } else {
    return columen;
  }
}
