import 'package:admin/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class Homenavbarr extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;
  final bool isActive;

  const Homenavbarr({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: isActive ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        builder: (context, progress, child) {
          final double scale = 1.0 - (0.12 * progress * (1.0 - progress) * 4);

          final Color iconColor = Color.lerp(
            Colors.grey.shade400,
            AppColor.preimary,
            progress,
          )!;

          return Transform.scale(
            scale: scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        Color.lerp(Colors.grey.shade400, AppColor.primaryMedium, progress)!,
                        Color.lerp(Colors.grey.shade400, AppColor.preimary, progress)!,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    icon,
                    size: 24,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 10.5,
                    fontWeight: progress > 0.5 ? FontWeight.bold : FontWeight.normal,
                    color: Color.lerp(Colors.grey.shade500, AppColor.preimary, progress),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
