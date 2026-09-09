import 'package:flutter/material.dart';

class Custominputtext extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? iconData;
  final String? Function(String?)? valid; 
  final bool isNumber; 
  final bool isPassword;
  final bool? obscureText;
  final void Function()? onTapIcon; 

  const Custominputtext({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.iconData,
    this.valid,
    this.isNumber = false,
    this.isPassword = false,
    this.obscureText,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: valid, 
      keyboardType: isNumber 
          ? const TextInputType.numberWithOptions(decimal: true) 
          : TextInputType.text,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.always, // مظهر احترافي للـ Label بالعلّي
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        
        suffixIcon: iconData != null
            ? IconButton(
                icon: Icon(iconData),
                onPressed: onTapIcon,
              )
            : null,
 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2), // تمييز الحقل النشط
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5), // تمييز حقل الخطأ
        ),
      ),
    );
  }
}