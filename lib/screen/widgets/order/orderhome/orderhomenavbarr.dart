import 'package:admin/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class OrderHomenavbarr extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final IconData icon;
  final bool isActive;

  const OrderHomenavbarr({
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
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColor.preimary : AppColor.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? AppColor.preimary : AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
