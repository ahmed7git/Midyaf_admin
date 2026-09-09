import 'package:admin/controller/category/editcate_controller.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/custominputtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditCategory extends StatelessWidget {
  const EditCategory({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditcateControllerImp());
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل القسم"), centerTitle: true),
      body: GetBuilder<EditcateControllerImp>(
        builder: (controller) => HandlingRequestView(
          staterequest: controller.staterequest,
          widget: Form(
            key: controller.formState,
            child: Column(
              children: [
                Text(
                  "هنا يمكنك تعديل القسم",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),

                Custominputtext(
                  controller: controller.categoriesName,
                  label: 'اسم القسم',
                  hintText: 'أدخل اسم القسم الانجليزي',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم القسم بالانجليزي';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.categoriesNameAr,
                  label: 'اسم القسم',
                  hintText: 'أدخل اسم القسم بالعربي',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم القسم بالعربي';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                InkWell(
                  onTap: () {
                    controller.chooseFile();
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: controller.file != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child:
                                controller.file!.path.toLowerCase().endsWith(
                                  '.svg',
                                )
                                ? SvgPicture.file(
                                    controller.file!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    controller.file!,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "تعديل الصورة",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    controller.addData();
                  },
                  child: Text("تعديل القسم"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
