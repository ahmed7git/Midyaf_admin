import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_images.dart';
import 'package:admin/screen/widgets/handling/base_error_view.dart';
import 'package:flutter/material.dart';

class OfflineErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool? isRetrying;

  const OfflineErrorView({super.key, this.onRetry, this.isRetrying});

  @override
  Widget build(BuildContext context) {
    return BaseErrorView(
      animationPath: AppImages.nointernet,
      fallbackIcon: Icons.wifi_off_rounded,
      iconColor: AppColor.preimary,
      title: "لا يوجد اتصال بالإنترنت",
      subtitle: "يرجى التحقق من اتصال الشبكة وإعادة المحاولة",
      buttonText: "إعادة المحاولة",
      buttonIcon: Icons.refresh_rounded,
      onRetry: onRetry,
      isRetrying: isRetrying,
    );
  }
}
