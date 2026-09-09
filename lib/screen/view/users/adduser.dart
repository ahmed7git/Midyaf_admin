import 'package:admin/controller/users/adduser_controller.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/custominputtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUser extends StatelessWidget {
  const AddUser({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdduserControllerImp());
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة مستخدم جديد"), centerTitle: true),
      body: GetBuilder<AdduserControllerImp>(
        builder: (controller) => HandlingRequestView(
          staterequest: controller.staterequest,
          widget: Form(
            key: controller.formState,

            child: Column(
              children: [
                Text(
                  "هنا يمكنك إضافة مستخدم جديد",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),

                Custominputtext(
                  controller: controller.userName,
                  label: 'اسم المستخدم',
                  hintText: 'أدخل اسم المستخدم',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المستخدم';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.userPhone,
                  label: 'رقم الهاتف',
                  hintText: 'أدخل رقم الهاتف',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Custominputtext(
                  controller: controller.userEmail,
                  label: 'البريد الإلكتروني',
                  hintText: 'أدخل البريد الإلكتروني',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.userPassword,
                  label: 'كلمة المرور',
                  hintText: 'أدخل كلمة المرور',
                  isPassword: true,
                  obscureText: true,
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    controller.addData();
                  },
                  child: Text("إضافة المستخدم"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
