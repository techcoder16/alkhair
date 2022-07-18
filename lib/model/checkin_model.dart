



import 'package:flutter/cupertino.dart';

class CheckInModel {
  String trip_id;

  String agn_code;
  String start_coordinates;
  String date;
  String started_at;


  CheckInModel({
    this.trip_id = "",
    this.agn_code = "",
    this.start_coordinates="",
    this.date="",
    this.started_at="",


  });


  factory CheckInModel.fromJson(Map<String, dynamic> json) {




    return CheckInModel(
      trip_id:json['trip_id'],
      agn_code: json['agn_code'],
      start_coordinates: json['start_coordinates'],
      date: json['date'],
      started_at: json['started_at'],


    );
  }


}
