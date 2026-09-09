import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// 🎨 الودجت الأساسي المشترك لجميع شاشات الأخطاء مع مؤشر اللودنج
class BaseErrorView extends StatefulWidget {
  final String? animationPath;
  final IconData fallbackIcon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback? onRetry;
  final bool? isRetrying;

  const BaseErrorView({
    super.key,
    this.animationPath,
    required this.fallbackIcon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonIcon,
    this.onRetry,
    this.isRetrying,
  });

  @override
  State<BaseErrorView> createState() => _BaseErrorViewState();
}

class _BaseErrorViewState extends State<BaseErrorView> {
  bool _internalRetrying = false;

  void _handleRetry() {
    setState(() {
      _internalRetrying = true;
    });
    widget.onRetry?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool showLoading = widget.isRetrying ?? _internalRetrying;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.animationPath != null)
                Lottie.asset(
                  widget.animationPath!,
                  width: 200.r,
                  height: 200.r,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildFallbackIcon(),
                )
              else
                _buildFallbackIcon(),

              SizedBox(height: 16.h),

              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E242B),
                      letterSpacing: -0.2,
                    ),
              ),

              SizedBox(height: 10.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                ),
              ),

              SizedBox(height: 24.h),

              if (widget.onRetry != null)
                SizedBox(
                  width: 190.w,
                  height: 46.h,
                  child: ElevatedButton.icon(
                    onPressed: showLoading ? null : _handleRetry,
                    icon: showLoading
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(widget.buttonIcon, size: 18.r),
                    label: Text(
                      showLoading ? "جاري المحاولة..." : widget.buttonText,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.iconColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 90.r,
      height: 90.r,
      decoration: BoxDecoration(
        color: widget.iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.fallbackIcon,
        size: 44.r,
        color: widget.iconColor,
      ),
    );
  }
}
