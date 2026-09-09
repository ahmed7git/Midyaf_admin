import 'package:admin/applink.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:admin/screen/widgets/common/sar_price_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AdminTopItemsList extends StatelessWidget {
  final List<AdminTopItemModel> topItems;

  const AdminTopItemsList({super.key, required this.topItems});

  @override
  Widget build(BuildContext context) {
    if (topItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  IconsaxPlusBold.crown_1,
                  color: AppColor.warning,
                  size: 20.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  "الأصناف الأكثر طلباً ومبيعاً",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                borderRadius: AppRadius.radiusFull,
                border: Border.all(color: AppColor.primaryBorder, width: 1.w),
              ),
              child: Text(
                "أفضل ${topItems.length}",
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 10.5.sp,
                  color: AppColor.preimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          itemCount: topItems.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final item = topItems[index];
            final String name = item.itemNameAr.isNotEmpty
                ? item.itemNameAr
                : item.itemName;

            final List<Color> rankColors = [
              AppColor.preimary,
              AppColor.primaryMedium,
              AppColor.primaryDark,
            ];

            final Color currentRankColor = index < 3
                ? rankColors[index]
                : AppColor.textMuted;

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
                    width: 26.w,
                    height: 26.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: currentRankColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.bold,
                        color: currentRankColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  Container(
                    width: 46.w,
                    height: 46.h,
                    decoration: BoxDecoration(
                      color: AppColor.primaryLight,
                      borderRadius: AppRadius.cardInner,
                      border: Border.all(color: AppColor.primaryBorder, width: 1.w),
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.cardInner,
                      child: CachedNetworkImage(
                        imageUrl: "${Applink.itemsImage}/${item.itemImage}",
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          IconsaxPlusBold.box_1,
                          size: 20.r,
                          color: AppColor.preimary.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.categoryName.isNotEmpty
                              ? item.categoryName
                              : "وجبات ومشروبات",
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            fontSize: 11.sp,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${item.totalQuantitySold} طلب",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.preimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SarPriceWidget(
                        price: item.totalRevenue,
                        decimals: 0,
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textSecondary,
                        ),
                        symbolColor: AppColor.textSecondary,
                        symbolSize: 10.r,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
