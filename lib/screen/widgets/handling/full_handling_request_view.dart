import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/screen/widgets/handling/no_data_error_view.dart';
import 'package:admin/screen/widgets/handling/offline_error_view.dart';
import 'package:admin/screen/widgets/handling/server_error_view.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 🔄 المعالج الشامل لحالات الطلب على مستوى الشاشة الكاملة مع وميض أبيض مائل للرمادي الفاتح
class FullHandlingRequestView extends StatelessWidget {
  final Staterequest staterequest;
  final Widget child;
  final VoidCallback? onRetry;

  const FullHandlingRequestView({
    super.key,
    required this.staterequest,
    required this.child,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (staterequest) {
      case Staterequest.offlinefailure:
        return OfflineErrorView(onRetry: onRetry);

      case Staterequest.serverfailure:
      case Staterequest.serverException:
        return ServerErrorView(onRetry: onRetry);

      case Staterequest.failure:
        return NoDataErrorView(onRetry: onRetry);

      case Staterequest.loading:
        return SkeletonizerConfig(
          data: const SkeletonizerConfigData(
            effect: ShimmerEffect(
              baseColor: Color(0xFFF1F4F8), // أبيض ناعم جداً مائل للرمادي
              highlightColor: Color(0xFFFFFFFF), // أبيض ناصع
              duration: Duration(milliseconds: 1300),
            ),
            containersColor: Color(0xFFF8FAFC),
            justifyMultiLineText: true,
          ),
          child: Skeletonizer(
            enabled: true,
            child: child,
          ),
        );

      default:
        return Skeletonizer(
          enabled: false,
          child: child,
        );
    }
  }
}
