import 'package:admin/controller/orders/oreder_controller.dart';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/reoute.dart';
import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/core/services/services.dart';
import 'package:admin/data/model/order_model.dart';
import 'package:admin/data/remote/order/orderdata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderdetilsController extends GetxController {
  MyServices myServices = Get.find<MyServices>();
  OrderData orderData = OrderData(Get.find());
  Staterequest staterequest = Staterequest.none;
  List<OrderModel> listData = [];
  String? orderid;

  getdata() async {
    if (orderid == null) return;
    listData.clear();
    staterequest = Staterequest.loading;
    update();

    var response = await orderData.detils(orderid!);
    staterequest = handlingData(response);

    if (staterequest == Staterequest.success) {
      if (response['status'] == "success") {
        List order = response['data'];
        listData.addAll(order
            .map((e) => OrderModel.fromJson(e))
            .where((e) => e.orderId.toString() == orderid)
            .toList());
      } else {
        staterequest = Staterequest.failure;
      }
    } else {
      staterequest = Staterequest.failure;
    }
    update();
  }

  Future<void> changeOrderStatus(int newStatus) async {
    if (orderid == null) return;
    staterequest = Staterequest.loading;
    update();

    var response = await orderData.updateStatus(
      orderid!,
      newStatus.toString(),
    );

    staterequest = handlingData(response);
    if (staterequest == Staterequest.success && response['status'] == "success") {
      Get.snackbar(
        "تم التحديث",
        "تم تحديث حالة مسار الطلب بنجاح",
        backgroundColor: AppColor.preimary,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      await getdata();
      // تحديث قائمة الطلبات في الصفحة الرئيسية إن وجدت
      if (Get.isRegistered<OrderController>()) {
        Get.find<OrderController>().getdata();
      }
    } else {
      Get.snackbar(
        "تنبيه",
        response['message'] ?? "تعذر تحديث حالة الطلب",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
    update();
  }

  goToTracking() {
    Get.toNamed(AppRoutes.tracking);
  }

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments['orderid'] != null) {
      orderid = Get.arguments['orderid'].toString();
      getdata();
    }
    super.onInit();
  }
}