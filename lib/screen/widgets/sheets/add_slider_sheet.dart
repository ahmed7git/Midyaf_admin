import 'package:admin/controller/slider/slider_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/auth/coustombuttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 🖼️ شيت إضافة بانر إعلاني جديد (Add Slider Bottom Sheet)
class AddSliderSheet extends StatelessWidget {
  const AddSliderSheet({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      const AddSliderSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SliderControllerImp>()) {
      Get.put(SliderControllerImp());
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 0.75.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.bottomSheet,
      ),
      child: GetBuilder<SliderControllerImp>(
        builder: (controller) => HandlingRequest(
          staterequest: controller.staterequest,
          widget: Column(
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
                          IconsaxPlusBold.gallery_add,
                          color: AppColor.preimary,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "إضافة بانر وسلايدر جديد",
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

              // منطقة رفع الصورة ومعاينتها
              GestureDetector(
                onTap: () => controller.chooseFile(),
                child: Container(
                  width: double.infinity,
                  height: 160.h,
                  decoration: BoxDecoration(
                    color: AppColor.primaryLight,
                    borderRadius: AppRadius.card,
                    border: Border.all(
                      color: controller.file != null ? AppColor.preimary : AppColor.primaryBorder,
                      width: 1.5.w,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: controller.file != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(controller.file!, fit: BoxFit.cover),
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: AppRadius.radiusFull,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(IconsaxPlusBold.edit_2, size: 12.r, color: Colors.white),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "تغيير الصورة",
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 10.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconsaxPlusBold.gallery_add, size: 40.r, color: AppColor.preimary),
                            SizedBox(height: 8.h),
                            Text(
                              "اضغط هنا لرفع صورة البانر الإعلاني",
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.preimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "يفضل الأبعاد العريضة (16:9) للحصول على أفضل عرض",
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 10.5.sp,
                                color: AppColor.textSecondary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 24.h),

              Coustombuttom(
                text: "حفظ ونشر البانر",
                icon: IconsaxPlusBold.tick_circle,
                onPressed: () => controller.addSlider(),
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}
