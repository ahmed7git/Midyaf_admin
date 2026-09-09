import 'dart:async';
import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/reoute.dart';
import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/core/services/services.dart';
import 'package:admin/data/model/order_model.dart';
import 'package:admin/data/remote/order/orderdata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderaccptedController extends GetxController {
  MyServices myServices = Get.find<MyServices>();
  OrderData orderData = OrderData(Get.find());
  Staterequest staterequest = Staterequest.none;
  List<OrderModel> listData = [];
  String? method;
  String? type;
  List<OrderModel> completedOrders = [];
  Timer? _autoRefreshTimer;

  String printPaymentmethod(String val) {
    if (val == "0") {
      return "الدفع عند الاستلام (Cash)";
    } else {
      return "الدفع عبر البطاقة (Card)";
    }
  }

  String printOrderType(String val) {
    if (val == "0") {
      return "توصيل";
    } else {
      return "استلام من المتجر";
    }
  }

  Future<void> getdata({bool isBackground = false}) async {
    if (!isBackground) {
      listData.clear();
      completedOrders.clear();
      staterequest = Staterequest.loading;
      update();
    }

    // 1. محاولة جلب الطلبات المقبولة عبر viewaccepted
    var response = await orderData.viewaccepted();
    var state = handlingData(response);

    if (state == Staterequest.success &&
        response['status'] == "success" &&
        response['data'] is List) {
      List order = response['data'];
      listData.clear();
      listData.addAll(order.map((e) => OrderModel.fromJson(e)));
      completedOrders = listData;
      staterequest = Staterequest.success;
    } else {
      // 2. Fallback: جلب كافة الطلبات واستخراج الطلبات المقبولة (status >= 1)
      var allOrdersRes = await orderData.view();
      state = handlingData(allOrdersRes);
      if (state == Staterequest.success &&
          allOrdersRes['status'] == "success" &&
          allOrdersRes['data'] is List) {
        List order = allOrdersRes['data'];
        listData.clear();
        listData.addAll(order.map((e) => OrderModel.fromJson(e)));
        completedOrders = listData.where((e) {
          int s = e.orderStatus ?? 0;
          return s >= 1;
        }).toList();
        staterequest = Staterequest.success;
      } else {
        if (!isBackground) {
          staterequest = Staterequest.failure;
        }
      }
    }

    if (listData.isNotEmpty) {
      method = listData[0].orderPaymentmethod.toString();
      type = listData[0].orderType.toString();
    }
    update();
  }

  deletedata(String orderid) async {
    staterequest = Staterequest.loading;
    update();

    var response = await orderData.delete(orderid);
    staterequest = handlingData(response);

    if (staterequest == Staterequest.success) {
      if (response['status'] == "success") {
        Get.snackbar(
          "نجاح",
          "تم حذف الطلب بنجاح",
          backgroundColor: AppColor.preimary,
          colorText: Colors.white,
        );
        getdata();
      } else {
        staterequest = Staterequest.failure;
        update();
      }
    } else {
      update();
    }
  }

  refrechorder() {
    getdata();
  }

  orderdetils(String id, String addressid) {
    Get.toNamed(AppRoutes.orderdetil, arguments: {
      "orderid": id,
      "addressid": addressid,
    });
  }

  void startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      getdata(isBackground: true);
    });
  }

  @override
  void onInit() {
    getdata();
    startAutoRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    _autoRefreshTimer?.cancel();
    super.onClose();
  }
}
