import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class OrderData {
  Crud crud;
  OrderData(this.crud);

  view() async {
    var response = await crud.postData(Applink.order, {});
    return response.fold((l) => l, (r) => r);
  }

  viewaccepted() async {
    var response = await crud.postData(Applink.orderaccepted, {});
    return response.fold((l) => l, (r) => r);
  }

  detils(String orderid) async {
    var response = await crud.postData(Applink.orderdetils, {"orderid": orderid});
    return response.fold((l) => l, (r) => r);
  }

  delete(String orderid) async {
    var response = await crud.postData(Applink.orderdelete, {"orderid": orderid});
    return response.fold((l) => l, (r) => r);
  }

  rating(String orderid, String rating, String comment) async {
    var response = await crud.postData(Applink.orderrate, {
      "orderid": orderid,
      "rating": rating,
      "comment": comment,
    });
    return response.fold((l) => l, (r) => r);
  }

  accept(String orderid, String userid, String adminid) async {
    var response = await crud.postData(Applink.orderadminaccepte, {
      "orderid": orderid,
      "usersid": userid,
      "adminid": adminid,
    });
    return response.fold((l) => l, (r) => r);
  }

  updateStatus(String orderid, String status, {String? deliveryid}) async {
    var response = await crud.postData(Applink.updateOrderStatus, {
      "orderid": orderid,
      "status": status,
      if (deliveryid != null) "deliveryid": deliveryid,
    });
    return response.fold((l) => l, (r) => r);
  }

  assignDriver(String orderid, String driverid) async {
    var response = await crud.postData(Applink.assignDriver, {
      "orderid": orderid,
      "deliveryid": driverid,
    });
    return response.fold((l) => l, (r) => r);
  }
}