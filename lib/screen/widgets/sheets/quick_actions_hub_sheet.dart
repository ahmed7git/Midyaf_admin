import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/constant/reoute.dart';
import 'package:admin/screen/widgets/sheets/add_category_sheet.dart';
import 'package:admin/screen/widgets/sheets/add_item_sheet.dart';
import 'package:admin/screen/widgets/sheets/export_report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// ⚡ نافذة مركز العمليات السريع (Quick Actions Hub Bottom Sheet)
class QuickActionsHubSheet extends StatelessWidget {
  const QuickActionsHubSheet({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      const QuickActionsHubSheet(),
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
          SizedBox(height: 14.h),

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
                    "إضافة سريعة، إدارة العمليات، وتصدير التقارير",
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

          SizedBox(height: 18.h),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.8,
            children: [
              _buildHubActionCard(
                title: "إضافة منتج",
                subtitle: "صنف ومخزون جديد",
                icon: IconsaxPlusBold.box_add,
                color: AppColor.preimary,
                bgColor: AppColor.primaryLight,
                onTap: () {
                  Get.back();
                  AddItemSheet.show(context);
                },
              ),
              _buildHubActionCard(
                title: "إضافة قسم",
                subtitle: "تصنيف جديد",
                icon: IconsaxPlusBold.folder_add,
                color: AppColor.primaryMedium,
                bgColor: AppColor.primaryLight,
                onTap: () {
                  Get.back();
                  AddCategorySheet.show(context);
                },
              ),
              _buildHubActionCard(
                title: "تصدير التقارير",
                subtitle: "Excel / PDF",
                icon: IconsaxPlusBold.document_download,
                color: const Color(0xFF057A55),
                bgColor: const Color(0xFFF0FDF4),
                onTap: () {
                  Get.back();
                  ExportReportSheet.show(context);
                },
              ),
              _buildHubActionCard(
                title: "إضافة مسؤول",
                subtitle: "صلاحية إدارة",
                icon: IconsaxPlusBold.user_add,
                color: AppColor.preimaryscound,
                bgColor: AppColor.secondaryLight,
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.addUser);
                },
              ),
            ],
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildHubActionCard({
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
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.card,
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.04),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18.r),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
