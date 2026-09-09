import 'package:admin/controller/orders/tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
// لا تنسَ استدعاء الكنترولر

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TrackingController());

    return Scaffold(
      appBar: AppBar(title: const Text("تتبع الطلب"), centerTitle: true),
      body: GetBuilder<TrackingController>(
        builder: (controller) => FlutterMap(
          mapController: controller.mapController,
          options: MapOptions(
            initialCenter: controller.customerLocation,
            initialZoom: 14.0,
          ),
         children: [
            // 1. طبقة الخريطة (Mapbox)
            TileLayer(
              urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=${controller.mapboxToken}',
              additionalOptions: {
                'accessToken': controller.mapboxToken,
              },
              userAgentPackageName: 'com.example.admin',
            ),
            
            // 2. طبقة المسار: لن يتم رسم الخط إلا إذا تم جلب النقاط بنجاح من الماب بوكس
           // 2. طبقة المسار بتصميم احترافي وانسيابي
            if (controller.routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  // تأثير الظل أو الإطار الخارجي للخط ليكون واضحاً على الخريطة
                  Polyline(
                    points: controller.routePoints,
                    strokeWidth: 6.5,
                    color: Colors.blue.withValues(alpha: 0.4),
                    strokeCap: StrokeCap.round,
                    strokeJoin: StrokeJoin.round,
                  ),
                  // الخط الأساسي الملون
                  Polyline(
                    points: controller.routePoints,
                    strokeWidth: 4.0,
                    color: const Color(0xFF2196F3), // أزرق ناصع واحترافي
                    strokeCap: StrokeCap.round,
                    strokeJoin: StrokeJoin.round,
                  ),
                ],
              ),
            
            // 3. طبقة الأيقونات (السائق والعميل)
            MarkerLayer(
              markers: [
                // أيقونة العميل (المنزل)
                Marker(
                  point: controller.customerLocation,
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
                
                // أيقونة السائق (سيارة تتحرك باستمرار)
                Marker(
                  point: controller.driverLocation,
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.directions_car, color: Colors.green, size: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}