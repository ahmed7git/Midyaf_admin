import 'package:admin/controller/users/viewuser.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/core/functions/validinput.dart';
import 'package:admin/data/model/user_model.dart';
import 'package:admin/data/remote/user/userdata.dart';
import 'package:admin/screen/widgets/auth/coustombuttom.dart';
import 'package:admin/screen/widgets/auth/customtextinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// 👤 شيت تعديل بيانات المسؤول (Edit Admin Bottom Sheet)
class EditUserSheet extends StatefulWidget {
  final UserModel user;
  const EditUserSheet({super.key, required this.user});

  static void show(BuildContext context, UserModel user) {
    Get.bottomSheet(
      EditUserSheet(user: user),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<EditUserSheet> createState() => _EditUserSheetState();
}

class _EditUserSheetState extends State<EditUserSheet> {
  late TextEditingController userName;
  late TextEditingController userEmail;
  late TextEditingController userPhone;
  late TextEditingController userPassword;
  String userRole = "1";
  String userStatus = "1";
  bool isLoading = false;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final Userdata userdata = Userdata(Get.find());

  @override
  void initState() {
    super.initState();
    userName = TextEditingController(text: widget.user.adminName);
    userEmail = TextEditingController(text: widget.user.adminEmail);
    userPhone = TextEditingController(text: widget.user.adminPhone);
    userPassword = TextEditingController();
    userRole = widget.user.adminRole.toString();
    userStatus = widget.user.adminStatus.toString();
  }

  @override
  void dispose() {
    userName.dispose();
    userEmail.dispose();
    userPhone.dispose();
    userPassword.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    if (formState.currentState!.validate()) {
      setState(() => isLoading = true);

      Map<String, String> data = {
        "admin_id": widget.user.adminId.toString(),
        "username": userName.text.trim(),
        "email": userEmail.text.trim(),
        "phone": userPhone.text.trim(),
        "role": userRole,
        "status": userStatus,
      };

      if (userPassword.text.trim().isNotEmpty) {
        data["password"] = userPassword.text.trim();
      }

      var response = await userdata.editData(data);
      var staterequest = handlingData(response);

      setState(() => isLoading = false);

      if (staterequest == Staterequest.success) {
        if (response['status'] == "success") {
          Get.back();
          if (Get.isRegistered<ViewuserControllerImp>()) {
            Get.find<ViewuserControllerImp>().getData();
          }
          Get.snackbar(
            "تمت العملية",
            "تم تعديل بيانات المسؤول بنجاح",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        } else {
          Get.snackbar(
            "تنبيه",
            response['message'] ?? "تعذر تعديل بيانات المسؤول",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.88.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.bottomSheet,
      ),
      child: Form(
        key: formState,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColor.primaryLight,
                          borderRadius: AppRadius.badge,
                          border: Border.all(color: AppColor.primaryBorder, width: 1.w),
                        ),
                        child: const Icon(
                          IconsaxPlusBold.user_edit,
                          color: AppColor.preimary,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "تعديل بيانات المسؤول #${widget.user.adminId}",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close_rounded, size: 20.r, color: AppColor.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Customtextinput(
                isPassword: false,
                isNumber: false,
                valid: (val) => validInput(val!, 30, 2, "name"),
                hintText: "اسم المسؤول",
                iconData: IconsaxPlusBroken.user,
                mycontroller: userName,
              ),
              SizedBox(height: 10.h),

              Customtextinput(
                isPassword: false,
                isNumber: false,
                valid: (val) => validInput(val!, 50, 5, "email"),
                hintText: "البريد الإلكتروني",
                iconData: IconsaxPlusBroken.sms,
                mycontroller: userEmail,
              ),
              SizedBox(height: 10.h),

              Customtextinput(
                isPassword: false,
                isNumber: true,
                valid: (val) => validInput(val!, 20, 8, "phone"),
                hintText: "رقم الهاتف",
                iconData: IconsaxPlusBroken.call,
                mycontroller: userPhone,
              ),
              SizedBox(height: 10.h),

              Customtextinput(
                isPassword: true,
                isNumber: false,
                valid: (val) => null,
                hintText: "كلمة المرور الجديدة (اتركها فارغة إذا لم ترد التغيير)",
                iconData: IconsaxPlusBroken.lock,
                mycontroller: userPassword,
              ),
              SizedBox(height: 14.h),

              // حالة الحساب (نشط / معطل)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: AppRadius.cardInner,
                  border: Border.all(color: AppColor.borderLight, width: 1.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "حالة الحساب (نشط)",
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    Switch.adaptive(
                      value: userStatus == "1",
                      activeColor: AppColor.preimary,
                      onChanged: (val) {
                        setState(() => userStatus = val ? "1" : "0");
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              Coustombuttom(
                text: isLoading ? "جاري الحفظ..." : "حفظ التعديلات",
                icon: IconsaxPlusBold.tick_circle,
                onPressed: isLoading ? null : () => _updateUser(),
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}
