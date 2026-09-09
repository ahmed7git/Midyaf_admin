import 'package:admin/controller/orders/orderdetils_contoller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/data/model/order_model.dart';
import 'package:admin/screen/widgets/common/sar_price_widget.dart';
import 'package:admin/screen/widgets/flowchart/order_lifecycle_flowchart.dart';
import 'package:admin/screen/widgets/order/order_customer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:latlong2/latlong.dart';

class Orderdetils extends StatelessWidget {
  const Orderdetils({super.key});

  @override
  Widget build(BuildContext context) { Get.put(OrderdetilsController());

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "مراقبة وتفاصيل الطلب",
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<OrderdetilsController>(
        builder: (controller) => HandlingRequestView(
          onRetry: () => controller.getdata(),
          staterequest: controller.staterequest,
          widget: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            children: [
              if (controller.listData.isNotEmpty)
                OrderLifecycleFlowchart(
                  currentStatus: controller.listData[0].orderStatus ?? 0,
                  isInteractive: true,
                  onStatusChange: (newStatus) {
                    Get.defaultDialog(
                      title: "تحديث مسار الطلب",
                      middleText: "هل تريد تحويل حالة الطلب إلى هذه المرحلة؟",
                      textConfirm: "تأكيد",
                      textCancel: "إلغاء",
                      confirmTextColor: Colors.white,
                      buttonColor: AppColor.preimary,
                      onConfirm: () {
                        Get.back();
                        controller.changeOrderStatus(newStatus);
                      },
                    );
                  },
                ),
              SizedBox(height: 14.h),

              // 👤 بطاقة بيانات العميل صاحب الطلب
              if (controller.listData.isNotEmpty) ...[
                OrderCustomerCard(order: controller.listData[0]),
                SizedBox(height: 14.h),
              ],

              _buildItemsList(context, controller),
              SizedBox(height: 14.h),

              if (controller.listData.isNotEmpty)
                _buildPriceSummary(context, controller),
              SizedBox(height: 14.h),

              if (controller.listData.isNotEmpty &&
                  controller.listData[0].addressLat != null &&
                  controller.listData[0].addressLat != 0.0) ...[
                _buildMapSection(controller.listData[0]),
                SizedBox(height: 14.h),
              ],

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton.icon(
                  onPressed: () => controller.goToTracking(),
                  icon: const Icon(IconsaxPlusBold.routing, size: 20),
                  label: Text(
                    "تتبع مسار المندوب والطلب على الخريطة",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.preimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.button,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, OrderdetilsController controller) {
    final items = controller.listData;
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(IconsaxPlusBold.box_1, color: AppColor.preimary, size: 18.r),
              SizedBox(width: 8.w),
              Text(
                "الأصناف المطلوبة (${items.length})",
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ListView.separated(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade100,
              height: 16.h,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.primaryLight,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      "${item.cartCount ?? 1}x",
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.preimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      item.itemsNameAr ?? item.itemsName ?? "",
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ),
                  SarPriceWidget(
                    price: item.itemRowTotal,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                    symbolColor: AppColor.textPrimary,
                    symbolSize: 11.r,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(
      BuildContext context, OrderdetilsController controller) {
    final order = controller.listData[0];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
      ),
      child: Column(
        children: [
          _buildSummaryRowPrice("سعر الأصناف", order.orderPrice ?? 0),
          SizedBox(height: 8.h),
          _buildSummaryRowPrice("رسوم التوصيل", order.orderDelivery ?? 0),
          if (order.couponDiscount != null && order.couponDiscount! > 0) ...[
            SizedBox(height: 8.h),
            _buildSummaryRowPrice("الخصم", order.couponDiscount!, isDiscount: true),
          ],
          Divider(color: AppColor.borderLight, height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الإجمالي النهائي",
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),
              SarPriceWidget(
                price: order.totalForDisplay,
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColor.preimary,
                ),
                symbolColor: AppColor.preimary,
                symbolSize: 14.r,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRowPrice(String label, dynamic value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 12.5.sp,
            color: AppColor.textSecondary,
          ),
        ),
        SarPriceWidget(
          price: value,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: isDiscount ? const Color(0xFF10B981) : AppColor.textPrimary,
          ),
          symbolColor: isDiscount ? const Color(0xFF10B981) : AppColor.textPrimary,
          symbolSize: 11.r,
        ),
      ],
    );
  }

  Widget _buildMapSection(OrderModel order) {
    final LatLng location = LatLng(order.addressLat!, order.addressLong!);

    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: location,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.admin',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: location,
                    width: 40.r,
                    height: 40.r,
                    child: const Icon(
                      IconsaxPlusBold.location,
                      color: AppColor.preimary,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: AppRadius.badge,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(IconsaxPlusBold.location, size: 14, color: AppColor.preimary),
                  SizedBox(width: 4.w),
                  Text(
                    "موقع تسليم العميل",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
