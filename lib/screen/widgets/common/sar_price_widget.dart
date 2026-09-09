import 'package:admin/core/constant/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 💰 ودجت موحد لعرض الأسعار مع رمز الريال السعودي (SVG Symbol)
class SarPriceWidget extends StatelessWidget {
  final dynamic price;
  final TextStyle? style;
  final Color? symbolColor;
  final double? symbolSize;
  final int decimals;
  final MainAxisSize mainAxisSize;

  const SarPriceWidget({
    super.key,
    required this.price,
    this.style,
    this.symbolColor,
    this.symbolSize,
    this.decimals = 1,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    String formattedPrice = "0";
    if (price is num) {
      formattedPrice = (price as num).toStringAsFixed(decimals);
    } else if (price != null) {
      double? parsed = double.tryParse(price.toString());
      formattedPrice = parsed != null ? parsed.toStringAsFixed(decimals) : price.toString();
    }

    final effectiveStyle = style ??
        TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E242B),
        );

    final effectiveColor = symbolColor ?? effectiveStyle.color ?? const Color(0xFF1E242B);
    final effectiveSize = symbolSize ?? (effectiveStyle.fontSize ?? 14.sp) * 0.85;

    return Row(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          formattedPrice,
          style: effectiveStyle,
        ),
        SizedBox(width: 4.w),
        SvgPicture.asset(
          AppImages.sarSymbol,
          width: effectiveSize,
          height: effectiveSize,
          colorFilter: ColorFilter.mode(
            effectiveColor,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
