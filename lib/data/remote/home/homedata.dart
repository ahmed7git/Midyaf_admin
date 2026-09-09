
import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class HomeData{
  Crud crud;
  HomeData(this.crud);

  postData( )async{
    var response = await crud.postData(Applink.home, {});
    return response.fold((l)=>l, (r)=>r);

  }
}