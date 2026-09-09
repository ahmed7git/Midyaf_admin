import 'package:admin/applink.dart';
import 'package:admin/controller/category/viewcate_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/sheets/add_category_sheet.dart';
import 'package:admin/screen/widgets/sheets/edit_category_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
     Get.put(ViewcateControllerImp());

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
            onPressed: () => AddCategorySheet.show(context),
            backgroundColor: AppColor.preimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
            elevation: 2,
            highlightElevation: 0,
            icon: Icon(IconsaxPlusBold.add, size: 18.r),
            label: Text(
              "إضافة قسم",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<ViewcateControllerImp>(
        builder: (controller) => HandlingRequestView(
          onRetry: () => controller.getData(),
          staterequest: controller.staterequest,
          widget: controller.categories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusBold.category,
                        size: 48.r,
                        color: AppColor.textMuted,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "لا توجد أقسام مسجلة حالياً",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 14.sp,
                          color: AppColor.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: AppColor.preimary,
                  backgroundColor: Colors.white,
                  onRefresh: () async => controller.getData(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 4.h,
                    ),
                    itemCount: controller.categories.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.card,
                          border: Border.all(
                            color: AppColor.borderLight,
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.015),
                              blurRadius: 6.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Row(
                            children: [
                              // صورة القسم
                              Container(
                                width: 70.r,
                                height: 55.r,
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  borderRadius: AppRadius.cardInner,
                                ),
                                child: (category.categoriesImage != null &&
                                        category.categoriesImage!.endsWith('.svg'))
                                    ? SvgPicture.network(
                                        "${Applink.categoriesImage}/${category.categoriesImage}",
                                        fit: BoxFit.cover,
                                        height: 24,
                                        width: 24,
                                        placeholderBuilder: (context) => Center(
                                          child: SizedBox(
                                            width: 18.r,
                                            height: 18.r,
                                            child: const CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        ),
                                      )
                                    : (category.categoriesImage != null && category.categoriesImage!.isNotEmpty)
                                        ? Image.network(
                                            "${Applink.categoriesImage}/${category.categoriesImage}",
                                            fit: BoxFit.contain,
                                            height: 20,
                                            width: 20,
                                            errorBuilder: (context, error, stackTrace) => Icon(
                                              IconsaxPlusBold.category,
                                              size: 24.r,
                                              color: AppColor.preimary,
                                            ),
                                          )
                                        : Icon(
                                            IconsaxPlusBold.category,
                                            size: 24.r,
                                            color: AppColor.preimary,
                                          ),
                              ),
                              SizedBox(width: 14.w),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.categoriesNameAr ?? category.categoriesName ?? "",
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "معرف القسم: #${category.categoriesId ?? index}",
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 11.sp,
                                        color: AppColor.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => EditCategorySheet.show(context, category),
                                    icon: Icon(
                                      IconsaxPlusBold.edit_2,
                                      color: AppColor.preimary,
                                      size: 18.r,
                                    ),
                                    tooltip: "تعديل",
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.all(6.r),
                                  ),
                                  SizedBox(width: 4.w),
                                  IconButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "حذف القسم",
                                        middleText:
                                            "هل أنت متأكد من رغبتك في حذف هذا القسم نهائياً؟",
                                        textConfirm: "نعم، حذف",
                                        textCancel: "إلغاء",
                                        confirmTextColor: Colors.white,
                                        buttonColor: const Color(0xFFEF4444),
                                        onConfirm: () {
                                          Get.back();
                                          controller.deletecate(
                                            category.categoriesId.toString(),
                                            category.categoriesImage!,
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      IconsaxPlusBold.trash,
                                      color: Color(0xFFEF4444),
                                      size: 18,
                                    ),
                                    tooltip: "حذف",
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
                  
                ),
        ),
      ),
    );
  }
}
