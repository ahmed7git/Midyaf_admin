import 'package:admin/core/constant/reoute.dart';
import 'package:admin/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mymiddelware extends GetMiddleware{

  @override
  int? get priority => 1;

  MyServices myServices=Get.find<MyServices>();

   @override

  @override
  RouteSettings? redirect(String? route) {
    if(myServices.box.get("step")=="1"){
    return RouteSettings(name: AppRoutes.home);
    }
    return null;
    }
}