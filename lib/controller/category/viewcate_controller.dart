import 'package:admin/core/constant/reoute.dart';
import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/model/categories_model.dart';
import 'package:admin/data/remote/categories/categoriesdata.dart';
import 'package:get/get.dart';

abstract class ViewcateController extends GetxController {
  getData();
}

class ViewcateControllerImp extends ViewcateController {
  List<CategoriesModel> categories = [];
  Staterequest staterequest = Staterequest.none;
  Categoriesdata categoriesdata = Categoriesdata(Get.find());

  @override
  getData() async {
    staterequest = Staterequest.loading;
    update();
    var response = await categoriesdata.postData();
    staterequest = handlingData(response);
    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        categories.clear();
        List responseData = response['data'];
        categories.addAll(responseData.map((e) => CategoriesModel.fromJson(e)));
      } else {
        staterequest = Staterequest.failure;
      }
    }
    update();
  }

  goToAddCategory() async {
    await Get.toNamed(AppRoutes.addcategory);
    getData();
  }

  deletecate(id, image) async {
    await categoriesdata.deleteData(id, image);
    categories.removeWhere((element) => element.categoriesId == id);
    getData();
  }

  goToEditCategory(CategoriesModel categories) async {
    await Get.toNamed(AppRoutes.editcategory, arguments: {
      "categories": categories,
    });
    getData();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
