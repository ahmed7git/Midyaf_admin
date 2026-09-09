import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 📊 بطاقات إحصائيات حالات الطلبات الحية (Live Order Stats Grid)
class AdminStatBadgeGrid extends StatelessWidget {
  final AdminOrdersStatsModel stats;
  final Function(int statusIndex)? onCardTap;

  const AdminStatBadgeGrid({super.key, required this.stats, this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
       padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard(
          title: "بانتظار الموافقة",
          count: stats.pending,
          icon: IconsaxPlusBold.clock,
          color: const Color(0xFFD97706),
          bgColor: const Color(0xFFFEF3C7),
          onTap: () => onCardTap?.call(0),
        ),
        _buildStatCard(
          title: "قيد التجهيز بالمطبخ",
          count: stats.preparing,
          icon: IconsaxPlusBold.timer,
          color: AppColor.preimary,
          bgColor: AppColor.primaryLight,
          onTap: () => onCardTap?.call(1),
        ),
        _buildStatCard(
          title: "مع كابتن التوصيل",
          count: stats.onTheWay,
          icon: IconsaxPlusBold.truck_fast,
          color: const Color(0xFF2563EB),
          bgColor: const Color(0xFFEFF6FF),
          onTap: () => onCardTap?.call(2),
        ),
        _buildStatCard(
          title: "الطلبات المكتملة",
          count: stats.delivered,
          icon: IconsaxPlusBold.tick_circle,
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFECFDF5),
          onTap: () => onCardTap?.call(3),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.card,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: color.withValues(alpha: 0.18),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.04),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.badge,
                  ),
                  child: Icon(icon, color: color, size: 16.r),
                ),
                Text(
                  "$count",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColor.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
