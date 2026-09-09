
import 'dart:io';

import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class Itemsdata{
  Crud crud;
  Itemsdata(this.crud);

  postData( )async{
    var response = await crud.postData(Applink.viewItems, {});
    return response.fold((l)=>l, (r)=>r);

  }

  addData(Map<String, String> data,File? image)async{
    var response = await crud.addRequestWithImageOne(Applink.addItem, data, image, "items_images");
    return response.fold((l)=>l, (r)=>r);
  }

  deleteData(String id, String image)async{
    var response = await crud.postData(Applink.deleteItem, {"items_id":id,"items_images":image});
    return response.fold((l)=>l, (r)=>r);
  }

  editData(Map<String, String> data,File? image)async{
     var response;
     if(image == null){
      response = await crud.postData(Applink.editItem, data);
    } else {
      response = await crud.addRequestWithImageOne(Applink.editItem, data, image, "items_images");
    }
    return response.fold((l)=>l, (r)=>r);
  }

}