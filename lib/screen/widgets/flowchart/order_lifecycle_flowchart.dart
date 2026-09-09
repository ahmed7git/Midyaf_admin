import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 📊 مخطط دورة حياة الطلب التفاعلي المتناسق (Order Lifecycle Flowchart)
class OrderLifecycleFlowchart extends StatelessWidget {
  final int currentStatus; // 0: Pending, 1: Preparing, 2: Ready, 3: On The Way, 4: Delivered, 5: Cancelled
  final Function(int newStatus)? onStatusChange;
  final bool isInteractive;

  const OrderLifecycleFlowchart({
    super.key,
    required this.currentStatus,
    this.onStatusChange,
    this.isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCancelled = currentStatus == 5;

    final List<Map<String, dynamic>> steps = [
      {
        'status': 0,
        'title': 'طلب جديد',
        'subtitle': 'بانتظار موافقة الإدارة',
        'icon': IconsaxPlusBold.receipt_1,
        'color': AppColor.warning,
      },
      {
        'status': 1,
        'title': 'قيد التجهيز',
        'subtitle': 'جاري إعداد الوجبة بالمطبخ',
        'icon': IconsaxPlusBold.timer,
        'color': AppColor.preimaryscound,
      },
      {
        'status': 2,
        'title': 'جاهز للتسليم',
        'subtitle': 'تم التجهيز بانتظار المندوب',
        'icon': IconsaxPlusBold.box_tick,
        'color': AppColor.primaryMedium,
      },
      {
        'status': 3,
        'title': 'مع الكابتن',
        'subtitle': 'جاري التوصيل إلى العميل',
        'icon': IconsaxPlusBold.truck_fast,
        'color': AppColor.primaryDark,
      },
      {
        'status': 4,
        'title': 'تم التسليم',
        'subtitle': 'اكتمل الطلب بنجاح',
        'icon': IconsaxPlusBold.tick_circle,
        'color': AppColor.preimary,
      },
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        borderRadius: AppRadius.badge,
                        border: Border.all(
                          color: AppColor.primaryBorder,
                          width: 1.w,
                        ),
                      ),
                      child: const Icon(
                        IconsaxPlusBold.hierarchy_3,
                        color: AppColor.preimary,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "مخطط مسار الطلب (Order Flowchart)",
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
                  ],
                ),
              ),
              if (isCancelled)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColor.dangerBg,
                    borderRadius: AppRadius.radiusFull,
                    border: Border.all(color: AppColor.danger, width: 1.w),
                  ),
                  child: Text(
                    "ملغي / مرفوض",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.danger,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            itemCount: steps.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final step = steps[index];
              final int stepStatus = step['status'];
              final bool isPassed = !isCancelled && currentStatus >= stepStatus;
              final bool isCurrent = !isCancelled && currentStatus == stepStatus;
              final Color stepColor = step['color'];

              return InkWell(
                onTap: isInteractive && onStatusChange != null
                    ? () => onStatusChange!(stepStatus)
                    : null,
                borderRadius: AppRadius.cardInner,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 36.r,
                            height: 36.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? stepColor
                                  : isPassed
                                      ? stepColor.withValues(alpha: 0.12)
                                      : Colors.grey.shade100,
                              border: Border.all(
                                color: isCurrent || isPassed
                                    ? stepColor
                                    : Colors.grey.shade300,
                                width: 2.w,
                              ),
                              boxShadow: isCurrent
                                  ? [
                                      BoxShadow(
                                        color: stepColor.withValues(alpha: 0.35),
                                        blurRadius: 6.r,
                                        offset: Offset(0, 2.h),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              step['icon'],
                              size: 17.r,
                              color: isCurrent
                                  ? Colors.white
                                  : isPassed
                                      ? stepColor
                                      : Colors.grey.shade400,
                            ),
                          ),
                          if (index < steps.length - 1)
                            Container(
                              width: 2.w,
                              height: 30.h,
                              color: isPassed && currentStatus > stepStatus
                                  ? stepColor
                                  : Colors.grey.shade200,
                            ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? stepColor.withValues(alpha: 0.06)
                                : Colors.transparent,
                            borderRadius: AppRadius.input,
                            border: isCurrent
                                ? Border.all(
                                    color: stepColor.withValues(alpha: 0.2),
                                    width: 1.w,
                                  )
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    step['title'],
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 13.sp,
                                      fontWeight: isCurrent || isPassed
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: isCurrent
                                          ? stepColor
                                          : isPassed
                                              ? AppColor.textPrimary
                                              : AppColor.textMuted,
                                    ),
                                  ),
                                  if (isCurrent)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 7.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: stepColor,
                                        borderRadius: AppRadius.radiusFull,
                                      ),
                                      child: Text(
                                        "المرحلة الحالية",
                                        style: TextStyle(
                                          fontFamily: 'IBMPlexSansArabic',
                                          fontSize: 9.5.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                step['subtitle'],
                                style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 11.sp,
                                  color: isPassed
                                      ? AppColor.textSecondary
                                      : AppColor.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
