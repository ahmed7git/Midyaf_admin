import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/remote/user/userdata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdduserControllerImp extends GetxController {
  Staterequest staterequest = Staterequest.none;
  Userdata userdata = Userdata(Get.find());
  
  late TextEditingController userPassword;
  late TextEditingController userName;
  late TextEditingController userEmail;
  late TextEditingController userPhone;
  String userRole = "1";
  String userStatus = "1";
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  addData() async {
    if (formState.currentState!.validate()) {
      staterequest = Staterequest.loading;
      update();

      Map<String, String> data = {
        "username": userName.text.trim(),
        "password": userPassword.text.trim(),
        "email": userEmail.text.trim(),
        "phone": userPhone.text.trim(),
        "role": userRole,
        "status": userStatus,
      };

      var response = await userdata.addData(data);
      staterequest = handlingData(response);

      if (Staterequest.success == staterequest) {
        if (response['status'] == "success") {
          Get.back();
          Get.snackbar(
            "تمت العملية",
            "تمت إضافة المسؤول بنجاح",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        } else {
          Get.snackbar(
            "تنبيه",
            response['message'] ?? "البريد الإلكتروني أو رقم الهاتف مسجل مسبقاً",
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
    userPassword = TextEditingController();
    userName = TextEditingController();
    userEmail = TextEditingController();
    userPhone = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    userPassword.dispose();
    userName.dispose();
    userEmail.dispose();
    userPhone.dispose();
    super.dispose();
  }
}