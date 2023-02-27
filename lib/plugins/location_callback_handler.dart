import 'dart:async';

import 'package:background_locator/location_dto.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/MapLocation.dart';
import 'end_day.dart';
import 'location_service_repository.dart';

class LocationCallbackHandler {
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {


    SharedPreferences prefs = await SharedPreferences.getInstance() ;
    await    prefs.remove("location_key");

    await  prefs.setString("location_key","");
print("remove data");

    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();
    await myLocationCallbackRepository.init(params);

  }

  static Future<void> disposeCallback() async {



    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();
    await myLocationCallbackRepository.dispose();
  }

  static Future<void> callback(LocationDto locationDto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance() ;
 //await  saveData(locationDto.latitude, locationDto.longitude);
    String? json = prefs.getString("location_key");

print(json);
    json = (json ?? "") + locationDto.latitude.toString() + "," + locationDto.longitude.toString() + ",";


    prefs.setString("location_key", json);
  var  now = DateTime.now();
  var  formatter = DateFormat('yyyy-MM-dd');


   var  formattedDate = DateFormat.Hms().format(
      now,
    );

    var newDate =
        formattedDate.toString();

    print(newDate);
if(newDate == "00:00:00")
  {
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    prefs.setDouble("Opacity", 1);

    prefs.setDouble("Opacity2", 0.3);
    prefs.setDouble("LocationLattitude", 0.0);
    prefs.setDouble("LocationLongitude", 0.0);
    prefs.setBool("CheckIn", false);
    prefs.setBool("ShouldDisplay", false);


    /// destination marker


    prefs.setBool("CheckIn", false);

    prefs.setDouble("Opacity2", 0.3);
    onStop();

    //CheckOutSubmit(latlng, newDate);



  }



    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();
    await myLocationCallbackRepository.callback(locationDto);
  }

  static Future<void> notificationCallback() async {
    print('***notificationCallback');
  }
}
