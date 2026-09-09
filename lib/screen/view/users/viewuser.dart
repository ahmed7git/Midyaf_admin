import 'package:admin/controller/users/viewuser.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/data/remote/user/userdata.dart';
import 'package:admin/screen/widgets/sheets/add_user_sheet.dart';
import 'package:admin/screen/widgets/sheets/edit_user_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewUser extends StatelessWidget {
  const ViewUser({super.key});

  @override
  Widget build(BuildContext context) {
    ViewuserControllerImp controller = Get.put(ViewuserControllerImp());

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "إدارة المسؤولين والمستخدمين",
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.getData(),
            icon: Icon(
              IconsaxPlusBroken.refresh_2,
              color: AppColor.preimary,
              size: 20.r,
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.preimary.withValues(alpha: 0.28),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => AddUserSheet.show(context),
          backgroundColor: AppColor.preimary,
          foregroundColor: Colors.white,
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(30),
          ),
          icon: Icon(IconsaxPlusBold.user_add, size: 18.r),
          label: Text(
            "إضافة مسؤول",
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 12.5.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: GetBuilder<ViewuserControllerImp>(
        builder: (controller) => HandlingRequestView(
          onRetry: () => controller.getData(),
          staterequest: controller.staterequest,
          widget: controller.users.isEmpty
              ? Center(
                  child: Text(
                    "لا يوجد مسؤولين مسجلين حالياً",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 14.sp,
                      color: AppColor.textMuted,
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppColor.preimary,
                  backgroundColor: Colors.white,
                  onRefresh: () async => controller.getData(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    itemCount: controller.users.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final user = controller.users[index];
                      final String firstLetter = user.adminName.isNotEmpty
                          ? user.adminName[0].toUpperCase()
                          : "A";

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.card,
                          border: Border.all(
                            color: AppColor.borderLight,
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.015),
                              blurRadius: 6.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Row(
                            children: [
                              Container(
                                width: 44.r,
                                height: 44.r,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: AppColor.primaryLight,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  firstLetter,
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.preimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            user.adminName,
                                            style: TextStyle(
                                              fontFamily: 'IBMPlexSansArabic',
                                              fontSize: 13.5.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.primaryLight,
                                            borderRadius: AppRadius.badge,
                                          ),
                                          child: Text(
                                            "مسؤول",
                                            style: TextStyle(
                                              fontFamily: 'IBMPlexSansArabic',
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.preimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      user.adminEmail,
                                      style: TextStyle(
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontSize: 11.sp,
                                        color: AppColor.textSecondary,
                                      ),
                                    ),
                                    if (user.adminPhone.isNotEmpty) ...[
                                      SizedBox(height: 2.h),
                                      Text(
                                        user.adminPhone,
                                        style: TextStyle(
                                          fontFamily: 'IBMPlexSansArabic',
                                          fontSize: 11.sp,
                                          color: AppColor.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (user.adminPhone.isNotEmpty)
                                    IconButton(
                                      onPressed: () async {
                                        final Uri uri = Uri(
                                          scheme: 'tel',
                                          path: user.adminPhone,
                                        );
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      },
                                      icon: const Icon(
                                        IconsaxPlusBold.call,
                                        color: AppColor.preimary,
                                        size: 18,
                                      ),
                                      tooltip: "اتصال",
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.all(6.r),
                                    ),
                                  IconButton(
                                    onPressed: () =>
                                        EditUserSheet.show(context, user),
                                    icon: Icon(
                                      IconsaxPlusBold.edit_2,
                                      color: AppColor.preimary,
                                      size: 18.r,
                                    ),
                                    tooltip: "تعديل",
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.all(6.r),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "حذف المسؤول",
                                        middleText:
                                            "هل أنت متأكد من رغبتك في حذف هذا المسؤول؟",
                                        textConfirm: "نعم، حذف",
                                        textCancel: "إلغاء",
                                        confirmTextColor: Colors.white,
                                        buttonColor: const Color(0xFFEF4444),
                                        onConfirm: () async {
                                          Get.back();
                                          Userdata userdata = Userdata(
                                            Get.find(),
                                          );
                                          await userdata.deleteData(
                                            user.adminId.toString(),
                                          );
                                          controller.getData();
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      IconsaxPlusBold.trash,
                                      color: Color(0xFFEF4444),
                                      size: 18,
                                    ),
                                    tooltip: "حذف",
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.all(6.r),
                                  ),
                                ],
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
