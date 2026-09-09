import 'package:admin/applink.dart';
import 'package:admin/controller/slider/slider_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/data/model/slider_model.dart';
import 'package:admin/screen/widgets/auth/coustombuttom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 🖼️ شيت تعديل صورة البانر (Edit Slider Bottom Sheet)
class EditSliderSheet extends StatelessWidget {
  final SliderModel slider;
  const EditSliderSheet({super.key, required this.slider});

  static void show(BuildContext context, SliderModel slider) {
    final controller = Get.isRegistered<SliderControllerImp>()
        ? Get.find<SliderControllerImp>()
        : Get.put(SliderControllerImp());
    controller.initEdit(slider);

    Get.bottomSheet(
      EditSliderSheet(slider: slider),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.78.sh),
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
                          IconsaxPlusBold.edit_2,
                          color: AppColor.preimary,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "تعديل صورة البانر #${slider.sliderId}",
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
                                      "تم تحديد صورة جديدة",
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
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: "${Applink.sliderImage}/${slider.sliderImage}",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Icon(
                                IconsaxPlusBold.gallery,
                                size: 40.r,
                                color: AppColor.preimary,
                              ),
                            ),
                            Container(
                              color: Colors.black.withValues(alpha: 0.3),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: AppRadius.radiusFull,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(IconsaxPlusBold.gallery_edit, size: 16.r, color: AppColor.preimary),
                                      SizedBox(width: 6.w),
                                      Text(
                                        "اضغط لتغيير الصورة",
                                        style: TextStyle(
                                          fontFamily: 'IBMPlexSansArabic',
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.preimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 24.h),

              Coustombuttom(
                text: "حفظ صورة البانر",
                icon: IconsaxPlusBold.tick_circle,
                onPressed: () => controller.editSlider(),
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}
