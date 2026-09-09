
import 'package:admin/controller/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<HomeControllerImp>(() => HomeControllerImp());
  }
}