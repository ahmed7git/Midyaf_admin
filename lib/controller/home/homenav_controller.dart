import 'package:admin/screen/view/catalog/catalog_hub_screen.dart';
import 'package:admin/screen/view/home/home.dart';
import 'package:admin/screen/view/home/quick_operations_screen.dart';
import 'package:admin/screen/widgets/order/orderhome/homeorder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

abstract class HomeNavController extends GetxController {
  changePage(int page);
}

class HomeNavControllerImp extends HomeNavController {
  int currentPage = 0;

  List barNav = [
    {
      "name": "الرئيسية",
      "icon_broken": IconsaxPlusBroken.chart_2,
      "icon_bold": IconsaxPlusBold.chart_2,
    },
    {
      "name": "العمليات",
      "icon_broken": IconsaxPlusBroken.flash_1,
      "icon_bold": IconsaxPlusBold.flash_1,
    },
    {
      "name": "الطلبات",
      "icon_broken": IconsaxPlusBroken.bag_2,
      "icon_bold": IconsaxPlusBold.bag_2,
    },
    {
      "name": "الكتالوج",
      "icon_broken": IconsaxPlusBroken.box_1,
      "icon_bold": IconsaxPlusBold.box_1,
    },
  ];

  List<Widget> listPage = [
    const Home(),
    const QuickOperationsScreen(),
    const OrderHome(),
    const CatalogHubScreen(),
  ];

  @override
  changePage(int page) {
    currentPage = page;
    update();
  }
}
