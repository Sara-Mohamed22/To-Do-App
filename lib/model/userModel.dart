import 'package:flutter/cupertino.dart';

class UserModel
{
String? name ;
String? email ;
String? phone ;
String? uId ;

UserModel({@required this.name , @required this.email , @required this.phone ,@required this.uId });

Map<String , dynamic> ToJson()
{
  return {
    "name" : name,
    "email" : email,
    "phone" : phone ,

  };



}

UserModel.FromJson(Map<String , dynamic>json)
{
  name = json['name'];
  email = json['email'];
  phone= json['phone'];
  uId =json['uId'] ;

}


}