import 'package:admin/controller/coupon/coupon_controller.dart';
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

/// 🏷️ شيت إضافة كوبون خصم جديد (Add Coupon Bottom Sheet)
class AddCouponSheet extends StatelessWidget {
  const AddCouponSheet({super.key});

  static void show(BuildContext context) {
    if (!Get.isRegistered<CouponControllerImp>()) {
      Get.put(CouponControllerImp());
    } else {
      Get.find<CouponControllerImp>().clearForm();
    }

    Get.bottomSheet(
      const AddCouponSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CouponControllerImp>()) {
      Get.put(CouponControllerImp());
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.bottomSheet,
      ),
      child: GetBuilder<CouponControllerImp>(
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
                          Icon(
                            IconsaxPlusBold.ticket_discount,
                            color: AppColor.preimary,
                            size: 20.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "إضافة كوبون خصم جديد",
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
                  SizedBox(height: 16.h),

                  Customtextinput(
                    isPassword: false,
                    isNumber: false,
                    valid: (val) => validInput(val!, 30, 2, "name"),
                    hintText: "رمز / كود الكوبون (مثلاً: SAVE20)",
                    iconData: IconsaxPlusBroken.ticket_discount,
                    mycontroller: controller.nameController,
                  ),
                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      Expanded(
                        child: Customtextinput(
                          isPassword: false,
                          isNumber: true,
                          valid: (val) => validInput(val!, 10, 1, "number"),
                          hintText: "نسبة الخصم %",
                          iconData: IconsaxPlusBroken.percentage_circle,
                          mycontroller: controller.discountController,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Customtextinput(
                          isPassword: false,
                          isNumber: true,
                          valid: (val) => validInput(val!, 10, 1, "number"),
                          hintText: "عدد مرات الاستخدام",
                          iconData: IconsaxPlusBroken.repeat,
                          mycontroller: controller.countController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // حقل اختيار تاريخ الانتهاء مع منتقي التقويم
                  GestureDetector(
                    onTap: () => controller.pickExpireDate(context),
                    behavior: HitTestBehavior.opaque,
                    child: AbsorbPointer(
                      child: Customtextinput(
                        isPassword: false,
                        isNumber: false,
                        valid: (val) => validInput(val!, 30, 6, "date"),
                        hintText: "اضغط لتحديد تاريخ الانتهاء من التقويم",
                        iconData: IconsaxPlusBold.calendar_1,
                        mycontroller: controller.expireDateController,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Coustombuttom(
                    text: "حفظ ونشر الكوبون",
                    icon: IconsaxPlusBold.tick_circle,
                    onPressed: () => controller.addCoupon(),
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
