import 'dart:async';
import 'package:admin/core/constant/app_images.dart';
import 'package:admin/core/constant/reoute.dart';
import 'package:admin/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// 🎬 شاشة البداية السينمائية المتطابقة مع تطبيق المندوب (Splash Screen)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    // 🎬 1. أنيميشن المقياس (Scale): ظهور ارتدادي ناعم -> ثبات لحظي -> تكبير وانفجار سينمائي سريع
    _scaleAnimation = TweenSequence<double>([
      // المرحلة الأولى: دخول الشعار بحركة وارتداد أنيق
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      // المرحلة الثانية: ثبات واستقرار لحظي للتأكيد البصري
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      // المرحلة الثالثة: تكبير مفاجئ وانفجار سينمائي سريع يخترق الشاشة
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 28.0)
            .chain(CurveTween(curve: Curves.easeInExpo)),
        weight: 35,
      ),
    ]).animate(_animController);

    // 🌟 2. أنيميشن الشفافية (Fade)
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInQuart)),
        weight: 20,
      ),
    ]).animate(_animController);

    // 💫 3. دوران طفيف جداً وجمالي في بداية الدخول
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.06, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: 55,
      ),
    ]).animate(_animController);

    _animController.forward();

    _navigateNext();
  }

  void _navigateNext() {
    Timer(const Duration(milliseconds: 1850), () {
      if (!mounted) return;
      final MyServices myServices = Get.find<MyServices>();
      final String? step = myServices.box.get("step")?.toString();

      if (step == "1") {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140202),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, 0.0),
            radius: 1.2,
            colors: [
              Color(0xFF6B0808),
              Color(0xFF380303),
              Color(0xFF140202),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SvgPicture.asset(
                      AppImages.logoSvg,
                      width: 150.r,
                      height: 150.r,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
