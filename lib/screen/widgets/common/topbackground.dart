import 'dart:math' as math;
import 'package:admin/core/constant/app_color.dart';
import 'package:flutter/material.dart';

/// 🌊 الخلفية المموجة الحركية الفاخرة للهيدر (Dynamic Wavy Top Background)
class Topbackground extends StatefulWidget {
  final double height;
  final Widget? child;
  final BorderRadius? borderRadius;
  final bool showBottomCurve;

  const Topbackground({
    super.key,
    this.height = 170,
    this.child,
    this.borderRadius,
    this.showBottomCurve = true,
  });

  @override
  State<Topbackground> createState() => _TopbackgroundState();
}

class _TopbackgroundState extends State<Topbackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // دورة حركة انسيابية هادئة وفخمة
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ??
            (widget.showBottomCurve
                ? const BorderRadius.vertical(
                    bottom: Radius.elliptical(500, 70),
                  )
                : null),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8B1E1E), // عنابي متوسط متناسق
            Color(0xFF700505), // عنابي داكن أساسي
            Color(0xFF4A0202), // كستنائي غامق عميق
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryDark.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 🌊 طبقة الموجات والفرش الحركية الانسيابية
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: SoftBrushPainter(
                    animationValue: _controller.value,
                  ),
                );
              },
            ),
          ),

          // المحتوى إن وجد داخل الهيدر
          if (widget.child != null) Positioned.fill(child: widget.child!),
        ],
      ),
    );
  }
}

class SoftBrushPainter extends CustomPainter {
  final double animationValue;

  SoftBrushPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final double wave1 = math.sin(animationValue * 2 * math.pi) * 10.0;
    final double wave2 = math.cos(animationValue * 2 * math.pi) * 12.0;
    final double wave3 = math.sin((animationValue + 0.5) * 2 * math.pi) * 8.0;

    // 🟢 الطبقة الأولى: موجة علوية مضيئة
    final paint1 = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.14),
          Colors.white.withValues(alpha: 0.0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.4 + wave1);
    path1.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.8 + wave2,
      size.width,
      size.height * 0.2 + wave1,
    );
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();
    canvas.drawPath(path1, paint1);

    // 🟢 الطبقة الثانية: موجة سفلية (عمق وظل داكن)
    final paint2 = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.black.withValues(alpha: 0.25),
          Colors.transparent,
        ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.9 - wave2,
      size.width,
      size.height * 0.4 + wave3,
    );
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);

    // 🟢 الطبقة الثالثة: موجة وسطى متداخلة ناعمة
    final paint3 = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.0),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final path3 = Path();
    path3.moveTo(0, size.height * 0.65 + wave3);
    path3.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.4 + wave1,
      size.width,
      size.height * 0.7 - wave2,
    );
    path3.lineTo(size.width, 0);
    path3.lineTo(0, 0);
    path3.close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant SoftBrushPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
