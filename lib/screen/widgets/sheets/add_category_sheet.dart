import 'package:admin/controller/category/addcate_controller.dart';
import 'package:admin/controller/category/viewcate_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/core/functions/validinput.dart';
import 'package:admin/screen/widgets/auth/coustombuttom.dart';
import 'package:admin/screen/widgets/auth/customtextinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 📂 شيت إضافة قسم جديد بتصميم مودرن (Add Category Bottom Sheet)
class AddCategorySheet extends StatelessWidget {
  const AddCategorySheet({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      const AddCategorySheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<AddcateControllerImp>()) {
      Get.delete<AddcateControllerImp>(force: true);
    }
    Get.put(AddcateControllerImp());

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.bottomSheet,
      ),
      child: GetBuilder<AddcateControllerImp>(
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
                              IconsaxPlusBold.folder_add,
                              color: AppColor.preimary,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "إضافة قسم جديد",
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

                  // 1. اختيار صورة القسم
                  Center(
                    child: GestureDetector(
                      onTap: () => controller.chooseFile(),
                      child: Container(
                        width: 90.r,
                        height: 90.r,
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColor.primaryLight,
                          borderRadius: AppRadius.card,
                          border: Border.all(
                            color: controller.file != null ? AppColor.preimary : AppColor.primaryBorder,
                            width: 1.5.w,
                          ),
                        ),
                        child: controller.file != null
                            ? SvgPicture.file(controller.file!)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(IconsaxPlusBold.gallery_add, size: 28.r, color: AppColor.preimary),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "صورة القسم",
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.preimary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => controller.chooseFile(),
                      icon: const Icon(IconsaxPlusBold.gallery_add, size: 16, color: AppColor.preimary),
                      label: Text(
                        controller.file != null ? "تغيير الصورة المحددة" : "اختيار صورة القسم (SVG)",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.preimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // 2. الحقول النصية
                  Customtextinput(
                    isPassword: false,
                    isNumber: false,
                    valid: (val) => validInput(val!, 30, 2, "name"),
                    hintText: "اسم القسم بالعربي",
                    iconData: IconsaxPlusBroken.category,
                    mycontroller: controller.categoriesNameAr,
                  ),
                  SizedBox(height: 12.h),

                  Customtextinput(
                    isPassword: false,
                    isNumber: false,
                    valid: (val) => validInput(val!, 30, 2, "name"),
                    hintText: "اسم القسم بالإنجليزي",
                    iconData: IconsaxPlusBroken.category_2,
                    mycontroller: controller.categoriesName,
                  ),
                  SizedBox(height: 20.h),

                  // 3. زر الحفظ
                  Coustombuttom(
                    text: "إضافة القسم",
                    icon: IconsaxPlusBold.add_circle,
                    onPressed: () async {
                      await controller.addData();
                      if (Get.isRegistered<ViewcateControllerImp>()) {
                        Get.find<ViewcateControllerImp>().getData();
                      }
                    },
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
