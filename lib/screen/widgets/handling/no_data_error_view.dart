import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_images.dart';
import 'package:admin/screen/widgets/handling/base_error_view.dart';
import 'package:flutter/material.dart';

class NoDataErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool? isRetrying;

  const NoDataErrorView({super.key, this.onRetry, this.isRetrying});

  @override
  Widget build(BuildContext context) {
    return BaseErrorView(
      animationPath: AppImages.noData,
      fallbackIcon: Icons.inbox_outlined,
      iconColor: AppColor.greyblack,
      title: "لا توجد بيانات متاحة",
      subtitle: "لم يتم العثور على أي سجلات في هذا القسم حالياً",
      buttonText: "تحديث الصفحة",
      buttonIcon: Icons.refresh_rounded,
      onRetry: onRetry,
      isRetrying: isRetrying,
    );
  }
}
