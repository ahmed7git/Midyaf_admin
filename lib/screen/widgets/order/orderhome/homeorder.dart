import 'package:admin/controller/orders/homeorder_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/screen/widgets/common/topbackground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OrderHome extends StatelessWidget {
  const OrderHome({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderHomeNavControllerImp());

    return GetBuilder<OrderHomeNavControllerImp>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColor.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(115.h),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: const Topbackground(
              height: 180,
              showBottomCurve: true,
            ),
            title: Text(
              "متابعة وإدارة الطلبات",
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(54.h),
              child: Container(
                height: 42.h,
                margin: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 12.h),
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: AppRadius.card,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.w),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        title: "الطلبات الجديدة",
                        icon: IconsaxPlusBold.receipt_1,
                        isSelected: controller.currentPage == 0,
                        onTap: () => controller.changePage(0),
                      ),
                    ),
                    Expanded(
                      child: _buildTabButton(
                        title: "الطلبات المقبولة",
                        icon: IconsaxPlusBold.tick_circle,
                        isSelected: controller.currentPage == 1,
                        onTap: () => controller.changePage(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 70.h),
          child: controller.listPage.elementAt(controller.currentPage),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: AppRadius.input,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6.r,
                    offset: Offset(0, 2.h),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.r,
              color: isSelected ? AppColor.preimary : Colors.white,
            ),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 11.5.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColor.preimary : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
