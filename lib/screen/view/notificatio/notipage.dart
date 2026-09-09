import 'package:admin/controller/notifiction/notifiction.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:jiffy/jiffy.dart';

class Notipage extends StatelessWidget {
  const Notipage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NoticitionController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "سجل التنبيهات والإشعارات",
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E242B),
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<NoticitionController>(
        builder: (controller) => HandlingRequestView(
          onRetry: () => controller.getdata(),
          staterequest: controller.staterequest,
          widget: controller.listData.isEmpty
              ? Center(
                  child: Text(
                    "لا توجد إشعارات سابقة",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppColor.preimary,
                  backgroundColor: Colors.white,
                  onRefresh: () async => controller.getdata(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    itemCount: controller.listData.length,
                    itemBuilder: (context, index) {
                      final notification = controller.listData[index];
                      final String timeAgo = (notification.notificationCreated.isNotEmpty)
                          ? Jiffy.parse(notification.notificationCreated).fromNow()
                          : "";

                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.card,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(14.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: AppColor.preimary.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconsaxPlusBold.notification_bing,
                                  color: AppColor.preimary,
                                  size: 20.r,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification.notificationTitle,
                                            style: TextStyle(
                                              fontFamily: 'IBMPlexSansArabic',
                                              fontSize: 13.5.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF1E242B),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          timeAgo,
                                          style: TextStyle(
                                            fontFamily: 'IBMPlexSansArabic',
                                            fontSize: 10.5.sp,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      notification.notificationBody,
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
