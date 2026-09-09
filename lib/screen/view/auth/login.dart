import 'dart:io';
import 'package:admin/controller/auth/login_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/alertexit.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/core/functions/validinput.dart';
import 'package:admin/screen/widgets/auth/coustombuttom.dart';
import 'package:admin/screen/widgets/auth/customtextinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginControllerImp());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: GetBuilder<LoginControllerImp>(
        builder: (controller) => HandlingRequest(
          staterequest: controller.staterequest,
          widget: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              if (Get.isDialogOpen == false) {
                CustomexitDialog.show(
                  title: "تنبيه",
                  message: "هل تريد حقاً الخروج من التطبيق؟",
                  buttonTextone: "نعم",
                  buttonTexttwo: "إلغاء",
                  onPressedone: () => exit(0),
                  onPressedtwo: () => Get.back(),
                );
              }
            },
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.card,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 20.r,
                              offset: Offset(0, 8.h),
                            ),
                          ],
                        ),
                        child: Form(
                          key: controller.formState,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 70.r,
                                height: 70.r,
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: AppColor.preimary.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconsaxPlusBold.shield_security,
                                  color: AppColor.preimary,
                                  size: 34.r,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "بوابة الإدارة والمراقبة",
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E242B),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "يرجى تسجيل الدخول للوصول إلى لوحة العمليات",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              SizedBox(height: 28.h),

                              Customtextinput(
                                isPassword: false,
                                isNumber: false,
                                valid: (val) {
                                  return validInput(val!, 50, 5, "email");
                                },
                                hintText: "البريد الإلكتروني للإدارة",
                                iconData: IconsaxPlusBroken.sms,
                                mycontroller: controller.email,
                              ),
                              SizedBox(height: 16.h),

                              Customtextinput(
                                onTap: () {
                                  controller.showPasswprd();
                                },
                                isPassword: true,
                                obscureText: controller.isShowPassword,
                                isNumber: false,
                                valid: (val) {
                                  return validInput(val!, 30, 6, "password");
                                },
                                hintText: "كلمة المرور",
                                iconData: IconsaxPlusBroken.lock,
                                mycontroller: controller.password,
                              ),
                              SizedBox(height: 26.h),

                              Coustombuttom(
                                text: "تسجيل الدخول",
                                icon: IconsaxPlusBroken.login_1,
                                onPressed: () {
                                  controller.login();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
