import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/model/coupon_model.dart';
import 'package:admin/data/remote/coupon/coupon_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponControllerImp extends GetxController {
  Staterequest staterequest = Staterequest.none;
  final CouponData couponData = CouponData(Get.find());
  List<CouponModel> coupons = [];

  // Controllers for Adding/Editing Coupon
  late TextEditingController nameController;
  late TextEditingController countController;
  late TextEditingController discountController;
  late TextEditingController expireDateController;
  int couponStatus = 1;
  CouponModel? editingCoupon;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  getData() async {
    staterequest = Staterequest.loading;
    update();

    var response = await couponData.viewData();
    staterequest = handlingData(response);

    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        coupons.clear();
        List responseData = response['data'];
        coupons.addAll(responseData.map((e) => CouponModel.fromJson(e)));
      } else {
        staterequest = Staterequest.failure;
      }
    }
    update();
  }

  Future<void> pickExpireDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(2020);
    final DateTime lastDate = DateTime(2035);
    DateTime initialDate = now.add(const Duration(days: 7));

    if (expireDateController.text.trim().isNotEmpty) {
      try {
        DateTime parsed = DateTime.parse(expireDateController.text.trim());
        if (parsed.year >= 2020 && parsed.year <= 2035) {
          initialDate = parsed;
        }
      } catch (_) {}
    }

    if (initialDate.isBefore(firstDate)) {
      initialDate = now;
    }
    if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.preimary,
              onPrimary: Colors.white,
              onSurface: AppColor.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate =
          "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} 23:59:59";
      expireDateController.text = formattedDate;
      update();
    }
  }

  void initEditData(CouponModel coupon) {
    editingCoupon = coupon;
    nameController.text = coupon.couponName ?? '';
    countController.text = coupon.couponCount?.toString() ?? '';
    discountController.text = coupon.couponDiscount?.toStringAsFixed(0) ?? '';
    expireDateController.text = coupon.couponExpiredate ?? '';
    couponStatus = coupon.couponStatus ?? 1;
  }

  void clearForm() {
    editingCoupon = null;
    nameController.clear();
    countController.clear();
    discountController.clear();
    expireDateController.clear();
    couponStatus = 1;
  }

  addCoupon() async {
    if (formState.currentState!.validate()) {
      staterequest = Staterequest.loading;
      update();

      Map<String, String> data = {
        "coupon_name": nameController.text.trim().toUpperCase(),
        "coupon_count": countController.text.trim(),
        "coupon_discount": discountController.text.trim(),
        "coupon_expiredate": expireDateController.text.trim(),
        "coupon_type": "1",
        "coupon_status": couponStatus.toString(),
      };

      var response = await couponData.addData(data);
      staterequest = handlingData(response);

      if (Staterequest.success == staterequest) {
        if (response['status'] == "success") {
          Get.back();
          clearForm();
          getData();
          Get.snackbar(
            "تمت العملية",
            "تمت إضافة الكوبون بنجاح",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        } else {
          Get.snackbar(
            "تنبيه",
            response['message'] ?? "تعذر إضافة الكوبون",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
          staterequest = Staterequest.failure;
        }
      }
      update();
    }
  }

  editCoupon() async {
    if (formState.currentState!.validate() && editingCoupon != null) {
      staterequest = Staterequest.loading;
      update();

      Map<String, String> data = {
        "id": editingCoupon!.couponId.toString(),
        "coupon_id": editingCoupon!.couponId.toString(),
        "coupon_name": nameController.text.trim().toUpperCase(),
        "coupon_count": countController.text.trim(),
        "coupon_discount": discountController.text.trim(),
        "coupon_expiredate": expireDateController.text.trim(),
        "coupon_status": couponStatus.toString(),
      };

      var response = await couponData.editData(data);
      staterequest = handlingData(response);

      if (Staterequest.success == staterequest) {
        if (response['status'] == "success") {
          Get.back();
          clearForm();
          getData();
          Get.snackbar(
            "تمت العملية",
            "تم تعديل الكوبون بنجاح",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        } else {
          Get.snackbar(
            "تنبيه",
            response['message'] ?? "تعذر تعديل الكوبون",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
          staterequest = Staterequest.failure;
        }
      }
      update();
    }
  }

  deleteCoupon(String couponId) async {
    staterequest = Staterequest.loading;
    update();

    var response = await couponData.deleteData(couponId);
    staterequest = handlingData(response);

    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        coupons.removeWhere((element) => element.couponId.toString() == couponId);
        update();
        Get.snackbar(
          "تم الحذف",
          "تم حذف الكوبون بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      } else {
        Get.snackbar(
          "تنبيه",
          response['message'] ?? "تعذر حذف الكوبون",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      }
    } else {
      Get.snackbar(
        "خطأ",
        "تعذر الاتصال بالخادم لحذف الكوبون",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    }
    update();
  }

  @override
  void onInit() {
    nameController = TextEditingController();
    countController = TextEditingController();
    discountController = TextEditingController();
    expireDateController = TextEditingController();
    getData();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    countController.dispose();
    discountController.dispose();
    expireDateController.dispose();
    super.dispose();
  }
}
