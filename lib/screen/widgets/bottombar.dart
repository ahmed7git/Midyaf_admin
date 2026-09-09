import 'package:admin/controller/home/homenav_controller.dart';
import 'package:admin/screen/widgets/homenavbarr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottombar extends StatelessWidget {
  const Bottombar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeNavControllerImp>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...List.generate(controller.listPage.length + 1, (index) {
            int i = index > 2 ? index - 1 : index;
            bool isActive = controller.currentPage == i;

            return index == 2
                ? const SizedBox(width: 48)
                : Homenavbarr(
                    onPressed: () {
                      controller.changePage(i);
                    },
                    text: "${controller.barNav[i]['name']}",
                    icon: isActive
                        ? controller.barNav[i]['icon_bold']
                        : controller.barNav[i]['icon_broken'],
                    isActive: isActive,
                  );
          }),
        ],
      ),
    );
  }
}
