import 'package:admin/applink.dart';
import 'package:admin/controller/items/edititem_controller.dart';
import 'package:admin/controller/items/viewitem_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/core/functions/validinput.dart';
import 'package:admin/data/model/itemsmodel.dart';
import 'package:admin/screen/widgets/auth/coustombuttom.dart';
import 'package:admin/screen/widgets/auth/customtextinput.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 📦 شيت تعديل بيانات المنتج والمخزون (Edit Item Bottom Sheet)
class EditItemSheet extends StatelessWidget {
  final ItemsModel item;

  const EditItemSheet({super.key, required this.item});

  static void show(BuildContext context, ItemsModel item) {
    Get.bottomSheet(
      EditItemSheet(item: item),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<EditItemControllerImp>()) {
      Get.delete<EditItemControllerImp>(force: true);
    }
    final controller = Get.put(EditItemControllerImp());
    controller.initData(item);

    return Container(
      constraints: BoxConstraints(maxHeight: 0.90.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.bottomSheet,
      ),
      child: GetBuilder<EditItemControllerImp>(
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
                              IconsaxPlusBold.edit_2,
                              color: AppColor.preimary,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "تعديل بيانات المنتج",
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

                  // 1. معاينة وتغيير صورة المنتج
                  Center(
                    child: GestureDetector(
                      onTap: () => controller.chooseFile(),
                      child: Container(
                        width: 90.r,
                        height: 90.r,
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
                            ? Image.file(controller.file!, fit: BoxFit.cover)
                            : CachedNetworkImage(
                                imageUrl: "${Applink.itemsImage}/${item.itemsImages}",
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(IconsaxPlusBold.gallery_edit, size: 28.r, color: AppColor.preimary),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "تغيير الصورة",
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
                  ),
                  SizedBox(height: 6.h),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => controller.chooseFile(),
                      icon: const Icon(IconsaxPlusBold.gallery_edit, size: 16, color: AppColor.preimary),
                      label: Text(
                        controller.file != null ? "تم تحديد صورة جديدة" : "تغيير صورة المنتج",
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

                  // 2. اختيار القسم التابع له
                  if (controller.categories.isNotEmpty) ...[
                    Text(
                      "اختر القسم التابع له المنتج:",
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 38.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.categories.length,
                        separatorBuilder: (context, index) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final cat = controller.categories[index];
                          final isSelected = controller.itemscategories.text == cat.categoriesId.toString();

                          return GestureDetector(
                            onTap: () => controller.selectCategory(cat),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColor.preimary : AppColor.primaryLight,
                                borderRadius: AppRadius.radiusFull,
                                border: Border.all(
                                  color: isSelected ? AppColor.preimary : AppColor.primaryBorder,
                                  width: 1.w,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  cat.categoriesNameAr ?? cat.categoriesName ?? "",
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 11.5.sp,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColor.preimary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 14.h),
                  ],

                  // 3. اسم المنتج
                  Customtextinput(
                    isPassword: false,
                    isNumber: false,
                    valid: (val) => validInput(val!, 50, 2, "name"),
                    hintText: "اسم المنتج بالعربي",
                    iconData: IconsaxPlusBroken.box_1,
                    mycontroller: controller.itemsNameAr,
                  ),
                  SizedBox(height: 10.h),

                  Customtextinput(
                    isPassword: false,
                    isNumber: false,
                    valid: (val) => validInput(val!, 50, 2, "name"),
                    hintText: "اسم المنتج بالإنجليزي",
                    iconData: IconsaxPlusBroken.box,
                    mycontroller: controller.itemsName,
                  ),
                  SizedBox(height: 10.h),

                  // 4. السعر والخصم والمخزون
                  Row(
                    children: [
                      Expanded(
                        child: Customtextinput(
                          isPassword: false,
                          isNumber: true,
                          valid: (val) => validInput(val!, 10, 1, "number"),
                          hintText: "السعر",
                          iconData: IconsaxPlusBroken.wallet_3,
                          mycontroller: controller.itemsprice,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Customtextinput(
                          isPassword: false,
                          isNumber: true,
                          valid: (val) => validInput(val!, 10, 0, "number"),
                          hintText: "الخصم %",
                          iconData: IconsaxPlusBroken.percentage_circle,
                          mycontroller: controller.itemsdiscount,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  Customtextinput(
                    isPassword: false,
                    isNumber: true,
                    valid: (val) => validInput(val!, 10, 0, "number"),
                    hintText: "كمية المخزون",
                    iconData: IconsaxPlusBroken.box_time,
                    mycontroller: controller.itemscount,
                  ),
                  SizedBox(height: 10.h),

                  // 5. الوصف
                  Customtextinput(
                    isPassword: false,
                    isNumber: false,
                    valid: (val) => validInput(val!, 200, 2, "name"),
                    hintText: "وصف المنتج بالعربي",
                    iconData: IconsaxPlusBroken.document_text,
                    mycontroller: controller.itemsdescrAr,
                  ),
                  SizedBox(height: 20.h),

                  // 6. زر الحفظ
                  Coustombuttom(
                    text: "حفظ التعديلات",
                    icon: IconsaxPlusBold.tick_circle,
                    onPressed: () async {
                      await controller.addData();
                      if (Get.isRegistered<ViewItemsControllerImp>()) {
                        Get.find<ViewItemsControllerImp>().getData();
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
