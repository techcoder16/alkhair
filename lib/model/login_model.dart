



// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';

class LoginRequestModel {
  String id;
  String name;
  String email;
  String api_token;
  String hr_code;
  String zone;
  String designation;
String avatar;



  LoginRequestModel({
    this.id = "",
    this.name="",
    this.email="",
    this.api_token="",
    this.hr_code = "",
    this.zone = "",
    this.designation = "",
this.avatar  = ""

  });


  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {




    return LoginRequestModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      api_token: json['api_token'],
      hr_code: json['hr_code'],
      designation: json['designation'],
      zone: json['zone'],
      avatar : json['avatar'],



    );
  }


}
