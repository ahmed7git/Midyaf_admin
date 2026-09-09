import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/data/model/order_model.dart';
import 'package:admin/screen/widgets/common/sar_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';

/// 🧾 كروت أحدث الطلبات الواردة بتصميم مينيمال أنيق ومقلل الأيقونات (Recent Orders List)
class AdminRecentOrdersList extends StatelessWidget {
  final List<OrderModel> recentOrders;
  final Function(OrderModel order)? onOrderTap;

  const AdminRecentOrdersList({
    super.key,
    required this.recentOrders,
    this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recentOrders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "أحدث الطلبات الواردة",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 13.5.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            Text(
              "${recentOrders.length} طلبات",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ListView.separated(
          itemCount: recentOrders.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final order = recentOrders[index];
            final String timeAgo = (order.orderCreated != null)
                ? Jiffy.parse(order.orderCreated!).fromNow()
                : "";

            return InkWell(
              onTap: () => onOrderTap?.call(order),
              borderRadius: AppRadius.card,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColor.borderLight, width: 1.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.012),
                      blurRadius: 6.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // رقم الطلب والتوقيت
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "طلب #${order.orderId}",
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textPrimary,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _buildStatusBadge(order.orderStatus ?? 0),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 10.5.sp,
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // إجمالي السعر مع العملة
                    SarPriceWidget(
                      price: order.orderTotalprice ?? 0,
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColor.preimary,
                      ),
                      symbolColor: AppColor.preimary,
                      symbolSize: 12.r,
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.r,
                      color: AppColor.textMuted,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusBadge(int status) {
    String label;
    Color color;
    Color bgColor;

    switch (status) {
      case 0:
        label = "جديد";
        color = const Color(0xFFD97706);
        bgColor = const Color(0xFFFEF3C7);
        break;
      case 1:
        label = "قيد التجهيز";
        color = AppColor.preimary;
        bgColor = AppColor.primaryLight;
        break;
      case 2:
        label = "جاهز";
        color = AppColor.preimary;
        bgColor = AppColor.primaryLight;
        break;
      case 3:
        label = "مع المندوب";
        color = const Color(0xFF2563EB);
        bgColor = const Color(0xFFEFF6FF);
        break;
      case 4:
        label = "مكتمل";
        color = const Color(0xFF059669);
        bgColor = const Color(0xFFECFDF5);
        break;
      default:
        label = "ملغي";
        color = const Color(0xFFDC2626);
        bgColor = const Color(0xFFFEE2E2);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.radiusFull,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 9.5.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
