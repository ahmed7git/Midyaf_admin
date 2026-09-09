import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class Userdata {
  final Crud crud;
  Userdata(this.crud);

  postData() async {
    var response = await crud.postData(Applink.viewUser, {});
    return response.fold((l) => l, (r) => r);
  }

  addData(Map<String, String> data) async {
    var response = await crud.postData(Applink.addUser, data);
    return response.fold((l) => l, (r) => r);
  }

  editData(Map<String, String> data) async {
    var response = await crud.postData(Applink.editUser, data);
    return response.fold((l) => l, (r) => r);
  }

  deleteData(String adminId) async {
    var response = await crud.postData(Applink.deleteUser, {"admin_id": adminId});
    return response.fold((l) => l, (r) => r);
  }
}
