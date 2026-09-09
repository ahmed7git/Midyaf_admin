import 'dart:async';
import 'dart:ui';
import 'package:admin/applink.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/data/model/slider_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 🖼️ السلايدر التفاعلي المتطابق بالكامل مع تطبيق العميل (Delever Exact Slider - 260h Centered)
class SliderHomePreview extends StatefulWidget {
  final List<SliderModel> sliderData;
  const SliderHomePreview({super.key, required this.sliderData});

  @override
  State<SliderHomePreview> createState() => _SliderHomePreviewState();
}

class _SliderHomePreviewState extends State<SliderHomePreview> {
  int _currentPage = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.sliderData.isEmpty || !mounted) return;

      if (_currentPage < widget.sliderData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant SliderHomePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sliderData.length != widget.sliderData.length) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sliderData.isEmpty) {
      return Skeleton.leaf(
        child: Container(
          width: double.infinity,
          height: 260.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: AppRadius.card,
          ),
          child: const Center(
            child: Icon(Icons.image_outlined, size: 50, color: Colors.black26),
          ),
        ),
      );
    }

    return Container(
      height: 260.h,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.sliderData.length,
            itemBuilder: (context, index) {
              final slider = widget.sliderData[index];
              final String imageName = slider.sliderImage ?? "";

              return CachedNetworkImage(
                imageUrl: "${Applink.sliderImage}/$imageName",
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Skeleton.leaf(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF2A0606),
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 45.r,
                    color: Colors.white54,
                  ),
                ),
              );
            },
          ),

          // المؤشر الزجاجي العائم أسفل السلايدر المتطابق تماماً مع تطبيق delever
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 0.8.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.sliderData.length, (index) {
                        final bool isActive = _currentPage == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          width: isActive ? 20.w : 6.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFF97316) // برتقالي Delever المميز
                                : Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFFF97316).withValues(alpha: 0.5),
                                      blurRadius: 6.r,
                                      spreadRadius: 1.r,
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
