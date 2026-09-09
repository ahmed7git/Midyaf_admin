import 'dart:io';

import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/model/categories_model.dart';
import 'package:admin/data/remote/categories/categoriesdata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddcateControllerImp extends GetxController {
  List<CategoriesModel> categories = [];
  Staterequest staterequest = Staterequest.none;
  Categoriesdata categoriesdata = Categoriesdata(Get.find());
  late TextEditingController categoriesNameAr;
  late TextEditingController categoriesName;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  File? file;


  chooseFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['svg'], // السماح بالـ SVG والصور العادية
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
        "categoriesname_ar": categoriesNameAr.text,
        "categoriesname": categoriesName.text,
      };

      var response = await categoriesdata.addData(
        data, 
        file,
      );
      staterequest = handlingData(response);
      if (Staterequest.success == staterequest) {
        if (response['status'] == "success") {
          Get.back();
          Get.snackbar(
            "تمت العملية",
            "تمت إضافة القسم بنجاح",
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

  @override
  void onInit() {
    categoriesNameAr = TextEditingController();
    categoriesName = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    categoriesNameAr.dispose();
    categoriesName.dispose();
    super.dispose();
  }
}
