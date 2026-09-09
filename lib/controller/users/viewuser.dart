import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/data/model/user_model.dart';
import 'package:admin/data/remote/user/userdata.dart';
import 'package:get/get.dart';

abstract class Viewuser extends GetxController {
  getData();
}

class ViewuserControllerImp extends Viewuser {
  List<UserModel> users = [];
  Staterequest staterequest = Staterequest.none;
  Userdata userdata = Userdata(Get.find());

  @override
  getData() async {
    staterequest = Staterequest.loading;
    update();
    var response = await userdata.postData();
    staterequest = handlingData(response);
    if (Staterequest.success == staterequest) {
      if (response['status'] == "success") {
        users.clear();
        List responseData = response['data'];
        users.addAll(responseData.map((e) => UserModel.fromJson(e)));
      } else {
        staterequest = Staterequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
