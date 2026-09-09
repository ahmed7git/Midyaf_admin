import 'package:admin/controller/items/additem_controller.dart';
import 'package:admin/core/functions/handlingrequest.dart';
import 'package:admin/screen/widgets/custominputtext.dart';
import 'package:admin/screen/widgets/items/itemssheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddItem extends StatelessWidget {
  const AddItem({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(AddItemControllerImp());
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة قسم جديد"), centerTitle: true),
      body: GetBuilder<AddItemControllerImp>(
        builder: (controller) => HandlingRequestView(
          staterequest: controller.staterequest,
          widget: Form(
            key: controller.formState,
            child: ListView(
              children: [
                Text(
                  "هنا يمكنك إضافة قسم جديد",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),

                Custominputtext(
                  controller: controller.itemsName,
                  label: 'اسم العنصر',
                  hintText: 'أدخل اسم العنصر الانجليزي',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم العنصر بالانجليزي';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.itemsNameAr,
                  label: 'اسم العنصر',
                  hintText: 'أدخل اسم العنصر بالعربي',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم العنصر بالعربي';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.itemsdescrAr,
                  label: 'وصف العنصر',
                  hintText: 'أدخل وصف العنصر بالعربي',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال وصف العنصر بالعربي';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.itemsdescr,
                  label: 'وصف العنصر',
                  hintText: 'أدخل وصف العنصر بالانجليزي',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال وصف العنصر بالانجليزي';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.itemsprice,
                  label: 'سعر العنصر',
                  hintText: 'أدخل سعر العنصر',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال سعر العنصر';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.itemscount,
                  label: 'عدد العناصر',
                  hintText: 'أدخل عدد العناصر',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال عدد العناصر';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Custominputtext(
                  controller: controller.itemsdiscount,
                  label: 'الخصم',
                  hintText: 'أدخل قيمة الخصم',
                  valid: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال عدد العناصر';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => ShowCategoryBottomSheet(controller: controller).show(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            controller.selectedCategoryName ?? 'اختر قسم',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
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
                                  '.jpg',
                                )|| controller.file!.path.toLowerCase().endsWith('.jpeg') ||
                                        controller.file!.path.toLowerCase().endsWith('.png') || controller.file!.path.toLowerCase().endsWith('.jpeg')
                                    ? Image.file(
                                        controller.file!,
                                        fit: BoxFit.cover,
                                      )
                                    : SvgPicture.file(
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
                                "إضافة صورة",
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
                  child: Text("إضافة القسم"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
