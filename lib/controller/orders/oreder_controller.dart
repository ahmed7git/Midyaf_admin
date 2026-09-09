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

class OrderController extends GetxController {
  int selectedTab = 0;
  MyServices myServices = Get.find<MyServices>();
  OrderData orderData = OrderData(Get.find());
  late TextEditingController search;
  Staterequest staterequest = Staterequest.none;
  List<OrderModel> listData = [];
  String? method;
  String? type;
  String? status;
  List<OrderModel> currentOrders = []; // الطلبات الجديدة بانتظار الموافقة (status = 0)
  List<OrderModel> acceptedOrders = []; // الطلبات المقبولة قيد التجهيز والتوصيل (status = 1, 2, 3)
  List<OrderModel> completedOrders = []; // الطلبات المكتملة المسلمة (status = 4)
  bool isSearch = false;
  Timer? _autoRefreshTimer;

  String printOrderStatus(String val) {
    if (val == "0") {
      return "بانتظار الموافقة";
    } else if (val == "1") {
      return "قيد التجهيز بالمطبخ";
    } else if (val == "2") {
      return "جاهز للتسليم";
    } else if (val == "3") {
      return "مع كابتن التوصيل";
    } else if (val == "4") {
      return "تم التسليم بنجاح";
    } else {
      return "طلب ملغي";
    }
  }

  String printPaymentmethod(String val) {
    if (val == "0") {
      return "الدفع عند الاستلام (Cash)";
    } else {
      return "الدفع عبر البطاقة (Card)";
    }
  }

  String printOrderType(String val) {
    if (val == "0") {
      return "توصيل إلى موقع العميل";
    } else {
      return "استلام مباشر من المتجر";
    }
  }

  void changeTab(int index) {
    selectedTab = index;
    update();
  }

  /// جلب الطلبات مع دعم التحديث التلقائي بالخلفية بدون إظهار لودينج معطل للواجهة
  Future<void> getdata({bool isBackground = false}) async {
    if (!isBackground) {
      staterequest = Staterequest.loading;
      update();
    }

    var response = await orderData.view();
    var newStatus = handlingData(response);

    if (newStatus == Staterequest.success) {
      if (response['status'] == "success" && response['data'] is List) {
        List order = response['data'];
        List<OrderModel> fetchedOrders =
            order.map((e) => OrderModel.fromJson(e)).toList();

        // فحص ما إذا كان هناك طلبات جديدة في التحديث الخلفي
        if (isBackground && currentOrders.isNotEmpty) {
          final int previousPendingCount = currentOrders.length;
          final int newPendingCount =
              fetchedOrders.where((e) => (e.orderStatus ?? 0) == 0).length;
          if (newPendingCount > previousPendingCount) {
            Get.snackbar(
              "🔔 طلب جديد وارد",
              "تم استلام طلب جديد بانتظار الموافقة",
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xFF10B981),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.all(12),
            );
          }
        }

        listData.clear();
        listData.addAll(fetchedOrders);

        // تصنيف دقيق للطلبات:
        // 1. الطلبات الجديدة بانتظار موافقة الإدارة (status = 0)
        currentOrders =
            listData.where((e) => (e.orderStatus ?? 0) == 0).toList();

        // 2. الطلبات التي تم قبولها وقيد التجهيز والتوصيل (status = 1, 2, 3)
        acceptedOrders = listData.where((e) {
          int s = e.orderStatus ?? 0;
          return s >= 1 && s <= 3;
        }).toList();

        // 3. الطلبات المكتملة المسلمة (status = 4)
        completedOrders =
            listData.where((e) => (e.orderStatus ?? 0) == 4).toList();

        if (listData.isNotEmpty) {
          method = listData[0].orderPaymentmethod.toString();
          type = listData[0].orderType.toString();
          status = listData[0].orderStatus.toString();
        }
        staterequest = Staterequest.success;
      } else {
        if (!isBackground) {
          staterequest = Staterequest.failure;
        }
      }
    } else {
      if (!isBackground) {
        staterequest = newStatus;
      }
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

  accpteOrder(String orderid, String userid) async {
    staterequest = Staterequest.loading;
    update();

    var response = await orderData.accept(
      orderid,
      userid,
      myServices.box.get("id")?.toString() ?? "1",
    );

    staterequest = handlingData(response);
    if (staterequest == Staterequest.success) {
      if (response['status'] == "success") {
        Get.snackbar(
          "تم قبول الطلب",
          response['message'] ?? "تم قبول الطلب بنجاح ونقله إلى قائمة الطلبات المقبولة وقيد التجهيز",
          backgroundColor: AppColor.preimary,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        await getdata();
      } else {
        Get.snackbar(
          "تنبيه",
          response['message'] ?? "فشل قبول الطلب أو تم قبوله مسبقاً",
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } else {
      Get.snackbar(
        "خطأ في الاتصال",
        "تعذر الاتصال بالسيرفر، يرجى التحقق من الشبكة والمحاولة مجدداً",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
    update();
  }

  void startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    // تحديث تلقائي كل 10 ثوانٍ للتحقق من أي طلب جديد فوراً
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      getdata(isBackground: true);
    });
  }

  @override
  void onInit() {
    search = TextEditingController();
    getdata();
    startAutoRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    _autoRefreshTimer?.cancel();
    search.dispose();
    super.onClose();
  }
}
