import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:admin/core/constant/app_env.dart';

class TrackingController extends GetxController {
  final String mapboxToken = AppEnv.mapboxAccessToken;

  // إحداثيات السائق (تبدأ من مكان معين، ثم تتحدث لاحقاً)
  LatLng driverLocation = const LatLng(15.3694, 44.1910); // مثال: صنعاء
  // إحداثيات العميل
  LatLng customerLocation = const LatLng(15.3500, 44.2000); 

  // قائمة النقاط لرسم المسار (الخط الأزرق)
  List<LatLng> routePoints = [];

  // للتحكم بالخريطة (لعمل Zoom أو تحريك الكاميرا للسائق)
  final MapController mapController = MapController();

  // العداد الزمني لجلب موقع السائق باستمرار
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    // 1. عند فتح الصفحة، نرسم المسار من السائق للعميل
    getRoute();
    // 2. نشغل المراقبة المباشرة
    startLiveTracking();
  }

  // 🟢 دالة جلب المسار من Mapbox
  Future<void> getRoute() async {
    // Mapbox يطلب الإحداثيات بصيغة (خط الطول ثم خط العرض)
    String url = "https://api.mapbox.com/directions/v5/mapbox/driving/"
        "${driverLocation.longitude},${driverLocation.latitude};"
        "${customerLocation.longitude},${customerLocation.latitude}"
        "?geometries=geojson&access_token=$mapboxToken";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> coords = data['routes'][0]['geometry']['coordinates'];
        
        // تحويل البيانات إلى قائمة إحداثيات يفهمها فلاتر
        routePoints = coords.map((point) => LatLng(point[1], point[0])).toList();
        update(); // تحديث الخريطة لرسم الخط
      }
    } catch (e) {
      debugPrint("خطأ في جلب المسار: $e");
    }
  }

  // 🟢 دالة التتبع المباشر (تشتغل كل 5 ثوانٍ)
  void startLiveTracking() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      // ⚠️ هنا تقوم باستدعاء دالة PHP تجلب موقع السائق من قاعدة البيانات
      // var response = await crud.postData(Applink.getDriverLocation, {"orderid": orderId});
      // if(response['status'] == "success") {
      //   double newLat = double.parse(response['data']['driver_lat']);
      //   double newLong = double.parse(response['data']['driver_long']);
      //   
      //   driverLocation = LatLng(newLat, newLong);
      //   
      //   // تحريك كاميرا الخريطة لتلحق السائق
      //   mapController.move(driverLocation, 16.0);
      //   update(); // تحديث مكان سيارة السائق على الشاشة
      // }
      
      debugPrint("يتم الآن تحديث موقع السائق...");
    });
  }

  @override
  void onClose() {
    // إيقاف العداد عند الخروج من الصفحة حتى لا يستهلك البطارية
    timer?.cancel();
    mapController.dispose();
    super.onClose();
  }
}