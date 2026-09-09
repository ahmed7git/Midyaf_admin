import 'package:admin/controller/items/additem_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowCategoryBottomSheet {
  ShowCategoryBottomSheet({required AddItemControllerImp controller});

  final AddItemControllerImp controller = Get.find<AddItemControllerImp>();

  Future<dynamic> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'اختر القسم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (controller.categories.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      return ListTile(
                        // 🟢 استخدم المتغيرات الصحيحة من CategoriesModel
                        title: Text(category.categoriesNameAr ?? 'بدون اسم'),
                        subtitle: Text(category.categoriesName ?? ''),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          controller.selectCategory(category);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('لا توجد أقسام متاحة'),
                ),
            ],
          ),
        );
      },
    );
  }
}
