import 'dart:convert';
import 'package:admin/core/network/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class ApiExceptions {
  ApiExceptions._();
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
