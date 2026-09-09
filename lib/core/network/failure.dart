import 'package:admin/core/functions/staterequest.dart';


abstract class Failure {
  final String message;
  final int? statusCode;
  final dynamic responseData;

  const Failure({
    required this.message,
    this.statusCode,
    this.responseData,
  });

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

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.responseData,
  });
}


class OfflineFailure extends Failure {
  const OfflineFailure({
    super.message = "لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة وإعادة المحاولة",
    super.statusCode,
    super.responseData,
  });
}


class UnAuthorizedFailure extends Failure {
  const UnAuthorizedFailure({
    super.message = "انتهت صلاحية الجلسة أو ليس لديك الصلاحية للوصول لهذا المورد",
    super.statusCode = 401,
    super.responseData,
  });
}


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
