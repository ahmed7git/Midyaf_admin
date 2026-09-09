import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_images.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 📦 كرت مؤشرات وصحة حركة المخزون بتصميم احترافي مبسط ومحمي ضد تشوه الـ Skeletonizer
class StockMovementFlowchart extends StatelessWidget {
  final int inStockCount;
  final int lowStockCount;
  final int outOfStockCount;
  final VoidCallback? onManageStock;

  const StockMovementFlowchart({
    super.key,
    required this.inStockCount,
    required this.lowStockCount,
    required this.outOfStockCount,
    this.onManageStock,
  });

  @override
  Widget build(BuildContext context) {
    final int total = inStockCount + lowStockCount + outOfStockCount;

    return Skeleton.ignore(
      ignore: true,
      child: Container(
        padding: EdgeInsets.all(14.r),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LottieBuilder.asset(
                      AppImages.stock,
                      height: 28.h,
                      width: 36.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        "صحة وحركة المخزون",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (onManageStock != null)
                  GestureDetector(
                    onTap: onManageStock,
                    child: Text(
                      "إدارة الأصناف",
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.preimary,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),

            // شريط النسبة الإجمالية للمخزون
            if (total > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: SizedBox(
                  height: 6.h,
                  child: Row(
                    children: [
                      if (inStockCount > 0)
                        Expanded(
                          flex: inStockCount,
                          child: Container(color: AppColor.preimary),
                        ),
                      if (lowStockCount > 0)
                        Expanded(
                          flex: lowStockCount,
                          child: Container(color: const Color(0xFFF59E0B)),
                        ),
                      if (outOfStockCount > 0)
                        Expanded(
                          flex: outOfStockCount,
                          child: Container(color: const Color(0xFFEF4444)),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],

            // كروت الأرقام الثلاثة
            Row(
              children: [
                Expanded(
                  child: _buildStockStatTile(
                    label: "متوفر",
                    value: "$inStockCount",
                    color: AppColor.preimary,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStockStatTile(
                    label: "منخفض",
                    value: "$lowStockCount",
                    color: const Color(0xFFD97706),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStockStatTile(
                    label: "نفد",
                    value: "$outOfStockCount",
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockStatTile({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: AppRadius.cardInner,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: 5.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: AppColor.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
