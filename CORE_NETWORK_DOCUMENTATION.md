# 📘 التوثيق الشامل لطبقة الشبكة الحديثة (`core/network`) في تطبيق الإدارة

**المشروع:** لوحة تحكم المسؤول (`e:\work\app\admin`)  
**المسار:** `lib/core/network`  
**التاريخ:** سبتمبر 2026  

---

## 📑 الفهرس
1. [المقدمة والهدف المعماري](#1-المقدمة-والهدف-المعماري)
2. [الأكواد الكاملة لملفات `lib/core/network`](#2-الأكواد-الكاملة-لملفات-libcorenetwork)
   - [1. dio_client.dart](#1-dio_clientdart)
   - [2. api_service.dart](#2-api_servicedart)
   - [3. failure.dart](#3-failuredart)
   - [4. api_exceptions.dart](#4-api_exceptionsdart)
   - [5. clean_architecture_example.dart](#5-clean_architecture_exampledart)
3. [كيف تم ربط الطبقة بالتطبيق (Dependency Injection)](#3-كيف-تم-ربط-الطبقة-بالتطبيق-dependency-injection)
4. [المقارنة الشاملة: كيف كانت وكيف صارت الآن؟](#4-المقارنة-الشاملة-كيف-كانت-وكيف-صارت-الآن)
5. [الخلاصة وأفضل الممارسات البرمجية](#5-الخلاصة-وأفضل-الممارسات-البرمجية)

---

## 1. المقدمة والهدف المعماري

تم إنشاء مجلد `lib/core/network` لنقل تطبيق الإدارة من الاعتماد على طبقة اتصالات بدائية وهشة (`Crud` القديم المبني على خلط `http` و `Dio` بدون معترضات) إلى **بنية اتصالات شبكية مؤسسية (Enterprise-grade Network Layer)** تطبق معايير **Clean Architecture** وتفصل الاهتمامات (Separation of Concerns).

تهدف هذه الطبقة إلى:
* توحيد إدارة الطلبات (`GET`, `POST`, `PUT`, `DELETE`).
* إدارة جلسات الدخول وحقن الـ Token تلقائياً عبر `Interceptors`.
* تسجيل تفاصيل كل طلب واستجابة بالكونسول بنظام بصري منظم في بيئة التطوير (`Debug Logging`).
* حماية التطبيق من الانهيار عند انقطاع الإنترنت أو أخطاء السيرفر وتحويلها لكائنات `Failure` منضبطة ومترجمة للمستخدم.
* توحيد رفع الصور والملفات عبر `Dio FormData` والاستغناء التام عن مكتبة `http` القديمة.

---

## 2. الأكواد الكاملة لملفات `lib/core/network`

### 1. `dio_client.dart`
**المسار:** `lib/core/network/dio_client.dart`  
**الوظيفة:** تهيئة وإعداد عميل `Dio` المركزي، وضبط الـ Timeouts، وتثبيت معترض المصادقة (`Auth Interceptor`) ومعترض تسجيل الأحداث (`Console Logger`).

```dart
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
    final BaseOptions options = customOptions ??
        BaseOptions(
          baseUrl: baseUrl ?? "",
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: {
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
          validateStatus: (status) => status != null && status >= 200 && status < 300,
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
        debugPrint("┌── 🚀 [DIO REQUEST] ─────────────────────────────────────────");
        debugPrint("│ Method: ${options.method} | URL: ${options.uri}");
        debugPrint("│ Headers: ${options.headers}");
        if (options.data != null) {
          if (options.data is FormData) {
            final formData = options.data as FormData;
            final fields = formData.fields.map((e) => "${e.key}: ${e.value}").join(", ");
            final files = formData.files.map((e) => "${e.key}: ${e.value.filename}").join(", ");
            debugPrint("│ Body (FormData): Fields: [$fields] | Files: [$files]");
          } else {
            debugPrint("│ Body: ${options.data}");
          }
        }
        debugPrint("└─────────────────────────────────────────────────────────────");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint("┌── ✅ [DIO RESPONSE] ────────────────────────────────────────");
        debugPrint("│ Status: ${response.statusCode} | URL: ${response.requestOptions.uri}");
        debugPrint("│ Data: ${response.data}");
        debugPrint("└─────────────────────────────────────────────────────────────");
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        debugPrint("┌── ❌ [DIO ERROR] ───────────────────────────────────────────");
        debugPrint("│ Type: ${error.type} | URL: ${error.requestOptions.uri}");
        debugPrint("│ Status: ${error.response?.statusCode}");
        debugPrint("│ Message: ${error.message}");
        debugPrint("│ Response Data: ${error.response?.data}");
        debugPrint("└─────────────────────────────────────────────────────────────");
        return handler.next(error);
      },
    );
  }
}
```

---

### 2. `api_service.dart`
**المسار:** `lib/core/network/api_service.dart`  
**الوظيفة:** عقد الخدمة وتطبيقها الشامل، يقدم دوال `get`, `post`, `put`, `delete`, و `uploadFile` و `uploadMultipleFiles` مغلفة بنمط البرمجة الوظيفية `Either<Failure, dynamic>`.

```dart
import 'dart:convert';
import 'dart:io';
import 'package:admin/core/network/api_exceptions.dart';
import 'package:admin/core/network/dio_client.dart';
import 'package:admin/core/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

/// 🔌 واجهة خدمة الاتصال بالشبكة (API Service Contract)
abstract class ApiService {
  /// تنفيذ طلب GET
  Future<Either<Failure, dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  /// تنفيذ طلب POST
  Future<Either<Failure, dynamic>> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool isFormData = false,
  });

  /// تنفيذ طلب PUT
  Future<Either<Failure, dynamic>> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  /// تنفيذ طلب DELETE
  Future<Either<Failure, dynamic>> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  /// رفع ملف/صورة منفردة عبر Dio حصراً باستخدام FormData و MultipartFile
  Future<Either<Failure, dynamic>> uploadFile(
    String url, {
    required String fileKey,
    required File file,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });

  /// رفع مجموعة ملفات متعددة عبر Dio حصراً
  Future<Either<Failure, dynamic>> uploadMultipleFiles(
    String url, {
    required String fileKey,
    required List<File> files,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });
}

/// 🚀 تطبيق واجهة خدمة الشبكة بالكامل (ApiService Implementation)
class ApiServiceImpl implements ApiService {
  final DioClient dioClient;

  ApiServiceImpl({required this.dioClient});

  Dio get _dio => dioClient.dio;

  @override
  Future<Either<Failure, dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Right(_parseResponseData(response.data));
    } on DioException catch (e) {
      return Left(ApiExceptions.handleDioException(e));
    } catch (e, stack) {
      debugPrint("💥 [Unexpected GET Error]: $e\n$stack");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool isFormData = false,
  }) async {
    try {
      dynamic requestData = data;
      Options requestOptions = options ?? Options();
      if (isFormData && data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      } else if (data is Map && !isFormData) {
        requestData = Map<String, dynamic>.from(data);
      }

      final response = await _dio.post(
        url,
        data: requestData,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
      );
      return Right(_parseResponseData(response.data));
    } on DioException catch (e) {
      return Left(ApiExceptions.handleDioException(e));
    } catch (e, stack) {
      debugPrint("💥 [Unexpected POST Error]: $e\n$stack");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Right(_parseResponseData(response.data));
    } on DioException catch (e) {
      return Left(ApiExceptions.handleDioException(e));
    } catch (e, stack) {
      debugPrint("💥 [Unexpected PUT Error]: $e\n$stack");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Right(_parseResponseData(response.data));
    } on DioException catch (e) {
      return Left(ApiExceptions.handleDioException(e));
    } catch (e, stack) {
      debugPrint("💥 [Unexpected DELETE Error]: $e\n$stack");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> uploadFile(
    String url, {
    required String fileKey,
    required File file,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final String fileName = p.basename(file.path);
      final Map<String, dynamic> formDataMap = data != null ? Map.from(data) : {};

      formDataMap[fileKey] = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      );

      final FormData formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return Right(_parseResponseData(response.data));
    } on DioException catch (e) {
      return Left(ApiExceptions.handleDioException(e));
    } catch (e, stack) {
      debugPrint("💥 [Unexpected Upload File Error]: $e\n$stack");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> uploadMultipleFiles(
    String url, {
    required String fileKey,
    required List<File> files,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final Map<String, dynamic> formDataMap = data != null ? Map.from(data) : {};

      final List<MultipartFile> multipartFiles = [];
      for (final file in files) {
        multipartFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: p.basename(file.path),
          ),
        );
      }

      formDataMap[fileKey] = multipartFiles;
      final FormData formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return Right(_parseResponseData(response.data));
    } on DioException catch (e) {
      return Left(ApiExceptions.handleDioException(e));
    } catch (e, stack) {
      debugPrint("💥 [Unexpected Upload Multiple Files Error]: $e\n$stack");
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  /// فك وتفسير البيانات الواردة للتأكد من أنها بصيغة JSON صالحة
  dynamic _parseResponseData(dynamic rawData) {
    if (rawData == null) return null;
    if (rawData is Map || rawData is List) return rawData;

    if (rawData is String) {
      try {
        return jsonDecode(rawData);
      } catch (_) {
        return rawData;
      }
    }
    return rawData;
  }
}
```

---

### 3. `failure.dart`
**المسار:** `lib/core/network/failure.dart`  
**الوظيفة:** شجرة تصنيف الأخطاء (Domain Failure Hierarchy)، مع توفير دالة التوافق الذكية `toStateRequest()` لتحويل الأخطاء الحديثة إلى كود `Staterequest` القديم.

```dart
import 'package:admin/core/functions/staterequest.dart';

/// 🧱 الصنف الأساسي الموحد لإدارة الأخطاء في طبقة التطبيق والشبكة (Base Failure)
abstract class Failure {
  final String message;
  final int? statusCode;
  final dynamic responseData;

  const Failure({
    required this.message,
    this.statusCode,
    this.responseData,
  });

  /// 🔄 تحويل الفشل الحديث إلى الحالة القديمة Staterequest لضمان التوافقية الكاملة
  Staterequest toStateRequest() {
    if (this is OfflineFailure) {
      return Staterequest.offlinefailure;
    } else if (this is ServerFailure || this is TimeoutFailure) {
      return Staterequest.serverfailure;
    } else if (this is UnAuthorizedFailure) {
      return Staterequest.serverfailure;
    } else {
      return Staterequest.failure;
    }
  }

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

/// 🌐 خطأ داخلي من السيرفر (500, 502, 503, إلخ)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.responseData,
  });
}

/// 📴 خطأ انقطاع الإنترنت أو فشل الاتصال بالشبكة
class OfflineFailure extends Failure {
  const OfflineFailure({
    super.message = "لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة وإعادة المحاولة",
    super.statusCode,
    super.responseData,
  });
}

/// 🔒 خطأ انتهاء صلاحية الجلسة أو عدم التصريح (401 Unauthorized / 403 Forbidden)
class UnAuthorizedFailure extends Failure {
  const UnAuthorizedFailure({
    super.message = "انتهت صلاحية الجلسة أو ليس لديك الصلاحية للوصول لهذا المورد",
    super.statusCode = 401,
    super.responseData,
  });
}

/// 🔍 خطأ عدم وجود الرابط المطلوب (404 Not Found)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = "المورد أو الرابط المطلوب غير موجود على الخادم",
    super.statusCode = 404,
    super.responseData,
  });
}

/// ⚠️ خطأ في صحة البيانات المدخلة (422 Unprocessable Entity / Validation Error)
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    super.message = "بيانات الإدخال غير صالحة، يرجى مراجعة الحقول",
    super.statusCode = 422,
    this.errors,
    super.responseData,
  });
}

/// ⏳ خطأ انتهاء مهلة الطلب (Connection/Send/Receive Timeout)
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = "استغرق الخادم وقتاً أطول للاستجابة، انتهت مهلة الاتصال",
    super.statusCode = 408,
    super.responseData,
  });
}

/// ❌ خطأ غير متوقع / غير معروف (Unexpected / Parsing Error)
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = "حدث خطأ غير متوقع في معالجة البيانات، يرجى المحاولة لاحقاً",
    super.statusCode,
    super.responseData,
  });
}
```

---

### 4. `api_exceptions.dart`
**المسار:** `lib/core/network/api_exceptions.dart`  
**الوظيفة:** المترجم والمحلل الذكي لأخطاء `DioException` واستخراج الرسائل المخصصة من الباك اند وترجمتها إلى كائنات `Failure`.

```dart
import 'dart:convert';
import 'package:admin/core/network/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 🛡️ معالج استثناءات Dio ومحولها إلى أصناف Failure (ApiExceptions Handler)
class ApiExceptions {
  ApiExceptions._();

  /// التقاط وتحويل أي استثناء من نوع DioException إلى صنف Failure دقيق
  static Failure handleDioException(DioException dioException) {
    debugPrint("🌐 [DioException Caught]: Type=${dioException.type}, Message=${dioException.message}");

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: "انتهت مهلة الاتصال بالخادم، يرجى المحاولة مرة أخرى",
          responseData: dioException.response?.data,
        );

      case DioExceptionType.connectionError:
        return OfflineFailure(
          message: "تعذر الاتصال بالخادم، يرجى التأكد من اتصال الإنترنت لديك",
          responseData: dioException.response?.data,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(dioException.response);

      case DioExceptionType.cancel:
        return const UnexpectedFailure(
          message: "تم إلغاء طلب الاتصال بالخادم",
        );

      case DioExceptionType.badCertificate:
        return const ServerFailure(
          message: "شهادة الأمان للخادم غير موثوقة أو غير صالحة",
          statusCode: 495,
        );

      case DioExceptionType.unknown:
      default:
        return UnexpectedFailure(
          message: dioException.message?.isNotEmpty == true
              ? dioException.message!
              : "حدث خطأ غير معروف في الاتصال بالشبكة",
          responseData: dioException.response?.data,
        );
    }
  }

  /// معالجة استجابات الخادم غير الصالحة عبر فحص رمز الحالة HTTP وتفكيك رسالة الباك إند
  static Failure _handleBadResponse(Response? response) {
    final int? statusCode = response?.statusCode;
    final dynamic data = response?.data;
    final String serverMessage = _extractErrorMessage(data);

    debugPrint("⚠️ [BadResponse]: StatusCode=$statusCode, ExtractedMessage=$serverMessage");

    switch (statusCode) {
      case 400:
        return ServerFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "طلب غير صالح، يرجى مراجعة البيانات المرسلة",
          statusCode: statusCode,
          responseData: data,
        );

      case 401:
        return UnAuthorizedFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "انتهت جلسة الدخول أو غير مصرح بالوصول",
          statusCode: statusCode,
          responseData: data,
        );

      case 403:
        return UnAuthorizedFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "ليس لديك الصلاحيات الكافية لتنفيذ هذا الإجراء",
          statusCode: statusCode,
          responseData: data,
        );

      case 404:
        return NotFoundFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "المورد المطلوب غير متوفر حالياً على الخادم",
          statusCode: statusCode,
          responseData: data,
        );

      case 408:
        return TimeoutFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "انتهت مهلة استجابة الخادم",
          statusCode: statusCode,
          responseData: data,
        );

      case 409:
        return ServerFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "يوجد تعارض في البيانات المدخلة",
          statusCode: statusCode,
          responseData: data,
        );

      case 422:
        return ValidationFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "بيانات الإدخال غير صالحة، يرجى مراجعة الحقول المطلوبة",
          statusCode: statusCode,
          errors: data is Map<String, dynamic> ? data : null,
          responseData: data,
        );

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "حدث خطأ في خادم النظام (500)، يرجى المحاولة لاحقاً",
          statusCode: statusCode,
          responseData: data,
        );

      default:
        return ServerFailure(
          message: serverMessage.isNotEmpty ? serverMessage : "حدث خطأ في الاتصال بالخادم ($statusCode)",
          statusCode: statusCode,
          responseData: data,
        );
    }
  }

  /// استخراج رسالة الخطأ من جسم الاستجابة بجميع الاحتمالات (JSON Map / String / List)
  static String _extractErrorMessage(dynamic data) {
    if (data == null) return "";

    try {
      dynamic parsedData = data;
      if (data is String) {
        try {
          parsedData = jsonDecode(data);
        } catch (_) {
          return data.length < 150 ? data : "";
        }
      }

      if (parsedData is Map) {
        if (parsedData.containsKey('message') && parsedData['message'] != null) {
          return parsedData['message'].toString();
        }
        if (parsedData.containsKey('msg') && parsedData['msg'] != null) {
          return parsedData['msg'].toString();
        }
        if (parsedData.containsKey('error') && parsedData['error'] != null) {
          if (parsedData['error'] is String) return parsedData['error'];
          if (parsedData['error'] is Map && parsedData['error']['message'] != null) {
            return parsedData['error']['message'].toString();
          }
        }
        if (parsedData.containsKey('errors') && parsedData['errors'] != null) {
          if (parsedData['errors'] is Map) {
            final firstErrorList = (parsedData['errors'] as Map).values.firstOrNull;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              return firstErrorList.first.toString();
            }
          }
          return parsedData['errors'].toString();
        }
      }
    } catch (e) {
      debugPrint("Error parsing message payload: $e");
    }

    return "";
  }
}
```

---

### 5. `clean_architecture_example.dart`
**المسار:** `lib/core/network/example/clean_architecture_example.dart`  
**الوظيفة:** مثال مرجعي حي ومكتمل يوضح للمطورين كيفية بناء الميزات الجديدة باستخدام طبقة المستودع (`Repository`) و `ApiService` واستخدام `result.fold` مع `Controller`.

```dart
import 'dart:io';
import 'package:admin/core/functions/staterequest.dart';
import 'package:admin/core/network/api_service.dart';
import 'package:admin/core/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

// ==============================================================================
// 1. طبقة المستودع (Repository Layer)
// ==============================================================================

/// واجهة مستودع العمليات (Repository Contract)
abstract class ProductRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchProducts();
  Future<Either<Failure, Map<String, dynamic>>> addProductWithImage({
    required Map<String, dynamic> productData,
    required File imageFile,
  });
}

/// تطبيق المستودع بالاعتماد على ApiService
class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;

  ProductRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchProducts() async {
    final result = await apiService.get("https://example.com/api/products/view.php");

    return result.fold(
      (failure) => Left(failure),
      (response) {
        if (response is Map && response['status'] == 'success' && response['data'] is List) {
          final List list = response['data'];
          final parsedList = list.map((e) => Map<String, dynamic>.from(e)).toList();
          return Right(parsedList);
        } else {
          return Left(ServerFailure(
            message: response is Map ? response['message'] ?? "تعذر جلب المنتجات" : "استجابة غير صالحة",
          ));
        }
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addProductWithImage({
    required Map<String, dynamic> productData,
    required File imageFile,
  }) async {
    final result = await apiService.uploadFile(
      "https://example.com/api/products/add.php",
      fileKey: "files",
      file: imageFile,
      data: productData,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) {
        if (response is Map && response['status'] == 'success') {
          return Right(Map<String, dynamic>.from(response));
        } else {
          return Left(ServerFailure(
            message: response is Map ? response['message'] ?? "فشلت إضافة المنتج" : "خطأ غير معروف",
          ));
        }
      },
    );
  }
}

// ==============================================================================
// 2. طبقة التحكم والحالة (Controller Layer using result.fold)
// ==============================================================================

class ExampleProductController extends GetxController {
  final ProductRepository repository = ProductRepositoryImpl(
    apiService: Get.find<ApiService>(),
  );

  Staterequest staterequest = Staterequest.none;
  List<Map<String, dynamic>> products = [];
  String errorMessage = "";

  Future<void> loadProducts() async {
    staterequest = Staterequest.loading;
    update();

    final result = await repository.fetchProducts();

    result.fold(
      (failure) {
        errorMessage = failure.message;
        staterequest = failure.toStateRequest();

        Get.snackbar(
          "تنبيه",
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (data) {
        products.clear();
        products.addAll(data);

        if (products.isEmpty) {
          staterequest = Staterequest.failure;
        } else {
          staterequest = Staterequest.success;
        }
      },
    );

    update();
  }

  Future<void> addNewProduct(Map<String, dynamic> data, File image) async {
    staterequest = Staterequest.loading;
    update();

    final result = await repository.addProductWithImage(
      productData: data,
      imageFile: image,
    );

    result.fold(
      (failure) {
        Get.snackbar("خطأ", failure.message);
        staterequest = failure.toStateRequest();
      },
      (response) {
        Get.snackbar("تم بنجاح", "تم حفظ ونشر المنتج والصورة بنجاح");
        loadProducts();
      },
    );

    update();
  }

  @override
  void onInit() {
    loadProducts();
    super.onInit();
  }
}
```

---

## 3. كيف تم ربط الطبقة بالتطبيق (Dependency Injection)

تم ربط البنية التحتية للشبكة في نقطة الإطلاق المركزية للتطبيق عبر [lib/binding.dart](file:///e:/work/app/admin/lib/binding.dart):

```dart
import 'package:admin/core/class/crud.dart';
import 'package:admin/core/network/api_service.dart';
import 'package:admin/core/network/dio_client.dart';
import 'package:get/instance_manager.dart';

/// 💉 ربط وحقن التبعيات الأساسية للتطبيق (Dependency Injection)
class MyBinding extends Bindings {
  @override
  void dependencies() {
    // 1. حقن عميل Dio الموحد مع الـ Interceptors (دائم لا يُحذف من الذاكرة)
    final dioClient = Get.put<DioClient>(DioClient(), permanent: true);

    // 2. حقن خدمة الشبكة ApiService وتزويدها بعميل Dio
    Get.put<ApiService>(ApiServiceImpl(dioClient: dioClient), permanent: true);

    // 3. الإبقاء على Crud للتوافقية الشاملة مع ملفات data/remote الحالية
    Get.put(Crud(), permanent: true);
  }
}
```

وفي [main.dart](file:///e:/work/app/admin/lib/main.dart):
يتم تمرير `initialBinding: MyBinding()` إلى `GetMaterialApp`، مما يجعل `DioClient` و `ApiService` متاحين فوراً في أي شاشة أو Controller عبر:
```dart
final apiService = Get.find<ApiService>();
```

---

## 4. المقارنة الشاملة: كيف كانت وكيف صارت الآن؟

| وجه المقارنة | النظام السابق (`Crud` القديم) | النظام المحدث (`core/network`) |
| :--- | :--- | :--- |
| **محرك الاتصال** | مثيل Dio معزول بدون معترضات + مكتبة `http` | عميل `DioClient` موحد لجميع العمليات والملفات |
| **مصادقة التوكن (Auth)** | قراءة يدوية من `Hive` في كل استدعاء | حقن تلقائي عبر `Auth Interceptor` لكل طلب |
| **رفع الصور والملفات** | `http.MultipartRequest` بطيئة وقديمة | `Dio FormData` و `MultipartFile` سريعة ومستقرة |
| **المراقبة والتسجيل (Logging)** | لا يوجد (أو مجرد `print` لرمز الحالة) | سجل بصري أنيق في الكونسول يوضح Headers, Body, Response |
| **هيكلية الأخطاء** | Enum بدائي `Staterequest` فقط | شجرة كائنات `Failure` تحمل الرسائل ورموز الحالة بدقة |
| **استخراج رسائل الخادم** | تتجاهل رسائل الخادم وتعيد فشل عام | فحص ذكي لمخرجات الخادم (JSON / String) واستخراج نصوص التنبيه |
| **التوافقية وأمان الكود** | يعتمد عليه 10 ملفات في `data/remote` | تم ربطه بـ `Crud` كـ **Adapter** لمنع كسر أي كود قديم |

---

## 5. الخلاصة وأفضل الممارسات البرمجية

1. **للكود القديم (`lib/data/remote/`):**
   * يستمر في العمل فوراً وبدون أي تعديل عبر `Crud` الموائم.
2. **للميزات والشاشات الجديدة:**
   * يُوصى بكتابتها مباشرة عبر `ApiService` وفق نمط المستودع (`Repository Pattern`) الموضح في `clean_architecture_example.dart` لتحقيق أقصى درجات النظافة وسهولة الاختبار (Unit Testing).
