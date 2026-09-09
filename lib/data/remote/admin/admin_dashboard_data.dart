import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class AdminDashboardData {
  final Crud crud;

  AdminDashboardData(this.crud);

  Future<dynamic> getDashboardData({String period = 'week'}) async {
    var response = await crud.postData(Applink.adminDashboard, {
      "period": period,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> updateOrderStatus({
    required String orderId,
    required int status,
    String? deliveryId,
  }) async {
    var response = await crud.postData(Applink.updateOrderStatus, {
      "orderid": orderId,
      "status": status.toString(),
      if (deliveryId != null) "deliveryid": deliveryId,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> updateItemStock({
    required String itemId,
    required int count,
    required int active,
  }) async {
    var response = await crud.postData(Applink.updateStock, {
      "itemid": itemId,
      "count": count.toString(),
      "active": active.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }
}
