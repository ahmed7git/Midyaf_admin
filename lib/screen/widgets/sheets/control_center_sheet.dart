import 'package:admin/controller/admin/admin_dashboard_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/constant/reoute.dart';
import 'package:admin/screen/widgets/sheets/add_category_sheet.dart';
import 'package:admin/screen/widgets/sheets/add_item_sheet.dart';
import 'package:admin/screen/widgets/sheets/add_user_sheet.dart';
import 'package:admin/screen/widgets/sheets/export_report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 🎛️ مركز الإجراءات السريعة والتصدير (Quick Actions & Exports Sheet)
class ControlCenterSheet extends StatelessWidget {
  const ControlCenterSheet({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      const ControlCenterSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.isRegistered<AdminDashboardControllerImp>()
        ? Get.find<AdminDashboardControllerImp>()
        : null;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.80.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.bottomSheet,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
            SizedBox(height: 14.h),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        borderRadius: AppRadius.badge,
                      ),
                      child: const Icon(
                        IconsaxPlusBold.flash_1,
                        color: AppColor.preimary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مركز الإجراءات السريعة",
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        Text(
                          "إضافة سريعة وتصدير تقارير النظام",
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
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close_rounded, size: 20.r, color: AppColor.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 18.h),

            // 1. قسم الإضافات المباشرة
            Text(
              "الإنشاء والإضافة المباشرة",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    title: "إضافة منتج",
                    subtitle: "صنف ومخزون جديد",
                    icon: IconsaxPlusBold.box_add,
                    onTap: () {
                      Get.back();
                      AddItemSheet.show(context);
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildActionTile(
                    title: "إضافة قسم",
                    subtitle: "تصنيف جديد",
                    icon: IconsaxPlusBold.folder_add,
                    onTap: () {
                      Get.back();
                      AddCategorySheet.show(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    title: "إضافة مسؤول",
                    subtitle: "تعيين صلاحية جديدة",
                    icon: IconsaxPlusBold.user_add,
                    onTap: () {
                      Get.back();
                      AddUserSheet.show(context);
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildActionTile(
                    title: "إرسال إشعار",
                    subtitle: "تنبيه عام للعملاء",
                    icon: IconsaxPlusBold.notification_bing,
                    onTap: () {
                      Get.back();
                      Get.toNamed(AppRoutes.notifications);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),

            // 2. قسم التقارير والتصدير
            Text(
              "التقارير وتصدير البيانات",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    title: "تصدير كـ Excel",
                    subtitle: "ملف جداول مفصل",
                    icon: IconsaxPlusBold.document_text,
                    onTap: () {
                      Get.back();
                      ExportReportSheet.show(
                        context,
                        dashboardData: dashboardController?.dashboardData,
                      );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildActionTile(
                    title: "تصدير كـ PDF",
                    subtitle: "تقرير مالي رسمي",
                    icon: IconsaxPlusBold.receipt_2,
                    onTap: () {
                      Get.back();
                      ExportReportSheet.show(
                        context,
                        dashboardData: dashboardController?.dashboardData,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.card,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
            Icon(icon, color: AppColor.preimary, size: 20.r),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 9.5.sp,
                      color: AppColor.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
