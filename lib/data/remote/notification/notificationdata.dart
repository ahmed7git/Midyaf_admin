import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class NotificationData {
  Crud crud;
  NotificationData(this.crud);


  veiw(String userid )async{
    var response =await crud.postData(Applink.notification, {
      "userid":userid
    });
     return response.fold((l)=>l, (r)=>r);
  }
}