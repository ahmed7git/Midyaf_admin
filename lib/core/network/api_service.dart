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
        // دعم الصيغ الشائعة مثل application/x-www-form-urlencoded في حال الرغبة
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

      // بناء ملف الـ Multipart عبر Dio حصراً
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
