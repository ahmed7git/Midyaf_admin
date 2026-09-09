

import 'package:admin/core/functions/staterequest.dart';

handlingData(response){
 if (response is Staterequest ){
  return response;
 }
 else{
  return Staterequest.success;
 }

}