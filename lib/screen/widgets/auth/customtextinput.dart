import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Customtextinput extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final TextEditingController mycontroller;
  final String? Function(String?) valid;
  final bool isNumber;
  final bool isPassword;
  final void Function()? onTap;
  final bool? obscureText;

  const Customtextinput({
    super.key,
    required this.hintText,
    required this.iconData,
    required this.mycontroller,
    required this.valid,
    required this.isNumber,
    this.isPassword = false,
    this.onTap,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText == true,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      validator: valid,
      controller: mycontroller,
      style: TextStyle(
        fontFamily: 'IBMPlexSansArabic',
        color: const Color(0xFF1E242B),
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: AppColor.preimary,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(
          iconData,
          color: Colors.grey.shade500,
          size: 20.r,
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onTap,
                icon: Icon(
                  obscureText == true
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade500,
                  size: 20.r,
                ),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 16.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 1.2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: AppColor.preimary,
            width: 1.5.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1.2.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: Colors.red.shade600,
            width: 1.5.w,
          ),
        ),
      ),
    );
  }
}
