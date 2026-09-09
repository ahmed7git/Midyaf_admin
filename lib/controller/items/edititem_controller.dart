import 'dart:io';

import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/model/categories_model.dart';
import 'package:admin/data/model/itemsmodel.dart';
import 'package:admin/data/remote/categories/categoriesdata.dart';
import 'package:admin/data/remote/items/itemsdata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditItemControllerImp extends GetxController {
  ItemsModel? items;
  Staterequest staterequest = Staterequest.none;
  Itemsdata itemsdata = Itemsdata(Get.find());
  late TextEditingController itemsNameAr;
  late TextEditingController itemsName;
  late TextEditingController itemsdescrAr;
  late TextEditingController itemsdescr;
  late TextEditingController itemsprice;
  late TextEditingController itemscategories;
  late TextEditingController itemscount;
  late TextEditingController itemsdiscount;
  List<CategoriesModel> categories = []; 
  String? selectedCategoryName; 
  Categoriesdata categoriesdata = Categoriesdata(Get.find());

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  File? file;

  chooseFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!); 
      update(); 
    } else {
      debugPrint("تم إلغاء اختيار الملف");
    }
  }

  addData() async {
    if (formState.currentState!.validate() && items != null) {
      staterequest = Staterequest.loading;
      update();

      Map<String, String> data = {
        "itemsname_ar": itemsNameAr.text,
        "itemsname": itemsName.text,
        "items_descr_ar": itemsdescrAr.text,
        "items_desc": itemsdescr.text,
        "items_categories": itemscategories.text,
        "items_price": itemsprice.text,
        "items_count": itemscount.text,
        "items_discount": itemsdiscount.text,
        "items_id": items!.itemsId.toString(),
        "oldimage": items!.itemsImages,
        "items_date": DateTime.now().toString(),
      };

      var response = await itemsdata.editData(
        data, 
        file,
      );
      staterequest = handlingData(response);
      if (Staterequest.success == staterequest) {
        if (response['status'] == "success") {
          Get.back();
          Get.snackbar(
            "تمت العملية",
            "تم تعديل المنتج بنجاح",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        } else {
          staterequest = Staterequest.failure;
        }
      }
      update();
    }
  }

  getCategories() async {
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

  selectCategory(CategoriesModel category) {
    selectedCategoryName = category.categoriesNameAr;
    itemscategories.text = category.categoriesId.toString();
    update();
  }

  void initData(ItemsModel itemModel) {
    items = itemModel;
    itemsNameAr.text = itemModel.itemsNameAr;
    itemsName.text = itemModel.itemsName;
    itemsdescrAr.text = itemModel.itemsDescrAr;
    itemsdescr.text = itemModel.itemsDesc;
    itemsprice.text = itemModel.itemsPrice.toString();
    itemscategories.text = itemModel.itemsCategories.toString();
    itemscount.text = itemModel.itemsCount.toString();
    itemsdiscount.text = itemModel.itemsDiscount.toString();
    update();
  }

  @override
  void onInit() {
    itemsNameAr = TextEditingController();
    itemsName = TextEditingController();
    itemsdescrAr = TextEditingController();
    itemsdescr = TextEditingController();
    itemsprice = TextEditingController();
    itemscategories = TextEditingController();
    itemscount = TextEditingController();
    itemsdiscount = TextEditingController();
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['items'] != null) {
      initData(Get.arguments['items']);
    }
    getCategories();
    super.onInit();
  }

  @override
  void dispose() {
    itemsNameAr.dispose();
    itemsName.dispose();
    itemsdescrAr.dispose();
    itemsdescr.dispose();
    itemsprice.dispose();
    itemscategories.dispose();
    itemscount.dispose();
    itemsdiscount.dispose();
    super.dispose();
  }
}
