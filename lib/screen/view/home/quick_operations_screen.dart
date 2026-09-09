import 'package:admin/controller/admin/admin_dashboard_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/localization/change.dart';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:admin/screen/widgets/admin/admin_quick_actions_grid.dart';
import 'package:admin/screen/widgets/admin/admin_recent_orders_list.dart';
import 'package:admin/screen/widgets/admin/admin_stat_badge_grid.dart';
import 'package:admin/screen/widgets/common/topbackground.dart';
import 'package:admin/screen/widgets/handling/error_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// ⚡ شاشة مركز العمليات والتحكم السريع المتناسقة (Operations Command Hub)
class QuickOperationsScreen extends StatelessWidget {
  const QuickOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AdminDashboardControllerImp>()
        ? Get.find<AdminDashboardControllerImp>()
        : Get.put(AdminDashboardControllerImp());
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.h),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: const Topbackground(
            height: 120,
            showBottomCurve: true,
          ),
          title: Text(
            "مركز العمليات والوصول السريع",
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => localeController.changeTheme(),
              icon: Icon(
                IconsaxPlusBroken.moon,
                color: Colors.white,
                size: 20.r,
              ),
              tooltip: "تبديل المظهر",
            ),
            IconButton(
              onPressed: () => controller.getDashboardStats(isRefresh: true),
              icon: Icon(
                IconsaxPlusBroken.refresh_2,
                color: Colors.white,
                size: 20.r,
              ),
              tooltip: "تحديث البيانات",
            ),
            SizedBox(width: 8.w),
          ],
        ),
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
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. كرت هوية المسؤول
                    _buildOperationsHeroBanner(controller),
                    SizedBox(height: 32.h),

                  
                    // 3. شبكة الوصول السريع لأقسام التطبيق
                    AdminQuickActionsGrid(
                      onCategoriesTap: () => controller.goToCategories(),
                      onProductsTap: () => controller.goToProducts(),
                      onOrdersTap: () => controller.goToOrders(),
                      onUsersTap: () => controller.goToUsers(),
                      onNotificationsTap: () => controller.goToNotifications(),
                      onStockTap: () => controller.goToProducts(),
                    ),
                    SizedBox(height: 32.h),

                    // 4. العمليات الحية للطلبات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "حالات الطلبات المباشرة",
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.badge,
                          ),
                          child: Text(
                            "مباشر",
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    AdminStatBadgeGrid(
                      stats: data.orderStats,
                      onCardTap: (status) =>
                          controller.goToOrders(initialStatus: status),
                    ),
                    SizedBox(height: 32.h),

                    // 5. الطلبات الأخيرة
                    AdminRecentOrdersList(
                      recentOrders: data.recentOrders,
                      onOrderTap: (order) =>
                          controller.openOrderDetails(context, order),
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

  /// 👑 كرت الهوية والعمليات الرائد
  Widget _buildOperationsHeroBanner(AdminDashboardControllerImp controller) {
    final String firstLetter = controller.adminName.isNotEmpty
        ? controller.adminName[0].toUpperCase()
        : "A";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.012),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColor.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Text(
              firstLetter,
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.preimary,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.adminName,
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        borderRadius: AppRadius.badge,
                      ),
                      child: Text(
                        "مدير النظام",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.preimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  controller.adminEmail,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 10.5.sp,
                    color: AppColor.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: AppRadius.radiusFull,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5.5.r,
                  height: 5.5.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "متصل",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}