import 'package:admin/core/constant/reoute.dart';
import 'package:admin/core/functions/fcm_config.dart';
import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/core/services/services.dart';
import 'package:admin/data/remote/auth/logindata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class LoginController extends GetxController {
  login();
}

class LoginControllerImp extends LoginController {
  late TextEditingController email;
  late TextEditingController password;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isShowPassword = true;
  Staterequest staterequest = Staterequest.none;
  LoginData loginData = LoginData(Get.find());
  MyServices myServices = Get.find<MyServices>();

  showPasswprd() {
    isShowPassword = !isShowPassword;
    update();
  }

  @override
  login() async {
    if (formState.currentState!.validate()) {
      staterequest = Staterequest.loading;
      update();
      var response = await loginData.postData(email.text, password.text);
      staterequest = handlingData(response);
      if (Staterequest.success == staterequest) {
        if (response['status'] == "success") {
          String userid = response['data']['admin_id'].toString();
          await subscribeToUserTopic(userid);
          if (response['data']['admin_approve'].toString() == "1") {
            myServices.box.put("id", response['data']["admin_id"]);
            myServices.box.put("token", response['data']["admin_token"]);
            myServices.box.put("username", response['data']["admin_name"]);
            myServices.box.put("email", response['data']["admin_email"]);
            myServices.box.put("phone", response['data']["admin_phone"]);
            myServices.box.put("step", "1");
            Get.offAllNamed(AppRoutes.home);
          } else {
            Get.offNamed(AppRoutes.verfiyemail, arguments: {"email": email.text});
          }
        } else {
          Get.snackbar(
            "تنبيه",
            "البريد الإلكتروني أو كلمة المرور غير صحيحة",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
          staterequest = Staterequest.failure;
        }
      }
      update();
    }
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
