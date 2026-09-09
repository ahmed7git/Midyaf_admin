import 'package:admin/controller/admin/admin_dashboard_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/localization/change.dart';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:admin/screen/widgets/admin/admin_revenue_card.dart';
import 'package:admin/screen/widgets/admin/admin_sales_chart.dart';
import 'package:admin/screen/widgets/admin/admin_top_items_list.dart';
import 'package:admin/screen/widgets/flowchart/fleet_lifecycle_flowchart.dart';
import 'package:admin/screen/widgets/flowchart/stock_movement_flowchart.dart';
import 'package:admin/screen/widgets/handling/error_screens.dart';
import 'package:admin/screen/widgets/sheets/export_report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 📊 شاشة الإحصائيات والتحليلات الشاملة (Analytics & Monitoring Hub)
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDashboardControllerImp());
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "لوحة الإحصائيات والمراقبة",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 15.5.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 37, 112, 5),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "مركز التحليلات المباشر • متصل",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 10.5.sp,
                    color: AppColor.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => ExportReportSheet.show(
              context,
              dashboardData: controller.dashboardData,
            ),
            icon: Icon(
              IconsaxPlusBold.document_download,
              color: AppColor.preimary,
              size: 20.r,
            ),
            tooltip: "تصدير التقارير",
            padding: EdgeInsets.all(6.r),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: () => localeController.changeTheme(),
            icon: Icon(
              IconsaxPlusBroken.moon,
              color: AppColor.textPrimary,
              size: 20.r,
            ),
            tooltip: "تبديل المظهر",
            padding: EdgeInsets.all(6.r),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: () => controller.getDashboardStats(isRefresh: true),
            icon: Icon(
              IconsaxPlusBroken.refresh_2,
              color: AppColor.preimary,
              size: 20.r,
            ),
            tooltip: "تحديث البيانات",
            padding: EdgeInsets.all(6.r),
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: GetBuilder<AdminDashboardControllerImp>(
        builder: (controller) {
          final data = controller.dashboardData ?? AdminDashboardModel.dummy();

          return FullHandlingRequestView(
            staterequest: controller.staterequest,
            onRetry: () => controller.getDashboardStats(),
            child: RefreshIndicator(
              color: AppColor.preimary,
              backgroundColor: Colors.white,
              onRefresh: () => controller.getDashboardStats(isRefresh: true),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. شريط تبديل الفترات الزمنية
                    _buildPeriodSelector(controller),
                    SizedBox(height: 12.h),

                    // 2. الكرت البنكي الفاخر للإيرادات (Bank Card Revenue)
                    AdminRevenueCard(
                      overview: data.overview,
                    ),
                    SizedBox(height: 14.h),

                    // 3. المخطط البياني التفاعلي للمبيعات والطلبات
                    AdminSalesChart(
                      chartData: data.chartData,
                    ),
                    SizedBox(height: 14.h),

                    // 4. كرت مؤشرات وصحة حركة المخزون
                    StockMovementFlowchart(
                      inStockCount: data.stockStats.inStock,
                      lowStockCount: data.stockStats.lowStock,
                      outOfStockCount: data.stockStats.outOfStock,
                      onManageStock: () => controller.goToProducts(),
                    ),
                    SizedBox(height: 14.h),

                    // 5. كرت حالة وجاهزية أسطول التوصيل
                    FleetLifecycleFlowchart(
                      activeDriversCount: data.overview.activeDrivers,
                      onManageDrivers: () => controller.goToUsers(),
                    ),
                    SizedBox(height: 14.h),

                    // 6. قائمة الأصناف الأكثر مبيعاً
                    AdminTopItemsList(
                      topItems: data.topItems,
                    ),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector(AdminDashboardControllerImp controller) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColor.primaryBorder, width: 1.w),
      ),
      child: Row(
        children: controller.periods.map((period) {
          final bool isSelected = controller.selectedPeriod == period['key'];
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.changePeriod(period['key']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.preimary : Colors.transparent,
                  borderRadius: AppRadius.input,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.preimary.withValues(alpha: 0.25),
                            blurRadius: 6.r,
                            offset: Offset(0, 2.h),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  period['label']!,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 11.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColor.preimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
