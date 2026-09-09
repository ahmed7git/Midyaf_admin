
import 'dart:io';

import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class Categoriesdata{
  Crud crud;
  Categoriesdata(this.crud);

  postData( )async{
    var response = await crud.postData(Applink.viewCategory, {});
    return response.fold((l)=>l, (r)=>r);

  }

  addData(Map<String, String> data,File? image)async{
    var response = await crud.addRequestWithImageOne(Applink.addCategory, data, image, "categories_image");
    return response.fold((l)=>l, (r)=>r);
  }

  deleteData(String id, String image)async{
    var response = await crud.postData(Applink.deleteCategory, {"categories_id":id,"categories_image":image});
    return response.fold((l)=>l, (r)=>r);
  }

  editData(Map<String, String> data,File? image)async{
     var response;
     if(image == null){
      response = await crud.postData(Applink.editCategory, data);
    } else {
      response = await crud.addRequestWithImageOne(Applink.editCategory, data, image, "categories_image");
    }
    return response.fold((l)=>l, (r)=>r);
  }

}