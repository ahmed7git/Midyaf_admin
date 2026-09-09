import 'package:admin/core/constant/reoute.dart';
import 'package:admin/core/services/services.dart';
import 'package:get/get.dart';

abstract class HomeController extends GetxController {
  getToCategories();
  getToViewUser();
  getToProducts();
  getToOrders();
  signOut();
}

class HomeControllerImp extends HomeController {
  @override
  getToCategories() {
    Get.toNamed(AppRoutes.categories);
  }

  @override
  getToProducts() {
    Get.toNamed(AppRoutes.items);
  }

  
  @override
  getToViewUser() {
    Get.toNamed(AppRoutes.viewUser);
  }

  @override
  getToOrders() {
    Get.toNamed(AppRoutes.orders);
  }

  @override
  signOut() {
    Get.defaultDialog(
      title: "تسجيل الخروج",
      middleText: "هل أنت متأكد من تسجيل الخروج؟",
      onConfirm: () {
        Get.offAllNamed(AppRoutes.login);
        MyServices myServices = Get.find<MyServices>();
        myServices.box.delete("token");
        myServices.box.delete("id");
      },
      onCancel: () {
        Get.back();
      },
      textConfirm: "نعم",
      textCancel: "لا",
    );
  }




 

  
    
  }



