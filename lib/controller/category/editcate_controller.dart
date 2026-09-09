import 'dart:io';

import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/model/categories_model.dart';
import 'package:admin/data/remote/categories/categoriesdata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditcateControllerImp extends GetxController {
  CategoriesModel? categories;
  Staterequest staterequest = Staterequest.none;
  Categoriesdata categoriesdata = Categoriesdata(Get.find());
  late TextEditingController categoriesNameAr;
  late TextEditingController categoriesName;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  File? file;

  chooseFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['svg', 'png', 'jpg'], 
    );

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!); 
      update(); 
    } else {
      debugPrint("تم إلغاء اختيار الملف");
    }
  }

  addData() async {
    if (formState.currentState!.validate() && categories != null) {
      staterequest = Staterequest.loading;
      update();

      Map<String, String> data = {
        "categoriesname_ar": categoriesNameAr.text,
        "categoriesname": categoriesName.text,
        "oldimage": categories!.categoriesImage ?? '',
        "categories_id": categories!.categoriesId.toString(),
      };

      var response = await categoriesdata.editData(
        data, 
        file,
      );
      staterequest = handlingData(response);
      if (Staterequest.success == staterequest) {
        if (response['status'] == "success") {
          Get.back();
          Get.snackbar(
            "تمت العملية",
            "تم تعديل القسم بنجاح",
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

  void initData(CategoriesModel categoryModel) {
    categories = categoryModel;
    categoriesNameAr.text = categoryModel.categoriesNameAr ?? '';
    categoriesName.text = categoryModel.categoriesName ?? '';
    update();
  }

  @override
  void onInit() {
    categoriesNameAr = TextEditingController();
    categoriesName = TextEditingController();
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['categories'] != null) {
      initData(Get.arguments['categories']);
    }
    super.onInit();
  }

  @override
  void dispose() {
    categoriesNameAr.dispose();
    categoriesName.dispose();
    super.dispose();
  }
}
