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
    // 🌐 استدعاء دالة GET من الـ ApiService
    final result = await apiService.get("https://example.com/api/products/view.php");

    return result.fold((failure) => Left(failure),(response) {
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
    // 📸 استدعاء دالة uploadFile عبر Dio حصراً (بدون مكتبة http)
    final result = await apiService.uploadFile(
      "https://example.com/api/products/add.php",
      fileKey: "files", // اسم حقل الصورة في الباك اند
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

  /// دالة جلب المنتجات وتحديث حالة الشاشة
  Future<void> loadProducts() async {
    staterequest = Staterequest.loading;
    update();

    final result = await repository.fetchProducts();

    // 💡 تفكيك النتيجة باستخدام نمط result.fold
    result.fold(
      // 🔴 معالجة حالة الفشل وتحديث حالة الواجهة وعرض التنبيه
      (failure) {
        errorMessage = failure.message;
        staterequest = failure.toStateRequest(); // تحويل ذكي للـ Staterequest

        Get.snackbar(
          "تنبيه",
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      // 🟢 معالجة حالة النجاح وتعبئة البيانات
      (data) {
        products.clear();
        products.addAll(data);

        if (products.isEmpty) {
          staterequest = Staterequest.failure; // شاشة فارغة Empty Data
        } else {
          staterequest = Staterequest.success; // نجاح وعرض البيانات
        }
      },
    );

    update();
  }

  /// دالة رفع المنتج مع الصورة
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
        loadProducts(); // إعادة التحديث
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
