import 'dart:math';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_images.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:admin/screen/widgets/common/sar_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// 📈 مخطط حركة المبيعات التفاعلي فائق الاحترافية (Interactive Fintech Sales Spline Chart)
class AdminSalesChart extends StatefulWidget {
  final List<AdminSalesChartPoint> chartData;

  const AdminSalesChart({super.key, required this.chartData});

  @override
  State<AdminSalesChart> createState() => _AdminSalesChartState();
}

class _AdminSalesChartState extends State<AdminSalesChart>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1;
  late AnimationController _animController;
  late Animation<double> _animCurve;
  bool isRevenueMode = true; // true: مبيعات بالريال | false: عدد الطلبات

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animCurve = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

    // افتراضياً تحديد آخر نقطة نشطة
    if (widget.chartData.isNotEmpty) {
      selectedIndex = widget.chartData.length - 1;
    }
  }

  @override
  void didUpdateWidget(covariant AdminSalesChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chartData != widget.chartData) {
      _animController.reset();
      _animController.forward();
      if (widget.chartData.isNotEmpty) {
        selectedIndex = widget.chartData.length - 1;
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chartData.isEmpty) {
      return const SizedBox.shrink();
    }

    final double totalRevenue = widget.chartData.fold(
      0.0,
      (sum, p) => sum + p.amount,
    );
    final int totalOrders = widget.chartData.fold(
      0,
      (sum, p) => sum + p.orderCount,
    );

    final selectedPoint =
        (selectedIndex >= 0 && selectedIndex < widget.chartData.length)
        ? widget.chartData[selectedIndex]
        : widget.chartData.last;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColor.borderLight, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. رأس المخطط: العنوان + مبدل النمط (مبيعات / طلبات)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LottieBuilder.asset(
                    AppImages.chart,
                    height: 30.h,
                    width: 40.w,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      "مؤشر حركة المبيعات",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              // زر التبديل بين المبيعات وعدد الطلبات
              Container(
                height: 30.h,
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: AppRadius.radiusFull,
                  border: Border.all(color: AppColor.borderLight, width: 1.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildModeButton(
                      label: "المبيعات",
                      isSelected: isRevenueMode,
                      onTap: () {
                        setState(() {
                          isRevenueMode = true;
                          _animController.reset();
                          _animController.forward();
                        });
                      },
                    ),
                    _buildModeButton(
                      label: "الطلبات",
                      isSelected: !isRevenueMode,
                      onTap: () {
                        setState(() {
                          isRevenueMode = false;
                          _animController.reset();
                          _animController.forward();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // 2. القيمة المحددة التفاعلية
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (isRevenueMode)
                SarPriceWidget(
                  price: selectedPoint.amount,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColor.textPrimary,
                  ),
                  symbolColor: AppColor.preimary,
                  symbolSize: 16.r,
                )
              else
                Text(
                  "${selectedPoint.orderCount} طلبات",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColor.textPrimary,
                  ),
                ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: AppRadius.badge,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 11.r,
                      color: const Color(0xFF10B981),
                    ),
                    Text(
                      selectedPoint.dayName.isNotEmpty
                          ? selectedPoint.dayName
                          : selectedPoint.date,
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              if (isRevenueMode)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "الإجمالي: ",
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    SarPriceWidget(
                      price: totalRevenue,
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.preimary,
                      ),
                      symbolColor: AppColor.preimary,
                      symbolSize: 10.r,
                    ),
                  ],
                )
              else
                Text(
                  "الإجمالي: $totalOrders طلب",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textSecondary,
                  ),
                ),
            ],
          ),

          SizedBox(height: 16.h),

          // 3. الرسم البياني الانسيابي التفاعلي (Interactive Bezier Spline Chart)
          AnimatedBuilder(
            animation: _animCurve,
            builder: (context, child) {
              return SizedBox(
                height: 135.h,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onPanDown: (details) => _handleTouch(
                        details.localPosition,
                        constraints.maxWidth,
                      ),
                      onPanUpdate: (details) => _handleTouch(
                        details.localPosition,
                        constraints.maxWidth,
                      ),
                      child: CustomPaint(
                        size: Size(constraints.maxWidth, 135.h),
                        painter: _SalesChartPainter(
                          points: widget.chartData,
                          selectedIndex: selectedIndex,
                          progress: _animCurve.value,
                          isRevenueMode: isRevenueMode,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          SizedBox(height: 8.h),

          // 4. مسميات الأيام / الفترات أسفل الرسم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.chartData.length, (index) {
              final pt = widget.chartData[index];
              final bool isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.primaryLight
                        : Colors.transparent,
                    borderRadius: AppRadius.badge,
                  ),
                  child: Text(
                    pt.dayName.isNotEmpty ? pt.dayName : pt.date,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 10.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColor.preimary
                          : AppColor.textMuted,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _handleTouch(Offset localPos, double totalWidth) {
    if (widget.chartData.length <= 1) return;
    final double step = totalWidth / (widget.chartData.length - 1);
    final int touchedIndex = (localPos.dx / step).round().clamp(
      0,
      widget.chartData.length - 1,
    );
    if (touchedIndex != selectedIndex) {
      setState(() {
        selectedIndex = touchedIndex;
      });
    }
  }

  Widget _buildModeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: AppRadius.radiusFull,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4.r,
                    offset: Offset(0, 1.h),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 10.5.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppColor.preimary : AppColor.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// 🎨 Custom Painter لرسم المنحنى الانسيابي وتظليل التدرج اللوني والتفاعلية
class _SalesChartPainter extends CustomPainter {
  final List<AdminSalesChartPoint> points;
  final int selectedIndex;
  final double progress;
  final bool isRevenueMode;

  _SalesChartPainter({
    required this.points,
    required this.selectedIndex,
    required this.progress,
    required this.isRevenueMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final double width = size.width;
    final double height = size.height;
    const double topPadding = 12.0;
    const double bottomPadding = 12.0;
    final double chartHeight = height - topPadding - bottomPadding;

    // 1. حساب القيم والحد الأقصى
    final List<double> values = points
        .map((p) => isRevenueMode ? p.amount : p.orderCount.toDouble())
        .toList();

    double maxValue = values.fold(0.0, (prev, val) => max(prev, val));
    if (maxValue <= 0) maxValue = 1.0;

    // رسم خطوط إرشادية خفيفة (Subtle Horizontal Grid Lines)
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 3; i++) {
      final double y = topPadding + (chartHeight * (i / 3.0));
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    if (points.length == 1) {
      final Offset singlePt = Offset(width / 2, height / 2);
      final Paint ptPaint = Paint()..color = AppColor.preimary;
      canvas.drawCircle(singlePt, 6, ptPaint);
      return;
    }

    final double stepX = width / (points.length - 1);
    final List<Offset> offsets = [];

    for (int i = 0; i < points.length; i++) {
      final double x = i * stepX;
      final double normalizedY = (values[i] / maxValue) * progress;
      final double y = height - bottomPadding - (normalizedY * chartHeight);
      offsets.add(Offset(x, y));
    }

    // 2. بناء مسار المنحنى الانسيابي (Cubic Bezier Spline Path)
    final Path path = Path();
    path.moveTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final Offset p0 = offsets[i];
      final Offset p1 = offsets[i + 1];
      final double controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
      final double controlY1 = p0.dy;
      final double controlX2 = controlX1;
      final double controlY2 = p1.dy;

      path.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
    }

    // 3. رسم تظليل التدرج اللوني تحت المنحنى (Gradient Area Fill)
    final Path fillPath = Path.from(path)
      ..lineTo(offsets.last.dx, height)
      ..lineTo(offsets.first.dx, height)
      ..close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColor.preimary.withValues(alpha: 0.28),
          AppColor.preimary.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(fillPath, fillPaint);

    // 4. رسم خط المنحنى الانسيابي (Spline Line Stroke)
    final Paint linePaint = Paint()
      ..color = AppColor.preimary
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    // 5. رسم نقاط البيانات والخط التفاعلي للنقطة المحددة (Interactive Selected Node)
    for (int i = 0; i < offsets.length; i++) {
      final Offset pt = offsets[i];
      final bool isSelected = (i == selectedIndex);

      if (isSelected) {
        // خط إرشادي رأسي منقط/خفيف
        final Paint indicatorLinePaint = Paint()
          ..color = AppColor.preimary.withValues(alpha: 0.35)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(pt.dx, topPadding),
          Offset(pt.dx, height - bottomPadding),
          indicatorLinePaint,
        );

        // حلقة خارجية متوهجة
        final Paint outerRingPaint = Paint()
          ..color = AppColor.preimary.withValues(alpha: 0.22);
        canvas.drawCircle(pt, 12, outerRingPaint);

        // هالة بيضاء
        final Paint haloPaint = Paint()..color = Colors.white;
        canvas.drawCircle(pt, 6.5, haloPaint);

        // نقطة مركزية ملونة
        final Paint selectedCorePaint = Paint()..color = AppColor.preimary;
        canvas.drawCircle(pt, 4.5, selectedCorePaint);
      } else {
        // نقطة عادية
        final Paint bgPtPaint = Paint()..color = Colors.white;
        canvas.drawCircle(pt, 4.0, bgPtPaint);

        final Paint borderPtPaint = Paint()
          ..color = AppColor.preimary
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(pt, 4.0, borderPtPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SalesChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.progress != progress ||
        oldDelegate.isRevenueMode != isRevenueMode ||
        oldDelegate.points != points;
  }
}
