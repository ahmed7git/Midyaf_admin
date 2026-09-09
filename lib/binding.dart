import 'package:admin/core/class/crud.dart';
import 'package:admin/core/network/api_service.dart';
import 'package:admin/core/network/dio_client.dart';
import 'package:get/instance_manager.dart';

/// 💉 ربط وحقن التبعيات الأساسية للتطبيق (Dependency Injection)
class MyBinding extends Bindings {
  @override
  void dependencies() {
    // 1. حقن عميل Dio الموحد (DioClient)
    final dioClient = Get.put<DioClient>(DioClient(), permanent: true);

    // 2. حقن خدمة الشبكة (ApiService)
    Get.put<ApiService>(ApiServiceImpl(dioClient: dioClient), permanent: true);

    // 3. الإبقاء على Crud للتوافقية الشاملة مع الكود الحالي
    Get.put(Crud(), permanent: true);
  }
}