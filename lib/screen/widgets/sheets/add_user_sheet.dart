import 'package:admin/controller/users/adduser_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/core/functions/validinput.dart';
import 'package:admin/screen/widgets/auth/coustombuttom.dart';
import 'package:admin/screen/widgets/auth/customtextinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 👤 شيت إضافة مسؤول / مستخدم جديد (Add User Modal Bottom Sheet)
class AddUserSheet extends StatelessWidget {
  const AddUserSheet({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      const AddUserSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<AdduserControllerImp>()) {
      Get.delete<AdduserControllerImp>(force: true);
    }
    Get.put(AdduserControllerImp());

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.bottomSheet,
      ),
      child: GetBuilder<AdduserControllerImp>(
        builder: (controller) => HandlingRequest(
          staterequest: controller.staterequest,
          widget: Form(
            key: controller.formState,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44.w,
                      height: 4.5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: AppColor.primaryLight,
                              borderRadius: AppRadius.badge,
                              border: Border.all(color: AppColor.primaryBorder, width: 1.w),
                            ),
                            child: const Icon(
                              IconsaxPlusBold.user_add,
                              color: AppColor.preimary,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "إضافة مسؤول / مستخدم جديد",
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close_rounded, size: 20.r, color: AppColor.textSecondary),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  // اسم المستخدم
                  Customtextinput(
                    isPassword: false,
                    isNumber: false,
                    valid: (val) => validInput(val!, 30, 2, "name"),
                    hintText: "اسم المستخدم الكامل",
                    iconData: IconsaxPlusBroken.user,
                    mycontroller: controller.userName,
                  ),
                  SizedBox(height: 12.h),

                  // رقم الهاتف
                  Customtextinput(
                    isPassword: false,
                    isNumber: true,
                    valid: (val) => validInput(val!, 15, 7, "phone"),
                    hintText: "رقم الهاتف",
                    iconData: IconsaxPlusBroken.call,
                    mycontroller: controller.userPhone,
                  ),
                  SizedBox(height: 12.h),

                  // البريد الإلكتروني
                  Customtextinput(
                    isPassword: false,
                    isNumber: false,
                    valid: (val) => validInput(val!, 50, 5, "email"),
                    hintText: "البريد الإلكتروني",
                    iconData: IconsaxPlusBroken.sms,
                    mycontroller: controller.userEmail,
                  ),
                  SizedBox(height: 12.h),

                  // كلمة المرور
                  Customtextinput(
                    isPassword: true,
                    isNumber: false,
                    valid: (val) => validInput(val!, 30, 5, "password"),
                    hintText: "كلمة المرور",
                    iconData: IconsaxPlusBroken.lock,
                    mycontroller: controller.userPassword,
                  ),
                  SizedBox(height: 22.h),

                  // زر الحفظ
                  Coustombuttom(
                    text: "إضافة المستخدم للنظام",
                    icon: IconsaxPlusBold.add_circle,
                    onPressed: () => controller.addData(),
                  ),
                  SizedBox(height: 14.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
