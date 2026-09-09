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

class AddItemControllerImp extends GetxController {
  List<ItemsModel> items = [];
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
      allowedExtensions: ['jpg', 'jpeg', 'png'], // السماح بالـ SVG والصور العادية
    );

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!); // تحويل المسار إلى كائن File
      update(); // تحديث الواجهة لعرض اسم الملف أو مظهر الصورة فوراً
    } else {
      print("تم إلغاء اختيار الملف");
    }
  }
  addData() async {
    if (formState.currentState!.validate()) {

      if (file == null) {
        Get.snackbar("تنبيه", "يرجى اختيار صورة للقسم أولاً");
        return;
      }

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
        "items_date": DateTime.now().toString(),
      };

      var response = await itemsdata.addData(
        data, 
        file,
      );
      staterequest = handlingData(response);
      if (Staterequest.success == staterequest) {
        if (response['status'] == "success") {
          Get.back();
          Get.snackbar(
            "تمت العملية",
            "تمت إضافة المنتج بنجاح",
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
    selectedCategoryName = category.categoriesNameAr; // حفظ الاسم لعرضه بالواجهة
    itemscategories.text = category.categoriesId.toString(); // حفظ الـ ID لإرساله للسيرفر
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
