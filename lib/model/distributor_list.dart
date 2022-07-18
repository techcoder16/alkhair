// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dist {

  late String distributor_type;
  late String name;
  late String shop_name;
  late String email;
  late String cnic;
  late String address;
  late String city;
  late String coordinates;
late String width;
  late String depth;

  // ignore: non_constant_identifier_names
  late String shop_size;
  late String floor;
  late String owned;

  late String covered_sale;
  late String uncovered_sale;
  late String total_sale;

  late String credit_limit;

  late String companies_working_with;
  late String working_with_us;

  late String our_brands;

  late String contact_no_1;
  late String contact_no_2;
  late String password;

  late String password_confirmation;
  late String added_by;
  late String fileOne;
  late String fileTwo;
  late String fileThree;




  Dist(



      {


    required this.distributor_type,
    required this.name,
    required this.shop_name,
    required this.email,
    required this.cnic,
    required this.address,
    required this.city,
    required this.coordinates,
    required this.shop_size,
        required this.width,
        required this.depth,

    required this.floor,
    required this.owned,
    required this.covered_sale,
    required this.uncovered_sale,
    required this.total_sale,
    required this.credit_limit,
    required this.companies_working_with,
    required this.working_with_us,
    required this.our_brands,
    required this.contact_no_1,
    required this.contact_no_2,
    required this.password,
    required this.password_confirmation,
    required this.added_by,
   required this.fileOne,
   required this.fileTwo,
   required this.fileThree,


  });


  factory Dist.fromJson(Map<String, dynamic> parsedJson) {
    return Dist(

      distributor_type: parsedJson['distributor_type'],
      name: parsedJson['name'],
      shop_name: parsedJson['shop_name'],
      email: parsedJson['email'],
      cnic: parsedJson['cnic'],
      address: parsedJson['address'],
      city: parsedJson['city'],
      coordinates: parsedJson['coordinates'],
      shop_size: parsedJson['shop_size'],
      width:parsedJson['width'],
      depth:parsedJson['depth'],

      floor: parsedJson['floor'],
      owned: parsedJson['owned'],
      covered_sale: parsedJson['covered_sale'],
      uncovered_sale: parsedJson['uncovered_sale'],
      total_sale: parsedJson['total_sale'],
      credit_limit: parsedJson['credit_limit'],
      companies_working_with: parsedJson['companies_working_with'],
      working_with_us: parsedJson['working_with_us'],
      our_brands: parsedJson['our_brands'],
      contact_no_1: parsedJson['contact_no_1'],
      contact_no_2: parsedJson['contact_no_2'],
      password: parsedJson['password'],
      password_confirmation: parsedJson['password_confirmation'],
      added_by: parsedJson['added_by'],
        fileOne : parsedJson['fileOne'],
        fileTwo: parsedJson['fileTwo'],
        fileThree:parsedJson['fileThree'],


    );
  }

  Map<String, String> toJson() {
    return {


      'distributor_type': this.distributor_type,
      'name': this.name,
      'shop_name': this.shop_name,
      'email': this.email,
      'cnic': this.cnic,
      'address': this.address,
      'city': this.city,
      'coordinates': this.coordinates,
      'shop_size': this.shop_size,
      'floor': this.floor,
      'owned': this.owned,
      'covered_sale': this.covered_sale,
      'uncovered_sale': this.uncovered_sale,
      'total_sale': this.total_sale,
      'credit_limit': this.credit_limit,
      'companies_working_with': this.companies_working_with,
      'working_with_us': this.working_with_us,
      'our_brands': this.our_brands,
      'contact_no_1': this.contact_no_1,
      'contact_no_2': this.contact_no_2,
      'password': this.password,
      'password_confirmation': this.password_confirmation,
      'added_by': this.added_by,
      'fileOne': this.fileOne ,
      'fileTwo': this.fileTwo ,
      'fileThree': this.fileThree ,
      'width': this.width ,
      'depth': this.depth ,


    };
  }

}


 saveDataDistributor(

  String distributor_type,
  String name,
  String shop_name,
  String email,
  String cnic,
  String address,
  String city,
  String coordinates,
  String shop_size,
  String floor,
  String owned ,
  String covered_sale,
  String uncovered_sale,
  String total_sale ,
  String credit_limit ,
  String companies_working_with,
  String working_with_us ,
  String our_brands ,
  String contact_no_1,
  String contact_no_2,
  String password ,
  String password_confirmation,
  String added_by ,
     String fileOne,
     String fileTwo,
     String fileThree,

     String width,
     String depth

 ) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();



   Dist valueDist = Dist(


     distributor_type:  distributor_type,
     name:  name,
     shop_name:  shop_name,
     email:  email,
     cnic:  cnic,
     address:  address,
     city:  city,
     coordinates:  coordinates,
     shop_size:  shop_size,
     floor:  floor,
     owned :  owned ,
     covered_sale:  covered_sale,
     uncovered_sale:  uncovered_sale,
     total_sale :  total_sale ,
     credit_limit :  credit_limit ,
     companies_working_with:  companies_working_with,
     working_with_us :  working_with_us ,
     our_brands :  our_brands ,
     contact_no_1:  contact_no_1,
     contact_no_2:  contact_no_2,
     password :  password ,
     password_confirmation:  password_confirmation,
     added_by :  added_by, fileOne: fileOne ,
     fileTwo: fileTwo ,
     fileThree: fileThree ,
     width: width ,
     depth: depth ,





   );

     String? json = prefs.getString("dist_key");

     json = ((json ?? "") + jsonEncode(valueDist)!)! + " , ";

     prefs.setString("dist_key", json!);


 }





Future<List<Dist>> loadDataDistributor()
async {


List<Dist>? distList;


  SharedPreferences prefs = await SharedPreferences.getInstance();

//prefs.remove("dist_key");

  String? jsonStar = prefs.getString("dist_key");





var splitString = jsonStar?.split(" , ");
List<Dist> newdist = [];


splitString?.forEach((element) {
try {
  String valueEdit = element;
  valueEdit = valueEdit.toString();

  jsonDecode(valueEdit).toString() + ",";


  Dist user = Dist.fromJson(jsonDecode(valueEdit));
  newdist.add(user);

}
catch(e)
  {

  }

});


  return newdist;










}







