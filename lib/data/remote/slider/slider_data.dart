import 'dart:io';
import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class SliderData {
  final Crud crud;
  SliderData(this.crud);

  viewData() async {
    var response = await crud.postData(Applink.viewSlider, {});
    return response.fold((l) => l, (r) => r);
  }

  addData(File file) async {
    var response = await crud.addRequestWithImageOne(Applink.addSlider, {}, file, "slider_image");
    return response.fold((l) => l, (r) => r);
  }

  editData(String sliderId, String oldImage, File file) async {
    var response = await crud.addRequestWithImageOne(Applink.editSlider, {
      "id": sliderId,
      "slider_id": sliderId,
      "oldimage": oldImage,
      "imageold": oldImage,
    }, file, "slider_image");
    return response.fold((l) => l, (r) => r);
  }

  deleteData(String sliderId, String? imageName) async {
    var response = await crud.postData(Applink.deleteSlider, {
      "id": sliderId,
      "slider_id": sliderId,
      "imagename": imageName ?? '',
      "slider_image": imageName ?? '',
    });
    return response.fold((l) => l, (r) => r);
  }
}
