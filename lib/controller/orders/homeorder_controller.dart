import 'package:admin/screen/view/order/orderaccept.dart';
import 'package:admin/screen/view/order/orderspage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

abstract class OrderHomeNavController extends GetxController {
  changePage(int page);
}

class OrderHomeNavControllerImp extends OrderHomeNavController {
  int currentPage = 0;
  List pageName = ["الطلبات الجديدة", "الطلبات المقبولة"];
  List barNav = [
    {
      "name": "الطلبات الجديدة",
      "icon_broken": IconsaxPlusBroken.receipt_1,
      "icon_bold": IconsaxPlusBold.receipt_1,
    },
    {
      "name": "الطلبات المقبولة",
      "icon_broken": IconsaxPlusBroken.tick_circle,
      "icon_bold": IconsaxPlusBold.tick_circle,
    },
  ];

  List<Widget> listPage = [
    const Orderspage(),
    const Orderaccept(),
  ];

  @override
  changePage(int page) {
    currentPage = page;
    update();
  }
}
