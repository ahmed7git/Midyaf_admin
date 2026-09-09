import 'package:get/get_utils/get_utils.dart';

String? validInput(String val , int max , int min , String type)
{
  if (val.isEmpty) {
    return "err_empty".tr;
  }

 if(type=="email"){
  if(!GetUtils.isEmail(val)){
    return "err_email".tr;
  }
 }

 if(type=="username"){
  
  if(!GetUtils.isUsername(val)){
    return "err_username".tr;
  }
 }

 if(type=="phone"){
  if(!GetUtils.isNumericOnly(val)){
    return "err_phone".tr;
  }
 }

 if(val.length > max){
  return "${"err_max".tr} $max";
 }

 if(val.length < min){
  return "${"err_min".tr} $min";
 }

return null;

}