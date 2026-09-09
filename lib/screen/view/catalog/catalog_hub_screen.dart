import 'package:admin/bindings/items_binding.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/screen/view/category/categories.dart';
import 'package:admin/screen/view/coupon/coupons_view.dart';
import 'package:admin/screen/view/items/items.dart';
import 'package:admin/screen/view/slider/sliders_view.dart';
import 'package:admin/screen/widgets/common/topbackground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CatalogHubController extends GetxController {
  int currentTab = 0;
  late PageController pageController;

  void changeTab(int index) {
    currentTab = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    update();
  }

  void onPageChanged(int index) {
    currentTab = index;
    update();
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

/// 📦 مركز إدارة الكتالوج والمخزون والعروض الموحد (المنتجات + الأقسام + الكوبونات + السلايدر)
class CatalogHubScreen extends StatelessWidget {
  const CatalogHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ItemsBinding().dependencies();
    final controller = Get.put(CatalogHubController());

    final List<Map<String, dynamic>> tabs = [
      {
        'title': 'المنتجات',
        'icon': IconsaxPlusBold.box_1,
      },
      {
        'title': 'الأقسام',
        'icon': IconsaxPlusBold.category,
      },
      {
        'title': 'الكوبونات',
        'icon': IconsaxPlusBold.ticket_discount,
      },
      {
        'title': 'السلايدر',
        'icon': IconsaxPlusBold.gallery,
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(115.h),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: const Topbackground(
            height: 180,
            showBottomCurve: true,
          ),
          centerTitle: true,
          title: Text(
            "إدارة الكتالوج والعروض",
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(54.h),
            child: GetBuilder<CatalogHubController>(
              builder: (ctrl) => Container(
                height: 40.h,
                margin: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 12.h),
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.w),
                ),
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final tab = tabs[index];
                    final bool isSelected = ctrl.currentTab == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => ctrl.changeTab(index),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 6.r,
                                      offset: Offset(0, 2.h),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  tab['title'],
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 11.5.sp,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? AppColor.preimary : Colors.white,
                                  ),
                                  maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    ),
    body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [
          Items(),
          Categories(),
          CouponsView(),
          SlidersView(),
        ],
      ),
    );
  }
}
