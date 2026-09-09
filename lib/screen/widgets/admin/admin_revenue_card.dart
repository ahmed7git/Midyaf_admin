import 'package:admin/controller/admin/admin_dashboard_controller.dart';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:admin/screen/widgets/common/sar_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 💳 كرت الإيرادات المالي الفاخر بتصميم البطاقة البنكية مع حماية المظهر عند التحميل
class AdminRevenueCard extends StatelessWidget {
  final AdminOverviewModel overview;

  const AdminRevenueCard({
    super.key,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.isRegistered<AdminDashboardControllerImp>()
        ? Get.find<AdminDashboardControllerImp>()
        : null;

    final String adminName = dashboardController?.adminName.isNotEmpty == true
        ? dashboardController!.adminName.toUpperCase()
        : "EXECUTIVE ADMIN";

    return Skeleton.ignore(
      ignore: true,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF991B1B), // عنابي داكن فخم
              Color(0xFF7F1D1D), // عنابي ملكي
              Color(0xFF450A0A), // تيتانيوم داكن
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7F1D1D).withValues(alpha: 0.35),
              blurRadius: 20.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 1. الدوائر الهولوجرافية في خلفية البطاقة
            Positioned(
              right: -30.w,
              top: -30.h,
              child: Container(
                width: 140.r,
                height: 140.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              left: -20.w,
              bottom: -20.h,
              child: Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),

            // 2. المحتوى الداخلي للبطاقة البنكية
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الترويسة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "ADMIN PLATINUM",
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              "BUSINESS",
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 8.5.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        IconsaxPlusBold.wifi,
                        size: 20.r,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // رسم الشريحة الإلكترونية الذهبية (EMV Chip)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildGoldEmvChip(),
                      // شارة النمو
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              IconsaxPlusBold.trend_up,
                              size: 13.r,
                              color: const Color(0xFF34D399),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "+${overview.growthPercentage}% نمو",
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF34D399),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // نص الرصيد
                  Text(
                    "إجمالي الإيرادات المحققة",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 11.5.sp,
                      color: Colors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // العداد المتحرك للريال السعودي بـ SarPriceWidget
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: overview.totalRevenue),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedValue, child) {
                      return SarPriceWidget(
                        price: animatedValue,
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        symbolColor: Colors.white,
                        symbolSize: 18.r,
                      );
                    },
                  ),

                  SizedBox(height: 16.h),

                  // الخط السفلي للبطاقة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "••••  ••••  ••••  2026",
                              style: TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              adminName,
                              style: TextStyle(
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.9),
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // إحصائيات سريعة للطلبات ومتوسط السلة بـ SarPriceWidget
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCardSubMetric(
                            label: "الطلبات",
                            value: "${overview.totalOrders}",
                          ),
                          SizedBox(width: 12.w),
                          _buildCardSubMetricPrice(
                            label: "متوسط السلة",
                            price: overview.averageOrderValue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🪙 رسم الشريحة الإلكترونية الذهبية (EMV Microchip)
  Widget _buildGoldEmvChip() {
    return Container(
      width: 42.w,
      height: 32.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFDF7A),
            Color(0xFFD4AF37),
            Color(0xFFA67C00),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: const Color(0xFF8A6500),
          width: 0.7.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 3.r,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12.w,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1.w,
              color: const Color(0xFF8A6500).withValues(alpha: 0.6),
            ),
          ),
          Positioned(
            right: 12.w,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1.w,
              color: const Color(0xFF8A6500).withValues(alpha: 0.6),
            ),
          ),
          Center(
            child: Container(
              width: 16.w,
              height: 14.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(
                  color: const Color(0xFF8A6500).withValues(alpha: 0.7),
                  width: 0.8.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSubMetric({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 9.sp,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 11.5.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCardSubMetricPrice({
    required String label,
    required double price,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 9.sp,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 1.h),
        SarPriceWidget(
          price: price,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 11.5.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          symbolColor: Colors.white,
          symbolSize: 10.r,
        ),
      ],
    );
  }
}
