import 'package:admin/core/constant/app_color.dart';
import 'package:admin/screen/widgets/handling/base_error_view.dart';
import 'package:flutter/material.dart';

class ServerErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool? isRetrying;

  const ServerErrorView({super.key, this.onRetry, this.isRetrying});

  @override
  Widget build(BuildContext context) {
    return BaseErrorView(
      animationPath: null,
      fallbackIcon: Icons.dns_rounded,
      iconColor: AppColor.danger,
      title: "خطأ في الاتصال بالخادم",
      subtitle: "تعذر الاتصال بالخادم حالياً، يرجى المحاولة بعد لحظات",
      buttonText: "إعادة المحاولة",
      buttonIcon: Icons.refresh_rounded,
      onRetry: onRetry,
      isRetrying: isRetrying,
    );
  }
}
