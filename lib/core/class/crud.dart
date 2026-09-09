import 'dart:convert';
import 'dart:io';
import 'package:admin/core/services/services.dart';
import 'package:dartz/dartz.dart';
import 'package:admin/core/functions/checkinternet.dart';
import 'package:admin/core/functions/staterequest.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class Crud {
  MyServices myServices = Get.find<MyServices>();

  Map<String, String> get _myheaders {
    String? token = myServices.box.get("token");

    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) {
        return status != null && status < 600;
      },
    ),
  );
  Future<Either<Staterequest, Map>> postData(String linkurl, Map data) async {
    try {
      if (!await checkInternet()) {
        return const Left(Staterequest.offlinefailure);
      }

      Map<String, dynamic> fromData = Map<String, dynamic>.from(data);

      final response = await dio.post(linkurl, data: fromData , options: Options(contentType: Headers.formUrlEncodedContentType , responseType: ResponseType.json));
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responseBody;

        if (response.data is Map) {
          responseBody = response.data;
        } else if (response.data is String) {
          try {
            responseBody = jsonDecode(response.data);
          } catch (e) {
            debugPrint("Server Raw Response Error: ${response.data}");
            return const Left(Staterequest.serverfailure);
          }
        } else {
          responseBody = jsonDecode(response.data.toString());
        }
        return Right(responseBody);
      }
      else {
        return const Left(Staterequest.serverfailure);
      }
    } on DioException catch (e) {
      debugPrint("Dio Error Type: ${e.type}");
      debugPrint("Dio Error Message: ${e.message}");
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        return const  Left(Staterequest.offlinefailure);
      }
      if (e.type == DioExceptionType.badResponse) {
        return const Left(Staterequest.serverfailure);
      }

      return const   Left(Staterequest.serverException);
    } catch (error) {
      debugPrint("الخطأ الحقيقي هو: $error");
      return Left(Staterequest.serverException);
    }
  }

  Future<Either<Staterequest, Map>> addRequestWithImageOne(
    String url,
    Map<String, String> data,
    File? image, [
    String? namerequest,
  ]) async {
    namerequest ??= "files";

    try {
      var uri = Uri.parse(url);
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(_myheaders);

      if (image != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          namerequest,
          image.path,
          filename: p.basename(image.path),
        );
        request.files.add(multipartFile);
      }

      // إضافة البيانات النصية إلى الطلب
      data.forEach((key, value) {
        request.fields[key] = value;
      });

      // إرسال الطلب واستقبال الرد
      var myrequest = await request.send();
      var response = await http.Response.fromStream(myrequest);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("تم استقبال الرد بنجاح هندسي: ${response.body}");
        Map responsebody = jsonDecode(response.body);
        return Right(responsebody);
      } else {
        return const Left(Staterequest.serverfailure);
      }
    } catch (e) {
      debugPrint("خطأ غير متوقع في الاتصال: $e");
      return const Left(Staterequest.serverException);
    }
  }
}
