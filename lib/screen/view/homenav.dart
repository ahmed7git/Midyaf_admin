import 'dart:io';
import 'dart:ui';
import 'package:admin/controller/home/homenav_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/functions/alertexit.dart';
import 'package:admin/screen/widgets/bottombar.dart';
import 'package:admin/screen/widgets/sheets/control_center_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Homenav extends StatelessWidget {
  const Homenav({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeNavControllerImp());

    return GetBuilder<HomeNavControllerImp>(
      builder: (controller) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await Future.delayed(Duration.zero);

          CustomexitDialog.show(
            title: "تنبيه الخروج",
            message: "هل أنت متأكد من رغبتك في إغلاق التطبيق؟",
            buttonTextone: "نعم، خروج",
            buttonTexttwo: "إلغاء",
            onPressedone: () => exit(0),
            onPressedtwo: () => Get.back(),
          );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          backgroundColor: AppColor.background,
          body: controller.listPage.elementAt(controller.currentPage),

          // 🎛️ الزر العائم الأوسط (مركز التحكم والوصول السريع الشامل)
          floatingActionButton: Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  AppColor.primaryMedium,
                  AppColor.preimary,
                  AppColor.primaryDark,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppColor.preimary.withValues(alpha: 0.38),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                ControlCenterSheet.show(context);
              },
              elevation: 0,
              highlightElevation: 0,
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              child: const Icon(
                IconsaxPlusBold.category_2,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          // الشريط السفلي الزجاجي المنحني والمفرغ بدقة
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 20,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipPath(
                clipper: NotchedClipper(
                  shape: const PreciseNotchedShape(dx: -0.0, dy: 0.0),
                  borderRadius: BorderRadius.circular(32),
                  notchMargin: 8,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: BottomAppBar(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    color: Colors.white.withValues(alpha: 0.88),
                    elevation: 0,
                    notchMargin: 8,
                    height: 64,
                    shape: const PreciseNotchedShape(dx: -16.0, dy: 0.0),
                    child: const Bottombar(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PreciseNotchedShape extends NotchedShape {
  final double dx;
  final double dy;
  final double extraMargin;

  const PreciseNotchedShape({
    this.dx = 0.0,
    this.dy = 0.0,
    this.extraMargin = 0.0,
  });

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    final Rect adjustedGuest = guest.inflate(extraMargin).translate(dx, dy);
    return const CircularNotchedRectangle().getOuterPath(host, adjustedGuest);
  }
}

class NotchedClipper extends CustomClipper<Path> {
  final NotchedShape shape;
  final BorderRadius borderRadius;
  final double notchMargin;

  NotchedClipper({
    required this.shape,
    required this.borderRadius,
    this.notchMargin = 8.0,
  });

  @override
  Path getClip(Size size) {
    final Rect host = Offset.zero & size;
    final Rect guest = Rect.fromCircle(
      center: Offset(size.width / 2, 0),
      radius: 29 + notchMargin,
    );

    final Path notchedPath = shape.getOuterPath(host, guest);
    final Path rrectPath = Path()..addRRect(borderRadius.toRRect(host));

    return Path.combine(PathOperation.intersect, notchedPath, rrectPath);
  }

  @override
  bool shouldReclip(covariant NotchedClipper oldClipper) => true;
}
