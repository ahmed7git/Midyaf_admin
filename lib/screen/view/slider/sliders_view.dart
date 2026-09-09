import 'package:admin/applink.dart';
import 'package:admin/controller/slider/slider_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/sheets/add_slider_sheet.dart';
import 'package:admin/screen/widgets/sheets/edit_slider_sheet.dart';
import 'package:admin/screen/widgets/slider/slider_home_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 🖼️ شاشة إدارة السلايدر والعروض الترويجية مع معاينة حية مطابقة لتطبيق العميل (Delever Slider Hub)
class SlidersView extends StatelessWidget {
  const SlidersView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SliderControllerImp());

    return Scaffold(
      backgroundColor: AppColor.background,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 74.h),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.preimary.withValues(alpha: 0.28),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => AddSliderSheet.show(context),
            backgroundColor: AppColor.preimary,
            foregroundColor: Colors.white,
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
            icon: Icon(IconsaxPlusBold.add, size: 18.r),
            label: Text(
              "إضافة بانر",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<SliderControllerImp>(
        builder: (controller) => HandlingRequestView(
          onRetry: () => controller.getData(),
          staterequest: controller.staterequest,
          widget: RefreshIndicator(
            color: AppColor.preimary,
            backgroundColor: Colors.white,
            onRefresh: () async => controller.getData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. المعاينة الحية للسلايدر كما تظهر للعميل في تطبيق delever
                  if (controller.sliders.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المعاينة (تطبيق العميل)",
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                          
                          child: Text(
                            "مباشر",
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    SliderHomePreview(sliderData: controller.sliders),
                    SizedBox(height: 18.h),
                  ],

                  // 2. قائمة إدارة البانرات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "قائمة البانرات النشطة",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      Text(
                        "${controller.sliders.length} عروض",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 11.sp,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  if (controller.sliders.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconsaxPlusBold.gallery,
                              size: 48.r,
                              color: AppColor.textMuted,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "لا توجد بانرات أو عروض حالياً",
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 14.sp,
                                color: AppColor.textMuted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.sliders.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final slider = controller.sliders[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.card,
                            border: Border.all(color: AppColor.borderLight, width: 1.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.015),
                                blurRadius: 6.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Row(
                              children: [
                                // صورة البانر المصغرة
                                Container(
                                  width: 80.w,
                                  height: 52.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: AppColor.primaryLight,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: (slider.sliderImage != null && slider.sliderImage!.isNotEmpty)
                                      ? CachedNetworkImage(
                                          imageUrl: "${Applink.sliderImage}/${slider.sliderImage}",
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) => Icon(
                                            IconsaxPlusBold.gallery,
                                            size: 24.r,
                                            color: AppColor.preimary,
                                          ),
                                        )
                                      : Icon(
                                          IconsaxPlusBold.gallery,
                                          size: 24.r,
                                          color: AppColor.preimary,
                                        ),
                                ),
                                SizedBox(width: 12.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "بانر إعلاني #${slider.sliderId}",
                                        style: TextStyle(
                                          fontFamily: 'IBMPlexSansArabic',
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        slider.sliderImage ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Courier',
                                          fontSize: 10.5.sp,
                                          color: AppColor.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => EditSliderSheet.show(context, slider),
                                      icon: Icon(
                                        IconsaxPlusBold.edit_2,
                                        color: AppColor.preimary,
                                        size: 18.r,
                                      ),
                                      tooltip: "تغيير الصورة",
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.all(6.r),
                                    ),
                                    SizedBox(width: 4.w),
                                    IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "حذف البانر",
                                          middleText: "هل أنت متأكد من حذف هذا البانر الإعلاني؟",
                                          textConfirm: "نعم، حذف",
                                          textCancel: "إلغاء",
                                          confirmTextColor: Colors.white,
                                          buttonColor: const Color(0xFFEF4444),
                                          onConfirm: () {
                                            Get.back();
                                            controller.deleteSlider(
                                              slider.sliderId.toString(),
                                              slider.sliderImage,
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        IconsaxPlusBold.trash,
                                        color: Color(0xFFEF4444),
                                        size: 18,
                                      ),
                                      tooltip: "حذف العرض",
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.all(6.r),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
