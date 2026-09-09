import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class CouponData {
  final Crud crud;
  CouponData(this.crud);

  viewData() async {
    var response = await crud.postData(Applink.viewCoupon, {});
    return response.fold((l) => l, (r) => r);
  }

  addData(Map<String, String> data) async {
    var response = await crud.postData(Applink.addCoupon, data);
    return response.fold((l) => l, (r) => r);
  }

  editData(Map<String, String> data) async {
    var response = await crud.postData(Applink.editCoupon, data);
    return response.fold((l) => l, (r) => r);
  }

  deleteData(String couponId) async {
    var response = await crud.postData(Applink.deleteCoupon, {
      "id": couponId,
      "coupon_id": couponId,
    });
    return response.fold((l) => l, (r) => r);
  }
}
