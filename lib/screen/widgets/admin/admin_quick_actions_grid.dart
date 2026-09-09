import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_images.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AdminQuickActionsGrid extends StatelessWidget {
  final VoidCallback onCategoriesTap;
  final VoidCallback onProductsTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onUsersTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onStockTap;

  const AdminQuickActionsGrid({
    super.key,
    required this.onCategoriesTap,
    required this.onProductsTap,
    required this.onOrdersTap,
    required this.onUsersTap,
    required this.onNotificationsTap,
    required this.onStockTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {'title': 'الطلبات', 'lottie': AppImages.deli, 'onTap': onOrdersTap, 'size': 70.r},
      {'title': 'المنتجات', 'lottie': AppImages.food, 'onTap': onProductsTap, 'size': 55.r},
      {'title': 'الأقسام', 'lottie': AppImages.section, 'onTap': onCategoriesTap, 'size': 45.r},
      {'title': 'المخزون', 'lottie': AppImages.stock, 'onTap': onStockTap, 'size': 40.r},
      {'title': 'المستخدمين', 'lottie': AppImages.users, 'onTap': onUsersTap, 'size': 30.r},
      {'title': 'الإشعارات', 'lottie': AppImages.notification, 'onTap': onNotificationsTap, 'size': 40.r},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // يمنع تمدد العمود عمودياً
      children: [
        Text(
          "الوصول السريع للأقسام",
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        GridView.builder(
          itemCount: actions.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero, // تصفير الهوامش التلقائية لـ GridView
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            // 💡 السر هنا: النسبة 1.35 تجعل الكرت مستطيل مضغوط وتمنع أي فراغ تحته
            childAspectRatio: 1.0, 
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            final double size = action['size'] as double;

            return InkWell(
              onTap: action['onTap'],
              borderRadius: AppRadius.card,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColor.borderLight, width: 1.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.015),
                      blurRadius: 4.r,
                      offset: Offset(0, 1.h),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
               
                     Center(
                        child: LottieBuilder.asset(
                          action['lottie'],
                          height: size,
                          width: size,
                          fit: BoxFit.contain,
                        ),
                      ),
                    
                    SizedBox(height: 4.h),
                    Text(
                      action['title'],
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}