import 'package:admin/controller/items/viewitem_controller.dart';
import 'package:get/get.dart';

class ItemsBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<ViewItemsControllerImp>(() => ViewItemsControllerImp());
  }
}