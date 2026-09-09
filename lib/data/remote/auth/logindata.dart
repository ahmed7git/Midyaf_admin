

import 'package:admin/applink.dart';
import 'package:admin/core/class/crud.dart';

class LoginData{
  Crud crud;
  LoginData(this.crud);

  postData(String email,String password )async{
    var response = await crud.postData(Applink.login, {
      "email": email,
      "password": password,
    });
    return response.fold((l)=>l, (r)=>r);

  }
}