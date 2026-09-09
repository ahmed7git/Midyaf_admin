import 'package:admin/applink.dart';
import 'package:admin/controller/items/viewitem_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/common/sar_price_widget.dart';
import 'package:admin/screen/widgets/sheets/add_item_sheet.dart';
import 'package:admin/screen/widgets/sheets/edit_item_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    Get.isRegistered<ViewItemsControllerImp>()
        ? Get.find<ViewItemsControllerImp>()
        : Get.put(ViewItemsControllerImp());

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
            onPressed: () => AddItemSheet.show(context),
            backgroundColor: AppColor.preimary,
            foregroundColor: Colors.white,
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
            icon: Icon(IconsaxPlusBold.add, size: 18.r),
            label: Text(
              "إضافة منتج",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<ViewItemsControllerImp>(
        builder: (controller) => HandlingRequestView(
          onRetry: () => controller.getData(),
          staterequest: controller.staterequest,
          widget: controller.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusBold.box_1,
                        size: 48.r,
                        color: AppColor.textMuted,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "لا توجد منتجات مسجلة حالياً",
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
                      vertical: 12.h,
                    ),
                    itemCount: controller.items.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      final int stockCount = int.tryParse(item.itemsCount.toString()) ?? 0;
                      final bool isLowStock = stockCount > 0 && stockCount <= 5;
                      final bool isOutOfStock = stockCount == 0;
                      final bool hasDiscount = item.itemsDiscount.toString() != "0" &&
                          item.itemsDiscount.toString().isNotEmpty;

                      // تحديد لون ونص حالة المخزون
                      final Color statusColor = isOutOfStock
                          ? const Color(0xFFEF4444)
                          : isLowStock
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF10B981);

                      final String statusText = isOutOfStock
                          ? "نفد"
                          : isLowStock
                              ? "منخفض"
                              : "متوفر";

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.card,
                          border: Border.all(
                            color: isOutOfStock
                                ? AppColor.danger.withValues(alpha: 0.3)
                                : AppColor.borderLight,
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Row(
                            children: [
                              // حاوية الصورة مع شارة الخصم العائمة
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 60.r,
                                    height: 60.r,
                                    decoration: BoxDecoration(
                                      
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: CachedNetworkImage(
                                        imageUrl: "${Applink.itemsImage}/${item.itemsImages}",
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                        errorWidget: (context, url, error) => Icon(
                                          IconsaxPlusBold.box_1,
                                          size: 24.r,
                                          color: AppColor.preimary.withValues(alpha: 0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (hasDiscount)
                                    Positioned(
                                      top: -4.h,
                                      right: -4.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                          vertical: 1.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.preimary,
                                          borderRadius: BorderRadius.circular(6.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              blurRadius: 4.r,
                                              offset: Offset(0, 2.h),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          "-${item.itemsDiscount}%",
                                          style: TextStyle(
                                            fontFamily: 'IBMPlexSansArabic',
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(width: 12.w),

                              // تفاصيل الوجبة
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.itemsNameAr.isNotEmpty
                                          ? item.itemsNameAr
                                          : item.itemsName,
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 3.h),
                                    SarPriceWidget(
                                      price: item.itemsPrice,
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColor.preimary,
                                      ),
                                      symbolColor: AppColor.preimary,
                                      symbolSize: 12.r,
                                    ),
                                    SizedBox(height: 3.h),
                                    // سطر المخزون مع الحالة الملونة مباشرة بدون خلفية
                                    Row(
                                      children: [
                                        Text(
                                          "المخزون: $stockCount قطعة",
                                          style: TextStyle(
                                            fontFamily: 'IBMPlexSansArabic',
                                            fontSize: 11.sp,
                                            color: AppColor.textSecondary,
                                          ),
                                        ),
                                        Text(
                                          "  •  ",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: AppColor.textMuted,
                                          ),
                                        ),
                                        Text(
                                          statusText,
                                          style: TextStyle(
                                            fontFamily: 'IBMPlexSansArabic',
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // أزرار التحكم
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => EditItemSheet.show(context, item),
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
                                        title: "حذف الصنف",
                                        middleText: "هل أنت متأكد من رغبتك في حذف هذا المنتج نهائياً؟",
                                        textConfirm: "نعم، حذف",
                                        textCancel: "إلغاء",
                                        confirmTextColor: Colors.white,
                                        buttonColor: const Color(0xFFEF4444),
                                        onConfirm: () {
                                          Get.back();
                                          controller.deleteitem(
                                            item.itemsId.toString(),
                                            item.itemsImages,
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