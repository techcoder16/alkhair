import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOut {

  late String agn_code;
  late String start_coordinates;
  late String date;
  late String started_at;
  late String distance;
  late String remarks;
  late String ended_at;
  late String end_coordinates;
  late String coor;


  CheckOut(



      {


       required this.agn_code,
       required this.start_coordinates,
       required this.date,
       required this.started_at,
       required this.distance,
       required this.remarks,
       required this.ended_at,
    required this.end_coordinates,
    required this.coor


      });


  factory CheckOut.fromJson(Map<String, dynamic> parsedJson) {
    return CheckOut(

        agn_code : parsedJson['agn_code'],
        start_coordinates : parsedJson['start_coordinates'],
        date : parsedJson['date'],
        started_at : parsedJson['started_at'],
        distance : parsedJson['distance'],
        remarks : parsedJson['remarks'],
        ended_at : parsedJson['ended_at'],
        end_coordinates : parsedJson['end_coordinates'],
      coor : parsedJson['coor'],

    );
  }

  Map<String, String> toJson() {
    return {

    'agn_code' : this.agn_code,
    'start_coordinates' : this.start_coordinates,
    'date' : this.date,
    'started_at' : this.started_at,
    'distance' : this.distance,
    'remarks' : this.remarks,
    'ended_at' : this.ended_at,
    'end_coordinates' : this.end_coordinates,
      'coor' :this.coor

    };
  }

}


saveDataCheckOut(

String agn_code,
String start_coordinates,
String date,
String started_at,
String distance,
String remarks,
String ended_at,
String end_coordinates,
    String coor


    ) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();



  CheckOut valueDist = CheckOut(


      agn_code:  agn_code,
      start_coordinates:  start_coordinates,
      date:  date,
      started_at:  started_at,
      distance:  distance,
      remarks:  remarks,
      ended_at:  ended_at,
      end_coordinates:  end_coordinates,
      coor:coor,







  );

  String? json = prefs.getString("dist_key_checkout");

  json = ((json == null ? "" : json) + jsonEncode(valueDist)!)! + " , ";

  prefs.setString("dist_key_checkout", json!);


}





Future<List<CheckOut>> loadDataCheckOut()
async {


  List<CheckOut> distList;


  SharedPreferences prefs = await SharedPreferences.getInstance();

//prefs.remove("dist_key");

  String? jsonStar = prefs.getString("dist_key_checkout");



  String returnJson= "";


  var splitString = jsonStar?.split(" , ");
  List<CheckOut> newdist = [];

try {
  splitString?.forEach((element) {
    try {
      String valueEdit = element;
      valueEdit = valueEdit.toString();

      jsonDecode(valueEdit).toString() + ",";

      CheckOut user = CheckOut.fromJson(jsonDecode(valueEdit));
      newdist.add(user);
    }
    catch (e) {
      print(e);
    }
  });
}
catch(e)
  {
    print(e);
  }
  return newdist;










}








