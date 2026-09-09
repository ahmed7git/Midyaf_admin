import 'package:admin/core/constant/app_color.dart';
import 'package:admin/core/constant/app_images.dart';
import 'package:flutter/material.dart';

class Carthome extends StatelessWidget {
  final Color? color;
  final String? text;
  final String? image;
  final void Function()? onTap;
  const Carthome({super.key , this.color, this.text, this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              color: AppColor.black.withValues(alpha: 0.4),
              blurRadius: 4.8,
              spreadRadius: 0.0,
            ),
          ],
        ),
      
        child:Column(
          children: [
            Image.asset(  AppImages.logo,width: 80,height: 80,),
            Text(text!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) ,
      ),
    );
  }
}
