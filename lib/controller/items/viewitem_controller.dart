import 'package:admin/core/constant/reoute.dart';
import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/model/itemsmodel.dart';
import 'package:admin/data/remote/items/itemsdata.dart';
import 'package:get/get.dart';

abstract class ViewItemsController extends GetxController {
  getData();
}

class ViewItemsControllerImp extends ViewItemsController {
  List<ItemsModel> items = [];
  Staterequest staterequest = Staterequest.none;
  Itemsdata itemsdata = Itemsdata(Get.find());

  @override
  getData() async {
    staterequest = Staterequest.loading;
    update();
    var response = await itemsdata.postData();
    staterequest = handlingData(response);
    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        items.clear();
        List responseData = response['data'];
        items.addAll(responseData.map((e) => ItemsModel.fromJson(e)));
      } else {
        staterequest = Staterequest.failure;
      }
    }
    update();
  }

  goToAddItem() async {
    await Get.toNamed(AppRoutes.additem);
    getData();
  }

  deleteitem(id, image) async {
    await itemsdata.deleteData(id, image);
    items.removeWhere((element) => element.itemsId == id);
    getData();
  }

  goToEditItem(ItemsModel items) async {
    await Get.toNamed(AppRoutes.edititem, arguments: {
      "items": items,
    });
    getData();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
