import 'package:admin/controller/orders/orderaccrpted_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/common/sar_price_widget.dart';
import 'package:admin/screen/widgets/order/order_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:jiffy/jiffy.dart';

class Completorder extends StatelessWidget {
  const Completorder({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderaccptedController());

    return GetBuilder<OrderaccptedController>(
      builder: (controller) => HandlingRequestView(
        onRetry: () => controller.getdata(),
        staterequest: controller.staterequest,
        widget: controller.completedOrders.isEmpty
            ? Center(
                child: Text(
                  "لا توجد طلبات مكتملة حالياً",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 14.sp,
                    color: AppColor.textMuted,
                  ),
                ),
              )
            : RefreshIndicator(
                color: AppColor.preimary,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  await controller.getdata();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  itemCount: controller.completedOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.completedOrders[index];
                    final String timeAgo = (order.orderCreated != null)
                        ? Jiffy.parse(order.orderCreated!).fromNow()
                        : "";

                    return Container(
                      margin: EdgeInsets.only(bottom: 14.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.card,
                        border: Border.all(
                          color: AppColor.borderLight,
                          width: 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10.r,
                            offset: Offset(0, 3.h),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "#${order.orderId}",
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    color: AppColor.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  timeAgo,
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    color: AppColor.textSecondary,
                                    fontSize: 11.5.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryLight,
                                    borderRadius: AppRadius.radiusFull,
                                    border: Border.all(
                                      color: AppColor.primaryBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Text(
                                    "مكتمل",
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.preimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Divider(color: AppColor.borderLight, height: 1.h),
                            SizedBox(height: 12.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "طريقة الدفع: ${controller.printPaymentmethod(order.orderPaymentmethod.toString())}",
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 12.sp,
                                        color: AppColor.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "نوع التوصيل: ${controller.printOrderType(order.orderType.toString())}",
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 12.sp,
                                        color: AppColor.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "الإجمالي المسدد",
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 11.sp,
                                        color: AppColor.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    SarPriceWidget(
                                      price: order.totalForDisplay,
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColor.preimary,
                                      ),
                                      symbolColor: AppColor.preimary,
                                      symbolSize: 13.r,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 14.h),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  OrderDetailsSheet.show(
                                    context,
                                    orderId: "${order.orderId}",
                                    fallbackOrder: order,
                                  );
                                },
                                icon: Icon(
                                  IconsaxPlusBold.document_text,
                                  size: 16.r,
                                  color: AppColor.preimary,
                                ),
                                label: Text(
                                  "عرض الفاتورة والمخطط",
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColor.primaryBorder),
                                  foregroundColor: AppColor.preimary,
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.button,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
