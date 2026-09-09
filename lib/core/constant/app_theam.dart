import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // 1. ثوابت نصف القطر المعتمدة من AppRadius
  static double get cardRadius => AppRadius.lg;
  static double get buttonRadius => AppRadius.md;
  static double get bottomSheetRadius => AppRadius.sheet;

  // 2. ترويسة الأقسام والبطاقات الموحدة
  static BoxDecoration cardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: AppRadius.card,
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
        width: 1.w,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
          blurRadius: 12.r,
          offset: Offset(0, 4.h),
        ),
      ],
    );
  }

  // ================= 1. الثيم الفاتح =================
  static ThemeData lightTheme(String langCode) {
    const font = "IBMPlexSansArabic";

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColor.preimary,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      fontFamily: font,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.preimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          textStyle: TextStyle(
            fontFamily: font,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          textStyle: TextStyle(
            fontFamily: font,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.bottomSheet,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E242B)),
        titleTextStyle: TextStyle(
          color: const Color(0xFF1E242B),
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
          fontFamily: font,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColor.preimary,
        secondary: AppColor.preimaryscound,
        surface: Colors.white,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(fontFamily: font, fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E242B)),
        titleMedium: TextStyle(fontFamily: font, fontSize: 15.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
        titleSmall: TextStyle(fontFamily: font, fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
        bodyLarge: TextStyle(fontFamily: font, fontSize: 14.sp, fontWeight: FontWeight.normal, color: const Color(0xFF1E242B)),
        bodyMedium: TextStyle(fontFamily: font, fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF64748B)),
        bodySmall: TextStyle(fontFamily: font, fontSize: 11.sp, fontWeight: FontWeight.w500, color: const Color(0xFF94A3B8)),
        labelLarge: TextStyle(fontFamily: font, fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
      ),
    );
  }

  // ================= 2. الثيم الداكن =================
  static ThemeData darkTheme(String langCode) {
    const font = "IBMPlexSansArabic";

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColor.preimary,
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: font,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.preimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          textStyle: TextStyle(
            fontFamily: font,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white24),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          textStyle: TextStyle(
            fontFamily: font,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.bottomSheet,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
          fontFamily: font,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColor.preimary,
        secondary: AppColor.preimaryscound,
        surface: Color(0xFF1E1E1E),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(fontFamily: font, fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(fontFamily: font, fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white),
        titleSmall: TextStyle(fontFamily: font, fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white70),
        bodyLarge: TextStyle(fontFamily: font, fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.white),
        bodyMedium: TextStyle(fontFamily: font, fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.white70),
        bodySmall: TextStyle(fontFamily: font, fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.white60),
        labelLarge: TextStyle(fontFamily: font, fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white60),
      ),
    );
  }
}
