import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assets/globals.dart';

class MapLocation {
  double lattitude ;
  double longitude;

  MapLocation({required this.lattitude, required this.longitude});

  factory MapLocation.fromJson(Map<String, dynamic> parsedJson) {
    return  MapLocation(
        lattitude: parsedJson['lattitude'] ?? 0,
        longitude: parsedJson['longitude'] ?? 0

    );

  }

  Map<String, dynamic> toJson() {
    return {
      "lattitude": this.lattitude,
      "longitude" : this.longitude

    };
  }



}


Future<String> loadData() async {


  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? json = prefs.getString("location_key");
json ??= location_key;


  if (json == null) {

  } else {



      json = json.substring(0, json.length - 1);
return json!;


  }

  return json!;




}

Future<String> saveData(double lat, double long) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  MapLocation location = MapLocation(lattitude: lat, longitude: long);

  if (lat > 0 && long > 0) {
    String? json = prefs.getString("location_key");

    json = (json ?? "") + lat.toString() + "," + long.toString() + ",";
    location_key = json;

    prefs.setString("location_key", json);
    print(location_key);
    location_key = json;

return location_key;

  }
  return location_key;

}

Future<bool> clearData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString("location_key") == null) {
    return true;
  }
  return false;
}



/// ==================================== save long lat realtime========


