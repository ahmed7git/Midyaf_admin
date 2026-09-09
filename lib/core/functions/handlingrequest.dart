import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/screen/widgets/handling/error_screens.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HandlingRequest extends StatelessWidget {
  final Staterequest staterequest;
  final Widget widget;
  const HandlingRequest({
    super.key,
    required this.staterequest,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    if (staterequest == Staterequest.loading) {
      return SkeletonizerConfig(
        data: const SkeletonizerConfigData(
          effect: ShimmerEffect(
            baseColor: Color(0xFFF1F4F8), // أبيض مائل للرمادي الناعم
            highlightColor: Color(0xFFFFFFFF), // أبيض ناصع
            duration: Duration(milliseconds: 1300),
          ),
          containersColor: Color(0xFFF8FAFC),
          justifyMultiLineText: true,
        ),
        child: Skeletonizer(
          enabled: true,
          child: widget,
        ),
      );
    }
    return widget;
  }
}

class HandlingRequestView extends StatelessWidget {
  final Staterequest staterequest;
  final Widget widget;
  final VoidCallback? onRetry;

  const HandlingRequestView({
    super.key,
    required this.staterequest,
    required this.widget,
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
              baseColor: Color(0xFFF1F4F8),
              highlightColor: Color(0xFFFFFFFF),
              duration: Duration(milliseconds: 1300),
            ),
            containersColor: Color(0xFFF8FAFC),
            justifyMultiLineText: true,
          ),
          child: Skeletonizer(
            enabled: true,
            child: widget,
          ),
        );

      default:
        return widget;
    }
  }
}
