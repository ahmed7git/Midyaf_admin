import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/services/export_service.dart';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 📥 نافذة تصدير التقارير والبيانات (Export Reports Bottom Sheet)
class ExportReportSheet extends StatelessWidget {
  final AdminDashboardModel? dashboardData;

  const ExportReportSheet({super.key, this.dashboardData});

  static void show(BuildContext context, {AdminDashboardModel? dashboardData}) {
    Get.bottomSheet(
      ExportReportSheet(dashboardData: dashboardData),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.bottomSheet,
      ),
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
          SizedBox(height: 16.h),

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
                  IconsaxPlusBold.document_download,
                  color: AppColor.preimary,
                  size: 20,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تصدير ومشاركة التقارير",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  Text(
                    "اختر نوع وصيغة الملف المطلوب تصديره",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 11.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // 1. تصدير كملف Excel (CSV)
          _buildExportOption(
            title: "تصدير تقرير الإيرادات والعمليات (Excel / CSV)",
            subtitle: "جدول بيانات متكامل لجميع المبيعات والمخزون والطلبات",
            icon: IconsaxPlusBold.document_text_1,
            color: const Color(0xFF057A55),
            bgColor: const Color(0xFFF0FDF4),
            onTap: () {
              Get.back();
              ExportReportService.exportDashboardToExcel(dashboardData);
            },
          ),
          SizedBox(height: 12.h),

          // 2. تصدير قائمة أحدث الطلبات (Excel)
          if (dashboardData != null && dashboardData!.recentOrders.isNotEmpty) ...[
            _buildExportOption(
              title: "تصدير جدول الطلبات الحالية (Excel)",
              subtitle: "كافة تفاصيل وأسعار وحالات الطلبات الواردة",
              icon: IconsaxPlusBold.receipt_item,
              color: AppColor.preimary,
              bgColor: AppColor.primaryLight,
              onTap: () {
                Get.back();
                ExportReportService.exportOrdersToExcel(dashboardData!.recentOrders);
              },
            ),
            SizedBox(height: 12.h),
          ],

          // 3. تصدير ملخص الإدارة (PDF / Summary)
          _buildExportOption(
            title: "تصدير ملخص إداري منسق (PDF / Report)",
            subtitle: "تقرير نصي تنفيذي جاهز للمشاركة والطباعة الفورية",
            icon: IconsaxPlusBold.printer,
            color: AppColor.preimaryscound,
            bgColor: AppColor.secondaryLight,
            onTap: () {
              Get.back();
              ExportReportService.exportReportPDF(dashboardData);
            },
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.card,
      child: Container(
        padding: EdgeInsets.all(14.r),
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 10.5.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.r,
              color: AppColor.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
