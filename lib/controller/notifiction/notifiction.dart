import 'package:admin/core/functions/handlingdata.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/core/services/services.dart';
import 'package:admin/data/model/notifi_model.dart';
import 'package:admin/data/remote/notification/notificationdata.dart';
import 'package:get/get.dart';

class NoticitionController extends GetxController {
  MyServices myServices = Get.find<MyServices>();
  NotificationData notificationData = NotificationData(Get.find());
  Staterequest staterequest = Staterequest.none;
  List<NotificationModel> listData = [];
  
  getdata() async {
    listData.clear();
    staterequest = Staterequest.loading;
    update();
    var response = await notificationData.veiw(myServices.box.get("id").toString());
    staterequest = handlingData(response);
    if (staterequest == Staterequest.success) {
      if (response['status'] == "success") {
        List notifi = response['data'];
        listData.addAll(notifi.map((e) => NotificationModel.fromJson(e)));
      } else {
        staterequest = Staterequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    getdata();
    super.onInit();
  }
}
