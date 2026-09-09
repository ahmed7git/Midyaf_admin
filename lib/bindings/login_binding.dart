
import 'package:admin/controller/auth/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<LoginControllerImp>(() => LoginControllerImp());
  }
}