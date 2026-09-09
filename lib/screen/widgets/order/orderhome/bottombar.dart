import 'package:admin/controller/orders/homeorder_controller.dart';
import 'package:admin/screen/widgets/order/orderhome/orderhomenavbarr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottombar extends StatelessWidget {
  const Bottombar({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderHomeNavControllerImp());
    return GetBuilder<OrderHomeNavControllerImp>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OrderHomenavbarr(
              onPressed: () {
                controller.changePage(0);
              },
              text: "${controller.barNav[0]['name']}",
              icon: controller.currentPage == 0
                  ? controller.barNav[0]['icon_bold']
                  : controller.barNav[0]['icon_broken'],
              isActive: controller.currentPage == 0,
            ),
            OrderHomenavbarr(
              onPressed: () {
                controller.changePage(1);
              },
              text: "${controller.barNav[1]['name']}",
              icon: controller.currentPage == 1
                  ? controller.barNav[1]['icon_bold']
                  : controller.barNav[1]['icon_broken'],
              isActive: controller.currentPage == 1,
            ),
          ],
        ),
      ),
    );
  }
}