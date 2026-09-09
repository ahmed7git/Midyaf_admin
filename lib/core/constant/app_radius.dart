import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 📐 نظام الانحناءات الموحد والعصري (BorderRadius Design System)
class AppRadius {
  // 1. القيم الأساسية المتجاوبة (Values)
  static double get xs => 8.0.r;     // للعناصر الدقيقة جداً والمؤشرات
  static double get sm => 12.0.r;    // للبادجات، التاجات، عدادات الكمية، والرقائق (Chips)
  static double get md => 16.0.r;    // للأزرار، حقول الإدخال، شريط البحث، والبطاقات الصغيرة
  static double get lg => 20.0.r;    // لبطاقات المنتجات، كروت الأقسام، وكروت القوائم
  static double get xl => 24.0.r;    // للكروت الرئيسية العريضة والسلايدرات
  static double get sheet => 28.0.r; // للـ BottomSheets والنوافذ السفلية المنبثقة
  static double get dialog => 24.0.r;// لمربعات الحوار (Dialogs)
  static double get full => 999.0.r; // للأزرار البيضاوية (Pills) والحاويات الدائرية

  // 2. كائنات BorderRadius جاهزة للاستخدام المباشر (Circular)
  static BorderRadius get radiusXs => BorderRadius.circular(xs);
  static BorderRadius get radiusSm => BorderRadius.circular(sm);
  static BorderRadius get radiusMd => BorderRadius.circular(md);
  static BorderRadius get radiusLg => BorderRadius.circular(lg);
  static BorderRadius get radiusXl => BorderRadius.circular(xl);
  static BorderRadius get radiusFull => BorderRadius.circular(full);
  static BorderRadius get radiusDialog => BorderRadius.circular(dialog);

  // 3. كائنات دلالية مخصصة للواجهات (Semantic Radii)
  /// انحناء البطاقات القياسية (Card)
  static BorderRadius get card => BorderRadius.circular(lg);

  /// انحناء البطاقات الداخلية أو الصور داخل البطاقات
  static BorderRadius get cardInner => BorderRadius.circular(md);

  /// انحناء الأزرار (Buttons)
  static BorderRadius get button => BorderRadius.circular(md);

  /// انحناء حقول الإدخال (Inputs & Search Bars)
  static BorderRadius get input => BorderRadius.circular(md);

  /// انحناء التاجات والبادجات (Badges & Chips)
  static BorderRadius get badge => BorderRadius.circular(sm);

  /// انحناء النوافذ السفلية المنبثقة (BottomSheets)
  static BorderRadius get bottomSheet => BorderRadius.vertical(top: Radius.circular(sheet));

  /// انحناء مخصص بحواف علوية فقط
  static BorderRadius top(double radius) => BorderRadius.vertical(top: Radius.circular(radius));

  /// انحناء مخصص بحواف سفلية فقط
  static BorderRadius bottom(double radius) => BorderRadius.vertical(bottom: Radius.circular(radius));
}
