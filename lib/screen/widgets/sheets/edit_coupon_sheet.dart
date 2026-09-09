import 'package:admin/controller/coupon/coupon_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/core/functions/validinput.dart';
import 'package:admin/data/model/coupon_model.dart';
import 'package:admin/screen/widgets/auth/coustombuttom.dart';
import 'package:admin/screen/widgets/auth/customtextinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 🏷️ شيت تعديل بيانات الكوبون (Edit Coupon Bottom Sheet)
class EditCouponSheet extends StatelessWidget {
  final CouponModel coupon;
  const EditCouponSheet({super.key, required this.coupon});

  static void show(BuildContext context, CouponModel coupon) {
    final controller = Get.isRegistered<CouponControllerImp>()
        ? Get.find<CouponControllerImp>()
        : Get.put(CouponControllerImp());
    controller.initEditData(coupon);

    Get.bottomSheet(
      EditCouponSheet(coupon: coupon),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.88.sh),
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
                            IconsaxPlusBold.edit_2,
                            color: AppColor.preimary,
                            size: 20.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "تعديل بيانات الكوبون #${coupon.couponId}",
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
                    hintText: "رمز / كود الكوبون",
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

                  // حقل اختيار تاريخ الانتهاء مع منتقي التقويم التفاعلي
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
                  SizedBox(height: 14.h),

                  // تبديل حالة الكوبون (نشط / معطل)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColor.background,
                      borderRadius: AppRadius.cardInner,
                      border: Border.all(color: AppColor.borderLight, width: 1.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "حالة تفعيل الكوبون",
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        Switch.adaptive(
                          value: controller.couponStatus == 1,
                          activeColor: AppColor.preimary,
                          onChanged: (val) {
                            controller.couponStatus = val ? 1 : 0;
                            controller.update();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Coustombuttom(
                    text: "حفظ التعديلات",
                    icon: IconsaxPlusBold.tick_circle,
                    onPressed: () => controller.editCoupon(),
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
