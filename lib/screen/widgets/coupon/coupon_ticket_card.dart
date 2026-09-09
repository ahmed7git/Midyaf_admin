import 'package:admin/core/constant/app_color.dart';
import 'package:admin/data/model/coupon_model.dart';
import 'package:admin/screen/widgets/sheets/edit_coupon_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 🎟️ كرت الكوبون الفاخر بمظهر قسيمة الشراء الحقيقية والباركود الأمني وتفاعل الحالة
class CouponTicketCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onDelete;

  const CouponTicketCard({
    super.key,
    required this.coupon,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = coupon.isActive;
    final Color primaryColor =
        isActive ? const Color(0xFF0D9488) : const Color(0xFFE11D48); // تيل زمردي أو وردي ياقوتي
    final Color accentBg =
        isActive ? const Color(0xFFF0FDFA) : const Color(0xFFFFF1F2);
    final String statusLabel = isActive ? "قسيمة نشطة ومتاحة" : "قسيمة منتهية / معطلة";

    return ClipPath(
      clipper: const LuxuryTicketClipper(notchRadius: 10, notchPositionRatio: 0.31),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.28),
            width: 1.2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.07),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. قسيمة الخصم الجانبية (Voucher Discount Stub)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                child: Container(
                  width: 95.w,
                  decoration: BoxDecoration(
                    color: accentBg,
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accentBg,
                        primaryColor.withValues(alpha: 0.09),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusBold.ticket_discount,
                        color: primaryColor,
                        size: 24.r,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${coupon.couponDiscount?.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            "%",
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "خصم مباشر",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // خط التنقيط الفاصل (Perforation Line)
              CustomPaint(
                size: Size(1.w, double.infinity),
                painter: TicketDashedLinePainter(color: primaryColor.withValues(alpha: 0.3)),
              ),

              // 2. جسم التذكرة الرئيسي (Main Voucher Body)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 14.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // الصف الأول: كود الكوبون المنسوخ + أزرار التعديل والحذف
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (coupon.couponName != null) {
                                Clipboard.setData(
                                  ClipboardData(text: coupon.couponName!),
                                );
                                Get.snackbar(
                                  "تم النسخ بنجاح",
                                  "كود الخصم: ${coupon.couponName}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 1),
                                  colorText: AppColor.preimary,
                                  backgroundColor:AppColor.white,
                                  margin: const EdgeInsets.all(12),
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  coupon.couponName ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppColor.textPrimary,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Icon(
                                  IconsaxPlusBold.copy,
                                  size: 13.r,
                                  color: AppColor.textMuted,
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => EditCouponSheet.show(context, coupon),
                                icon: Icon(
                                  IconsaxPlusBold.edit_2,
                                  color: AppColor.preimary,
                                  size: 16.r,
                                ),
                                tooltip: "تعديل",
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(4.r),
                              ),
                              SizedBox(width: 4.w),
                              IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "حذف الكوبون",
                                    middleText: "هل أنت متأكد من رغبتك في حذف هذا الكوبون نهائياً؟",
                                    textConfirm: "نعم، حذف",
                                    textCancel: "إلغاء",
                                    confirmTextColor: Colors.white,
                                    buttonColor: const Color(0xFFEF4444),
                                    onConfirm: () {
                                      Get.back();
                                      onDelete();
                                    },
                                  );
                                },
                                icon: const Icon(
                                  IconsaxPlusBold.trash,
                                  color: Color(0xFFEF4444),
                                  size: 16,
                                ),
                                tooltip: "حذف",
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(4.r),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),

                      // حالة الكوبون: نص ملون خالص مع نبضة حية
                      Row(
                        children: [
                          Container(
                            width: 6.5.r,
                            height: 6.5.r,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.4),
                                  blurRadius: 4.r,
                                  spreadRadius: 1.r,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "المتبقي: ${coupon.couponCount} مرة",
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),

                      // الصف السفلي: تاريخ الانتهاء مع رسم الباركود الأمني للواقعية
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "ينتهي: ${coupon.couponExpiredate ?? ''}",
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 9.5.sp,
                              color: AppColor.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // رسم الباركود الأمني المصغر ليعطي مظهر الكوبون الحقيقي
                          CustomPaint(
                            size: Size(54.w, 14.h),
                            painter: BarcodeSnippetPainter(
                              color: Colors.black.withValues(alpha: 0.22),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// قص أطراف التذكرة بشكل هلالي دقيق ومتماثل (Top & Bottom Notches)
class LuxuryTicketClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchPositionRatio;

  const LuxuryTicketClipper({
    this.notchRadius = 10,
    this.notchPositionRatio = 0.31,
  });

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double notchX = size.width * notchPositionRatio;

    path.moveTo(0, 0);

    // أعلى التذكرة مع ثنية دائرية
    path.lineTo(notchX - notchRadius, 0);
    path.arcToPoint(
      Offset(notchX + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);

    // الجانب الأيمن
    path.lineTo(size.width, size.height);

    // أسفل التذكرة مع ثنية دائرية مقابلة
    path.lineTo(notchX + notchRadius, size.height);
    path.arcToPoint(
      Offset(notchX - notchRadius, size.height),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// رسم خط التنقيط الفاصل (Perforation Line)
class TicketDashedLinePainter extends CustomPainter {
  final Color color;
  const TicketDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const double dashHeight = 4.0;
    const double dashSpace = 3.5;
    double startY = 12.0;
    final double endY = size.height - 12.0;

    while (startY < endY) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// رسم باركود أمني مصغر أسفل التذكرة
class BarcodeSnippetPainter extends CustomPainter {
  final Color color;
  const BarcodeSnippetPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final List<double> widths = [1.5, 3.0, 1.0, 2.0, 1.5, 3.5, 1.0, 2.5, 1.5, 3.0, 1.0, 2.0];
    double currentX = 0;

    for (int i = 0; i < widths.length; i++) {
      if (currentX >= size.width) break;
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTWH(currentX, 0, widths[i], size.height),
          paint,
        );
      }
      currentX += widths[i] + 1.5;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
