import 'package:admin/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomexitDialog {
  static void show({
    required String title,
    required String message,
    required String buttonTextone,
    required String buttonTexttwo,
    required void Function() onPressedone,
    required void Function() onPressedtwo,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.preimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_outlined,
                  color: AppColor.preimary,
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                title.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                message.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  // الزر الأول: خروج
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPressedone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.preimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonTextone.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // مسافة فاصلة ثابتة بين الزرين
                  const SizedBox(width: 16),

                  // الزر الثاني: إلغاء
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPressedtwo,
                      style: ElevatedButton.styleFrom(
                        // نصيحة: اجعل لون زر الإلغاء مختلفاً (مثلاً رمادي) لراحة العين
                        backgroundColor: Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonTexttwo.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
