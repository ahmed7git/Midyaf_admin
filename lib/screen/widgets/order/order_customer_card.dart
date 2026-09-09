import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/data/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// 👤 بطاقة بيانات العميل صاحب الطلب (Customer Order Info Card)
class OrderCustomerCard extends StatelessWidget {
  final OrderModel? order;

  const OrderCustomerCard({super.key, required this.order});

  Future<void> _makeCall(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (order == null) return const SizedBox.shrink();

    final String name = order!.userName?.isNotEmpty == true
        ? order!.userName!
        : "العميل #${order!.orderUserid ?? '---'}";

    final String phone = order!.userPhone?.isNotEmpty == true
        ? order!.userPhone!
        : "غير محدد";

    final String email = order!.userEmail?.isNotEmpty == true
        ? order!.userEmail!
        : "";

    final bool isBranchPickup = order!.orderType == 1;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.018),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. عنوان الكرت
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColor.primaryLight,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(
                      IconsaxPlusBold.user_cirlce_add,
                      color: AppColor.preimary,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "بيانات العميل صاحب الطلب",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isBranchPickup ? AppColor.infoBg : AppColor.primaryLight,
                  borderRadius: AppRadius.badge,
                  border: Border.all(
                    color: isBranchPickup ? AppColor.info.withValues(alpha: 0.3) : AppColor.primaryBorder,
                    width: 0.8.w,
                  ),
                ),
                child: Text(
                  isBranchPickup ? "استلام من الفرع" : "توصيل للمنزل",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: isBranchPickup ? AppColor.info : AppColor.preimary,
                  ),
                ),
              ),
            ],
          ),

          Divider(color: AppColor.borderLight, height: 18.h),

          // 2. معلومات العميل والاتصال
          Row(
            children: [
              // الأيقونة الدائرية للاسم
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.primaryLight,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "U",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColor.preimary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(IconsaxPlusBroken.call, size: 12.r, color: AppColor.textSecondary),
                        SizedBox(width: 4.w),
                        Text(
                          phone,
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // أزرار الاتصال السريع
              if (phone != "غير محدد") ...[
                IconButton(
                  onPressed: () => _makeCall(phone),
                  icon: const Icon(IconsaxPlusBold.call, color: Color(0xFF10B981), size: 20),
                  tooltip: "اتصال هاتفي",
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF0FDF4),
                    padding: EdgeInsets.all(8.r),
                    minimumSize: Size(36.w, 36.h),
                  ),
                ),
                SizedBox(width: 6.w),
                IconButton(
                  onPressed: () => _openWhatsApp(phone),
                  icon: const Icon(IconsaxPlusBold.messages_3, color: Color(0xFF25D366), size: 20),
                  tooltip: "مراسلة عبر واتساب",
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE8F8F0),
                    padding: EdgeInsets.all(8.r),
                    minimumSize: Size(36.w, 36.h),
                  ),
                ),
              ],
            ],
          ),

          // 3. البريد الإلكتروني والعنوان إن وجدا
          if (email.isNotEmpty || (!isBranchPickup && (order!.addressCity?.isNotEmpty == true || order!.addressStreet?.isNotEmpty == true))) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColor.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  if (email.isNotEmpty)
                    Row(
                      children: [
                        Icon(IconsaxPlusBroken.sms, size: 12.r, color: AppColor.textMuted),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            email,
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 11.sp,
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (email.isNotEmpty && !isBranchPickup) SizedBox(height: 4.h),
                  if (!isBranchPickup && (order!.addressCity?.isNotEmpty == true || order!.addressStreet?.isNotEmpty == true))
                    Row(
                      children: [
                        Icon(IconsaxPlusBroken.location, size: 12.r, color: AppColor.textMuted),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            "${order!.addressCity ?? ''} - ${order!.addressStreet ?? ''}".trim(),
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 11.sp,
                              color: AppColor.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
