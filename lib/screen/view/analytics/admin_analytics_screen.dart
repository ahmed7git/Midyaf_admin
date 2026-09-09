import 'package:admin/controller/admin/admin_dashboard_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:admin/screen/widgets/admin/admin_revenue_card.dart';
import 'package:admin/screen/widgets/admin/admin_sales_chart.dart';
import 'package:admin/screen/widgets/admin/admin_stat_badge_grid.dart';
import 'package:admin/screen/widgets/admin/admin_top_items_list.dart';
import 'package:admin/screen/widgets/common/sar_price_widget.dart';
import 'package:admin/screen/widgets/flowchart/fleet_lifecycle_flowchart.dart';
import 'package:admin/screen/widgets/flowchart/stock_movement_flowchart.dart';
import 'package:admin/screen/widgets/handling/error_screens.dart';
import 'package:admin/screen/widgets/sheets/export_report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 📊 شاشة مركز الإحصائيات والتحليلات المتقدمة (Admin Analytics & Reports Hub)
class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AdminDashboardControllerImp>()
        ? Get.find<AdminDashboardControllerImp>()
        : Get.put(AdminDashboardControllerImp());

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "مركز الإحصائيات والتحليلات",
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: true,
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
          ),
          IconButton(
            onPressed: () => controller.getDashboardStats(isRefresh: true),
            icon: Icon(
              IconsaxPlusBroken.refresh_2,
              color: AppColor.preimary,
              size: 20.r,
            ),
            tooltip: "تحديث الإحصائيات",
          ),
          SizedBox(width: 6.w),
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
                    // 1. محدد الفترات الزمنية وزر تصدير ملفات الإكسل
                    Row(
                      children: [
                        Expanded(child: _buildPeriodSelector(controller)),
                        SizedBox(width: 8.w),
                        InkWell(
                          onTap: () => ExportReportSheet.show(
                            context,
                            dashboardData: controller.dashboardData,
                          ),
                          borderRadius: AppRadius.card,
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColor.primaryLight,
                              borderRadius: AppRadius.card,
                              border: Border.all(
                                color: AppColor.primaryBorder,
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  IconsaxPlusBold.document_download,
                                  color: AppColor.preimary,
                                  size: 16,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "تصدير",
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.preimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // 2. كرت الإيرادات التفاعلي مع العداد المتحرك
                    AdminRevenueCard(
                      overview: data.overview,
                    ),
                    SizedBox(height: 16.h),

                    // 3. بطاقات الأداء المالي والتشغيلي المصغرة
                    _buildMetricsGrid(data.overview),
                    SizedBox(height: 16.h),

                    // 4. مخطط المبيعات والطلبات البياني
                    AdminSalesChart(
                      chartData: data.chartData,
                    ),
                    SizedBox(height: 16.h),

                    // 5. إحصائيات توزيع حالات الطلبات
                    Text(
                      "توزيع حالات الطلبات الحية",
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AdminStatBadgeGrid(
                      stats: data.orderStats,
                      onCardTap: (status) =>
                          controller.goToOrders(initialStatus: status),
                    ),
                    SizedBox(height: 16.h),

                    // 6. مراقبة وحركة المخزون
                    StockMovementFlowchart(
                      inStockCount: data.stockStats.inStock,
                      lowStockCount: data.stockStats.lowStock,
                      outOfStockCount: data.stockStats.outOfStock,
                      onManageStock: () => controller.goToProducts(),
                    ),
                    SizedBox(height: 16.h),

                    // 7. إحصائيات كباتن التوصيل والأسطول
                    FleetLifecycleFlowchart(
                      activeDriversCount: data.overview.activeDrivers,
                      onManageDrivers: () => controller.goToUsers(),
                    ),
                    SizedBox(height: 16.h),

                    // 8. تقرير الأصناف الأكثر مبيعاً
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

  /// 🗓️ محدد الفترات
  Widget _buildPeriodSelector(AdminDashboardControllerImp controller) {
    return Container(
      height: 40.h,
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
                    fontSize: 11.5.sp,
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

  /// 📈 شبكة مؤشرات الأداء الحيوية (Key Performance Indicators)
  Widget _buildMetricsGrid(AdminOverviewModel overview) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: "متوسط السلة",
            value: SarPriceWidget(
              price: overview.averageOrderValue,
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: AppColor.textPrimary,
              ),
              symbolColor: AppColor.preimary,
              symbolSize: 13.r,
            ),
            icon: IconsaxPlusBold.shopping_cart,
            accentColor: AppColor.preimary,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildMetricCard(
            title: "نسبة النمو",
            value: Text(
              "+${overview.growthPercentage}%",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF057A55),
              ),
            ),
            icon: IconsaxPlusBold.trend_up,
            accentColor: const Color(0xFF057A55),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required Widget value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
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
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.badge,
            ),
            child: Icon(icon, color: accentColor, size: 18.r),
          ),
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
                    fontSize: 10.5.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                value,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
