import 'package:admin/core/services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getx;

/// دالة حقن وجلب التوكن من مزود خارجي (Token Provider Signature)
typedef TokenProvider = String? Function();

/// 🌐 عميل Dio الموحد والاحترافي لإدارة اتصالات الشبكة (DioClient)
class DioClient {
  late final Dio dio;
  final TokenProvider? tokenProvider;
  final String? baseUrl;

  DioClient({
    this.baseUrl,
    this.tokenProvider,
    BaseOptions? customOptions,
    List<Interceptor>? additionalInterceptors,
  }) {
    final BaseOptions options =
        customOptions ??
        BaseOptions(
          baseUrl: baseUrl ?? "",
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: {'Accept': 'application/json'},
          responseType: ResponseType.json,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        );

    dio = Dio(options);

    // إضافة معترض المصادقة (Auth Interceptor)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? token = _resolveToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // يمكن هنا التعامل مع تجديد التوكن تلقائياً (Refresh Token) في حال كان الخطأ 401
          return handler.next(error);
        },
      ),
    );

    // إضافة معترض تسجيل البيانات في وضع التطوير (Logging Interceptor)
    if (kDebugMode) {
      dio.interceptors.add(_buildLoggingInterceptor());
    }

    // إضافة أي معترضات إضافية تم تمريرها
    if (additionalInterceptors != null) {
      dio.interceptors.addAll(additionalInterceptors);
    }
  }

  /// استخراج التوكن من الـ Provider الممرر أو من تخزين Hive الافتراضي
  String? _resolveToken() {
    if (tokenProvider != null) {
      return tokenProvider!();
    }
    if (getx.Get.isRegistered<MyServices>()) {
      final myServices = getx.Get.find<MyServices>();
      return myServices.box.get("token")?.toString();
    }
    return null;
  }

  /// معترض تسجيل العمليات للكونسول بطريقة أنيقة ومفصلة
  Interceptor _buildLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint(
          "┌── 🚀 [DIO REQUEST] ─────────────────────────────────────────",
        );
        debugPrint("│ Method: ${options.method} | URL: ${options.uri}");
        debugPrint("│ Headers: ${options.headers}");
        if (options.data != null) {
          if (options.data is FormData) {
            final formData = options.data as FormData;
            final fields = formData.fields
                .map((e) => "${e.key}: ${e.value}")
                .join(", ");
            final files = formData.files
                .map((e) => "${e.key}: ${e.value.filename}")
                .join(", ");
            debugPrint(
              "│ Body (FormData): Fields: [$fields] | Files: [$files]",
            );
          } else {
            debugPrint("│ Body: ${options.data}");
          }
        }
        debugPrint(
          "└─────────────────────────────────────────────────────────────",
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint(
          "┌── ✅ [DIO RESPONSE] ────────────────────────────────────────",
        );
        debugPrint(
          "│ Status: ${response.statusCode} | URL: ${response.requestOptions.uri}",
        );
        debugPrint("│ Data: ${response.data}");
        debugPrint(
          "└─────────────────────────────────────────────────────────────",
        );
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        debugPrint(
          "┌── ❌ [DIO ERROR] ───────────────────────────────────────────",
        );
        debugPrint("│ Type: ${error.type} | URL: ${error.requestOptions.uri}");
        debugPrint("│ Status: ${error.response?.statusCode}");
        debugPrint("│ Message: ${error.message}");
        debugPrint("│ Response Data: ${error.response?.data}");
        debugPrint(
          "└─────────────────────────────────────────────────────────────",
        );
        return handler.next(error);
      },
    );
  }
}
