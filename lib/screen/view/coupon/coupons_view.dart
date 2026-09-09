import 'package:admin/controller/coupon/coupon_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/coupon/coupon_ticket_card.dart';
import 'package:admin/screen/widgets/sheets/add_coupon_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 🏷️ شاشة إدارة كوبونات الخصم بتصميم قسائم الشراء التفاعلية الملونة حسب الحالة
class CouponsView extends StatelessWidget {
  const CouponsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CouponControllerImp());

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
            onPressed: () => AddCouponSheet.show(context),
            backgroundColor: AppColor.preimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
            elevation: 2,
            highlightElevation: 0,
            icon: Icon(IconsaxPlusBold.add, size: 18.r),
            label: Text(
              "إضافة كوبون",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<CouponControllerImp>(
        builder: (controller) => HandlingRequestView(
          onRetry: () => controller.getData(),
          staterequest: controller.staterequest,
          widget: controller.coupons.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusBold.ticket_discount,
                        size: 48.r,
                        color: AppColor.textMuted,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "لا توجد كوبونات خصم حالياً",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 14.sp,
                          color: AppColor.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "اضغط على الزر أدناه لإضافة أول قسيمة خصم",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 11.5.sp,
                          color: AppColor.textSecondary,
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
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                    itemCount: controller.coupons.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final coupon = controller.coupons[index];

                      return CouponTicketCard(
                        coupon: coupon,
                        onDelete: () {
                          controller.deleteCoupon(coupon.couponId.toString());
                        },
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
