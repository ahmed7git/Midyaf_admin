import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:admin/core/class/crud.dart';
import 'package:admin/core/constant/app_env.dart';
import 'package:admin/core/functions/staterequest.dart';

class TrackingController extends GetxController {
  final String mapboxToken = AppEnv.mapboxAccessToken;

  Crud crud = Get.find();
  Staterequest staterequest = Staterequest.none;

  LatLng driverLocation = const LatLng(15.3694, 44.1910); 
  LatLng customerLocation = const LatLng(15.3500, 44.2000); 

  String? orderId;
  List<LatLng> routePoints = [];
  final MapController mapController = MapController();
  Timer? timer;

  // علم لمنع التحديث العشوائي أثناء تفاعل المستخدم مع الخريطة
  bool isUserInteracting = false;

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null) {
      orderId = Get.arguments['orderid']?.toString();
      if (Get.arguments['lat'] != null && Get.arguments['long'] != null) {
        double lat = double.parse(Get.arguments['lat'].toString());
        double long = double.parse(Get.arguments['long'].toString());
        customerLocation = LatLng(lat, long);
      }
    }

    getRoute();
    startLiveTracking();
  }

  Future<void> getRoute() async {
    String url = "https://api.mapbox.com/directions/v5/mapbox/driving/"
        "${driverLocation.longitude},${driverLocation.latitude};"
        "${customerLocation.longitude},${customerLocation.latitude}"
        "?geometries=geojson&access_token=$mapboxToken";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> coords = data['routes'][0]['geometry']['coordinates'];
        
        routePoints = coords.map((point) => LatLng(point[1], point[0])).toList();
        update(); 
      }
    } catch (e) {
      debugPrint("خطأ في جلب المسار: $e");
    }
  }

  void startLiveTracking() {
    // زيادة المدة إلى 8 ثوانٍ لتخفيف الضغط على المعالج ومنع التعليق
    timer = Timer.periodic(const Duration(seconds: 8), (timer) async {
      if (orderId == null || isUserInteracting) return;

      // مكان استعلام الـ PHP لجلب إحداثيات السائق الحالية
      /*
      var response = await crud.postData(Applink.getDriverLocation, {"orderid": orderId});
      if (response['status'] == "success") {
        double newLat = double.parse(response['data']['driver_lat'].toString());
        double newLong = double.parse(response['data']['driver_long'].toString());
        
        // تحديث الموقع فقط إذا كان هناك تغيير حقيقي
        if (driverLocation.latitude != newLat || driverLocation.longitude != newLong) {
          driverLocation = LatLng(newLat, newLong);
          mapController.move(driverLocation, mapController.camera.zoom);
          update();
        }
      }
      */
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    mapController.dispose();
    super.onClose();
  }
}