import 'dart:io';
import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/model/slider_model.dart';
import 'package:admin/data/remote/slider/slider_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliderControllerImp extends GetxController {
  Staterequest staterequest = Staterequest.none;
  final SliderData sliderData = SliderData(Get.find());
  List<SliderModel> sliders = [];

  File? file;
  SliderModel? editingSlider;

  chooseFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'webp'],
    );

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      update();
    }
  }

  void initEdit(SliderModel slider) {
    editingSlider = slider;
    file = null;
    update();
  }

  void clearForm() {
    editingSlider = null;
    file = null;
    update();
  }

  getData() async {
    staterequest = Staterequest.loading;
    update();

    var response = await sliderData.viewData();
    staterequest = handlingData(response);

    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        sliders.clear();
        List responseData = response['data'];
        sliders.addAll(responseData.map((e) => SliderModel.fromJson(e)));
      } else {
        staterequest = Staterequest.failure;
      }
    }
    update();
  }

  addSlider() async {
    if (file == null) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار صورة صالحة للبانر",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    staterequest = Staterequest.loading;
    update();

    var response = await sliderData.addData(file!);
    staterequest = handlingData(response);

    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        Get.back();
        clearForm();
        getData();
        Get.snackbar(
          "تمت العملية",
          "تمت إضافة البانر الإعلاني بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      } else {
        Get.snackbar(
          "تنبيه",
          response['message'] ?? "تعذر إضافة البانر",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
        staterequest = Staterequest.failure;
      }
    }
    update();
  }

  editSlider() async {
    if (file == null || editingSlider == null) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار صورة جديدة لتحديث البانر",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    staterequest = Staterequest.loading;
    update();

    var response = await sliderData.editData(
      editingSlider!.sliderId.toString(),
      editingSlider!.sliderImage ?? '',
      file!,
    );
    staterequest = handlingData(response);

    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        Get.back();
        clearForm();
        getData();
        Get.snackbar(
          "تمت العملية",
          "تم تعديل صورة البانر بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      } else {
        Get.snackbar(
          "تنبيه",
          response['message'] ?? "تعذر تعديل البانر",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
        staterequest = Staterequest.failure;
      }
    }
    update();
  }

  deleteSlider(String sliderId, String? imageName) async {
    staterequest = Staterequest.loading;
    update();

    var response = await sliderData.deleteData(sliderId, imageName);
    staterequest = handlingData(response);

    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        sliders.removeWhere((element) => element.sliderId.toString() == sliderId);
        update();
        Get.snackbar(
          "تم الحذف",
          "تم حذف البانر بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      } else {
        Get.snackbar(
          "تنبيه",
          response['message'] ?? "تعذر حذف البانر",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      }
    } else {
      Get.snackbar(
        "خطأ",
        "تعذر الاتصال بالخادم لحذف البانر",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    }
    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
