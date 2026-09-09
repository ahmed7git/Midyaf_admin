import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_images.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// 🚚 كرت مراقبة أسطول التوصيل والمناديب بتصميم احترافي مبسط (Delivery Fleet Card)
class FleetLifecycleFlowchart extends StatelessWidget {
  final int activeDriversCount;
  final VoidCallback? onManageDrivers;

  const FleetLifecycleFlowchart({
    super.key,
    required this.activeDriversCount,
    this.onManageDrivers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // رأس الكرت
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                    SizedBox(width:16.w ,),
                LottieBuilder.asset(AppImages.deli, height: 40, width: 40 ,fit: BoxFit.cover,),
                
                Transform.translate(
                    offset: Offset(5.h, 0.h),
                    child: Text(
                      "حالة أسطول التوصيل",
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
              if (onManageDrivers != null)
                GestureDetector(
                  onTap: onManageDrivers,
                  child: Text(
                    "إدارة المناديب",
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

          // شبكة الإحصائيات المباشرة للأسطول
          Row(
            children: [
              Expanded(
                child: _buildFleetStatTile(
                  label: "الكباتن المتصلين",
                  value: "$activeDriversCount",
                  sublabel: "جاهز لتلقي الطلبات",
                  isActive: true,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildFleetStatTile(
                  label: "كفاءة التوصيل",
                  value: "98%",
                  sublabel: "معدل الإنجاز في الوقت",
                  isActive: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFleetStatTile({
    required String label,
    required String value,
    required String sublabel,
    required bool isActive,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: AppRadius.cardInner,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 11.sp,
                  color: AppColor.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isActive)
                Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            sublabel,
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 9.5.sp,
              color: AppColor.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
