// ignore_for_file: await_only_futures

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:alkahir/plugins/global.dart';
import 'package:alkahir/plugins/start_day.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui';

import 'package:background_locator/settings/android_settings.dart'
    as android_settings;

import 'package:background_locator/settings/locator_settings.dart'
    as locator_settings;

import 'package:background_location/background_location.dart';

import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart' as ios_settings;

import 'assets/globals.dart';
import 'login.dart';
import 'model/checkout_model.dart';
import 'model/distributor_list.dart';
import 'plugins/location_callback_handler.dart';
import 'plugins/location_service_repository.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'add_dist.dart';
import 'listview.dart';
import 'model/checkin_model.dart';

import 'model/MapLocation.dart';

class BoardView extends StatefulWidget {
  @override
  _BoardViewScreenState createState() => _BoardViewScreenState();
}

enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }

class _BoardViewScreenState extends State<BoardView>
    with WidgetsBindingObserver {
  ReceivePort port = ReceivePort();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  String logStr = '';
  bool? isRunning;
  LocationDto? lastLocation;

  bool _mapCreated = false;
  Uint8List? _imageBytes;
  double zoomLevel = 15;
  var now;
  var formatter;
  String newDate = "";
  String checkoutDate = "";
  String formattedDate = "";
  String CheckInTime = "";
  String CheckOutTime = "";
  var start_day = "";
  var end_day = "";

  String zone = "";
  String designation = "";
  String id = "";
  bool checkEndDay = false;

  List<LatLng> latlng = [];

  String email = "";
  String name = "";
  bool login = false;
  CheckInModel newRequestModel = CheckInModel();

  ScreenshotController screenshotController = ScreenshotController();

  List<String> ListName = [];

  bool shouldDisplay = false;
  bool checkTapcount = false;
  bool checkInternet = false;
  double checkinOp = 1;
  String? coordinates  = "";
  var imageLogin = "";
  double checkOutOpacity = 0.3;
  double startDayOp = 1;
  double endDayOp = 1;

  final TextEditingController _RemarksController = TextEditingController();
  String check_time = "";
  late ProgressDialog pr;
  LatLng currentPostion = LatLng(0, 0);

  var val = false;
  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzo75YZ1hfbKAQPDvo0Tfyys9Zo6c9hk";
  var status_of_button = false;
  int changeopacity = 1;

  double currentlattitude = 0;
  double currentlongitude = 0;

  CheckInModel checkInRequestModel = CheckInModel();

  /// ==================================== save long lat realtime================

  /// ====================================  screen shot===================

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  /// =============================== screen shot===================

  ///================================= see location data ===========

  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  ///================================== see location data ===========

  ///================================== get values from shared preferences ====
  Future<void> getValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var now = new DateTime.now();
    var berlinWallFellDate = new DateTime.now();
print(now);

    String formattedTime = DateFormat.Hms().format(now);
    print(formattedTime);

    if(formattedTime.compareTo("00:00:00")==0)
      {

        newDate = await preferences.getString("checkOutTime")!;
        print(newDate);


String xyz =  await preferences.getString("time")!;
     await preferences.setString( "SessionDay", xyz);


        await preferences.setString("checkOutTime","")!;




      }
    else
      {


      }
    zone = await preferences.getString("zone")!;
    designation = await preferences.getString("designation")!;
    email = await preferences.getString("email").toString();
    id = await preferences.getString("id").toString();
    name = await preferences.getString("name").toString();
    login = await preferences.getBool("isLogin")!;

    try{
    coordinates = await preferences.getString("location_key");


    }catch(e)
    {
print(e);

    }
    try {
      start_day = await preferences.getString("startDay")!;
    } catch (e) {}
    try {
      checkinOp = await preferences.getDouble("Opacity")!;
    } catch (e) {}
    try {
      checkOutOpacity = await preferences.getDouble("Opacity2")!;
    } catch (e) {}
    try {
      checkinOp = await preferences.getDouble("Opacity")!;
    } catch (e) {}
    try {
      newDate = await preferences.getString("time")!;
    } catch (e) {}

    try {
      checkoutDate = await preferences.getString("checkOutTime")!;
    } catch (e) {}

    try {
      shouldDisplay = await preferences.getBool("ShouldDisplay")!;
    } catch (e) {}

    currentlattitude = await preferences.getDouble("LocationLattitude")!;
    currentlongitude = await preferences.getDouble("LocationLongitude")!;

    try {
      checkTapcount = await preferences.getBool("CheckIn")!;
          checkEndDay = await preferences.getBool("SessionDay")!;

    } catch (e) {}

    try {} catch (e) {}

    try {
      imageLogin = preferences.getString("avatar")!;
    } catch (e) {}

    if (checkTapcount == true) {
      if (await BackgroundLocator.isServiceRunning()) {
      } else {
        _onStart();
      }
    }
  }

  ///================================== get values from shared preferences =====

  ///================================== check in when punch =============

  Future<bool> checkIn(String agnCode, LatLng coordinates, String date,
      String startedAt, String apiToken) async {
    showAlertDialog(context, "Alert", "Check In Successfull!!!");

    return false;
  }

  ///==================================check in when punhc ==============

  String _splitString(String value) {
    var arrayOfString = value.split(' ');

    if (arrayOfString.isEmpty) {
      return "";
    } else {
      if (arrayOfString.isNotEmpty) {
        if (arrayOfString.length > 1) {
          return arrayOfString[1];
        }
      } else
        return "";
    }
    return "";
  }

  ///=============================================Punch Out =============
  Future<bool> CheckOutSubmit(List<LatLng> latlng, String newDate) async {
    onStop();



    SharedPreferences prefs = await SharedPreferences.getInstance();






    final _isRunning = await BackgroundLocator.isServiceRunning();

    if (_isRunning == false) {}
    double distanceInMeters = 0;

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    now = DateTime.now();
    formatter = DateFormat('yyyy-MM-dd');


    //  latlng = (await loadData())!;

    try {
      distanceInMeters = Geolocator.distanceBetween(
          latlng[0].latitude,
          latlng[0].longitude,
          latlng[latlng.length - 1].latitude,
          latlng[latlng.length - 1].longitude);
    } catch (e) {
      print(e);
    }



    // removeData();

    var formattedDate1 = DateFormat.Hms().format(now);

    var newDate1 =
        formatter.format(now).toString() + " " + formattedDate1.toString();
    CheckOutTime = newDate1;
    Map<String, String> data = {
      'agn_code': id,
      'trip_id': checkInRequestModel.trip_id.toString(),
      'distance': distanceInMeters.toString(),
      'remarks': 'no remarks',
      'ended_at': newDate1,
      'end_coordinates': '0',
      '_method': 'PATCH',
      'coor': coordinates!
    };

    _getUserLocation();

    SharedPreferences pref = await SharedPreferences.getInstance();

    newDate = (await pref.getString("time"))!;

    await pref.setString("checkOutTime", newDate1);
    CheckOutTime = newDate1;

    saveDataCheckOut(
        id,
        '0',
        newDate.toString(),
        newDate.toString(),
        distanceInMeters.toString(),
        "no remarks",
        newDate1,
        coordinates!,
        coordinates!);

    showAlertDialog(context, "Alert", "Check Out Successfully!!!");

    return true;
  }

  ///=============================================Punch Out ====================
  ///================================== show dialog ============================

  showGoogleMapDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          _getUserLocation();

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                actions: [
                  ElevatedButton(
                    child: Column(children: const <Widget>[
                      Icon(Icons.location_on_sharp,
                          color: Color.fromRGBO(55, 75, 167, 1)),
                      Text(
                        "Check Out",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 11,
                            fontFamily: 'Raleway'),
                      ),
                    ]),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(20),
                      primary: Color.fromRGBO(247, 248, 250, checkOutOpacity),
                      onPrimary: Color.fromRGBO(247, 248, 250, checkOutOpacity),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      final Uint8List? imageBytes =
                          await mapController.takeSnapshot();

                      if (latlng.isNotEmpty) {
                        // onStop();
                        setState(() async {
                          /*   screenshotController
                              .capture(delay: Duration(milliseconds: 10))
                              .then((capturedImage) async {
                            ShowCapturedWidget(context, capturedImage!);
                          }).catchError((onError) {
                            print(onError);
                          });
*/
                          prefs.setDouble("Opacity", 1);

                          prefs.setDouble("Opacity2", 0.3);
                          prefs.setDouble("LocationLattitude", 0.0);
                          prefs.setDouble("LocationLongitude", 0.0);
                          prefs.setBool("CheckIn", false);
                          prefs.setBool("ShouldDisplay", false);

                          BackgroundLocation.stopLocationService();

                          checkOutOpacity = 0.3;
                          checkinOp = 1;
                          shouldDisplay = false;

                          /// destination marker

                          checkTapcount = false;
                          prefs.setBool("CheckIn", false);

                          checkOutOpacity = 0.3;
                          prefs.setDouble("Opacity2", checkOutOpacity);

                          //     _getPolyline();

                          /*     double distance = Geolocator.distanceBetween(
                              latlng[0].latitude,
                              latlng[0].longitude,
                              latlng[latlng.length - 1].latitude,
                              latlng[latlng.length - 1].longitude);

                          zoomLevel = 1000 - distance;

                          checkTapcount = false;

                          screenshotController
                              .capture(delay: Duration(milliseconds: 10))
                              .then((capturedImage) async {
                            ShowCapturedWidget(context, capturedImage!);
                          }).catchError((onError) {
                            print(onError);
                          });

                          _imageBytes = await mapController.takeSnapshot();
                          setState(() {
                            _imageBytes = imageBytes;
                          });
                          mapController.setMapStyle("[]");


                      */
                          getValues();
                          CheckOutSubmit(latlng, newDate);

                          //    remove();
                          latlng = [];
                          //   onStop();

                          // mapController.setMapStyle("[]");
                        });

                        Navigator.pop(context, false);
                      } else {
                        showAlertDialog(
                            context, "Alert", "Failed Check out Is Empty");
                        Navigator.pop(context, false);
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Icon(
                      Icons.cancel_sharp,
                      color: Colors.black,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(20),
                      primary: Color.fromRGBO(247, 248, 250, 1),
                      onPrimary: Color.fromRGBO(247, 248, 250, 1),
                    ),

                    onPressed: () => Navigator.pop(context, false),
                    // passing false
                  ),
                ],
                backgroundColor: Colors.white,
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 1000,
                      width: 700,
                      child: Scaffold(
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: Future.wait(
                                    [_getUserLocation(), getValues()]),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      height: 700,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                            target: currentPostion,
                                            zoom: zoomLevel),
                                        myLocationEnabled: true,
                                        tiltGesturesEnabled: true,
                                        compassEnabled: true,
                                        scrollGesturesEnabled: true,
                                        zoomGesturesEnabled: true,
                                        onMapCreated: _onMapCreated,
                                        markers: Set<Marker>.of(markers.values),
                                        polylines:
                                            Set<Polyline>.of(polylines.values),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 40.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }));
          });
        });
  }

  showAlertDialog(BuildContext context, String title, String desc) {
    // set up the button
    Widget okButton = TextButton(
        child: Text("OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.normal,
              fontFamily: 'Raleway',
            )),
        onPressed: () async {
          if (await pr.isShowing()) {
            await pr.hide();
          }
          if (Navigator.canPop(context) == true) {
            Navigator.pop(context);
          }
        });

    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.normal,
          fontFamily: 'Raleway',
        ),
      ),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
      backgroundColor: Color.fromRGBO(55, 75, 167, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Text(
        desc,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.normal,
          fontFamily: 'Raleway',
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ///*============================to location plugin carp=======================

  Future<void> updateUI(LocationDto data) async {
    await _updateNotificationText(data);
try {
  saveData(data.latitude, data.longitude);
}
catch(e)
    {


    }
    setState(() {
      if (data != null) {
        lastLocation = data;
      }
    });
  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();

    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = true;
    });
  }

  void onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
  }

  void _onStart() async {

      await _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();

      setState(() {
        isRunning = _isRunning;
        lastLocation = null;
      });

  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: "AlKhair Location Gadoon Tracker received",
        msg: "${DateTime.now()}",
        bigMsg: "");
  }

  Future<bool> _determinePosition() async {
    if (isRunning == true) {
      _onStart();
    }
    bool? serviceEnabled = false;
    LocationPermission permission;

    // Test if location services are enabled.
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    } catch (e) {}

    if (!serviceEnabled!) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: ios_settings.IOSSettings(
            accuracy: locator_settings.LocationAccuracy.NAVIGATION,
            distanceFilter: 0),
        autoStop: false,
        androidSettings: android_settings.AndroidSettings(
            accuracy: locator_settings.LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking Al Khair',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Tracking location in background',
                notificationBigMsg: 'Al khair is Tracking your location.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }

  Future<void> CheckPermissionClosed() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      while (Navigator.canPop(context) == true) {
        Navigator.pop(context);
      }

      //onStop();

      preferences.remove("isLogin");
      preferences.setBool("isLogin", false);
      preferences.clear();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  ///*============to location plugin carp======================================

  @override
  void initState() {
    initConnectivity();


    _addMarker(LatLng(currentPostion.latitude, currentlongitude), "origin",
        BitmapDescriptor.defaultMarker);

    if (IsolateNameServer.lookupPortByName(
        LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
          (dynamic data) async {
        try {
          await updateUI(data);
        }
        catch(e)
        {

        }
        //  await loadData(latlng);
      },
    );
    initPlatformState();

    setState(() {
      getValues();

      try {
        // if(latlng.isNotEmpty)
        //{
        //     latlng =[];
        //}

        //  latlng = ( loadData(latlng))! as List<LatLng>;
        // print(latlng);

      } catch (e) {
        //  print(e);
      }
    });

    _getUserLocation();
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false);

    pr.style(
      padding: const EdgeInsets.all(16),
      message: 'Please wait...',
      borderRadius: 3.0,
      backgroundColor: Colors.white,
      progressWidget: const CircularProgressIndicator(
        strokeWidth: 3,
        backgroundColor: Color.fromRGBO(55, 75, 167, 1),
      ),
      elevation: 2.0,
      insetAnimCurve: Curves.bounceIn,
      progressTextStyle: const TextStyle(
          color: Color.fromRGBO(55, 75, 167, 1),
          fontSize: 2.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: const TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.normal,
          color: Colors.grey),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///======== loading dialoge ================================================

    ///============================================= loading dialoge ================================================

    return WillPopScope(
      onWillPop: () async {
        while (Navigator.canPop(context)) {
          Navigator.of(context).pop(false);
        }
        ;

        return false;
      },
      child: FutureBuilder(
        future: Future.wait([getValues(), CheckPermissionClosed()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          return Scaffold(
            drawer: NavBar(
              status: checkTapcount,
              id: this.id,
              email: this.email,
              name: this.name,
              latlng: latlng,
              zone: this.zone,
              designation: this.designation,
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Stack(children: <Widget>[
                Container(
                    child: Stack(children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(20, 360, 10, 0),
                    height: 100,
                    child: const Text(
                      "Pick your choice",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(20, 450, 10, 0),
                    height: 100,
                    width: 100,
                    child: InkWell(
                      overlayColor: MaterialStateProperty.all(Colors.white),
                      hoverColor: Colors.white,
                      highlightColor: Colors.white,
                      onTap: () async {
                        if (checkTapcount == false) {
                          await pr.show();

                          _onStart();

                          now = DateTime.now();
                          formatter = DateFormat('yyyy-MM-dd');

                          formattedDate = DateFormat.Hms().format(
                            now,
                          );

                          newDate = formatter.format(now).toString() +
                              " " +
                              formattedDate.toString();
                          check_time = formattedDate;
                          checkinOp = 0.3;

                          shouldDisplay = !shouldDisplay;

                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();

                          sharedPreferences.setBool(
                              "ShouldDisplay", shouldDisplay);
                          sharedPreferences.remove("location_key");


                          _getUserLocation();
                          sharedPreferences.setDouble(
                              "LocationLattitude", currentlattitude);
                          sharedPreferences.setDouble(
                              "LocationLongitude", currentlongitude);

                          if (currentPostion.latitude == 0) {
                            currentPostion = LatLng(
                                await sharedPreferences
                                    .getDouble("LocationLattitude")!,
                                await sharedPreferences
                                    .getDouble("LocationLongitude")!);
                          }
                          _addMarker(
                              LatLng(currentPostion.latitude, currentlongitude),
                              "origin",
                              BitmapDescriptor.defaultMarker);

                          checkIn(this.id, currentPostion,
                              formatter.format(now).toString(), newDate, "");
                          checkOutOpacity = 1;

                          sharedPreferences.setDouble("Opacity", checkinOp);
                          sharedPreferences.setDouble(
                              "Opacity2", checkOutOpacity);

                          sharedPreferences.setString("time", newDate);

                          checkTapcount = true;

                          sharedPreferences.setBool("CheckIn", true);

                          if (start_day == "") {
                            start_day = newDate;
                            sharedPreferences.setString("startDay", newDate);
                          }

                          if (await pr.isShowing()) {
                            try {
                              await pr.hide();
                              pr.hide();

                              pr.hide();
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              pr.hide();
                              print(e);
                            }
                          }
                          pr.hide();
                          await pr.hide();

                          showAlertDialog(
                              context, "Alert", "Check In Successfull!!!");

                          _getUserLocation();
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Image.asset(
                            'assets/Picture2.png',
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Check In",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(247, 248, 250, checkinOp),
                      //  borderRadius: BorderRadius.circular(30), //border corner radius
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), //color of shadow
                          spreadRadius: 5, //spread radius
                          blurRadius: 7, // blur radius
                          offset: Offset(0, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(140, 450, 10, 0),
                    height: 100,
                    width: 100,
                    child: InkWell(
                      overlayColor: MaterialStateProperty.all(Colors.white),
                      focusColor: Colors.white,
                      highlightColor: Colors.white,
                      hoverColor: Colors.white,
                      onTap: () async {
                        if (checkTapcount == true) {
                          await pr.show();
                          _getUserLocation();

                          _addMarker(
                              LatLng(currentPostion.latitude, currentlongitude),
                              "origin",
                              BitmapDescriptor.defaultMarker);

                          if (checkTapcount == true) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            prefs.setDouble("Opacity", 1);

                            prefs.setDouble("Opacity2", 0.3);
                            prefs.setDouble("LocationLattitude", 0.0);
                            prefs.setDouble("LocationLongitude", 0.0);
                            prefs.setBool("CheckIn", false);
                            prefs.setBool("ShouldDisplay", false);

                            BackgroundLocation.stopLocationService();

                            checkOutOpacity = 0.3;
                            checkinOp = 1;
                            shouldDisplay = false;

                            /// destination marker

                            checkTapcount = false;
                            prefs.setBool("CheckIn", false);

                            checkOutOpacity = 0.3;
                            prefs.setDouble("Opacity2", checkOutOpacity);
                            getValues();
                            onStop();

                            CheckOutSubmit(latlng, newDate);

                            //  removeData();
                            latlng = [];

                            if (pr.isShowing()) {
                              await pr.hide();
                            }
                            // showGoogleMapDialog(context);
                          }
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Image.asset(
                            'assets/Picture1.png',
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Check Out",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(247, 248, 250, checkOutOpacity),
                      //  borderRadius: BorderRadius.circular(30), //border corner radius
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), //color of shadow
                          spreadRadius: 5, //spread radius
                          blurRadius: 7, // blur radius
                          offset: Offset(0, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(260, 450, 10, 0),
                    height: 100,
                    width: 100,
                    child: InkWell(
                      focusColor: Colors.white,
                      highlightColor: Colors.white,
                      hoverColor: Colors.white,
                      overlayColor: MaterialStateProperty.all(Colors.white),
                      onTap: () {
                        if (checkTapcount == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addDistributor(
                                        id: id,
                                        email: email,
                                        name: name,
                                        status: checkTapcount,
                                        lanlat: currentPostion,
                                        zone: this.designation,
                                        desgination: this.designation,
                                      )));
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Image.asset(
                            'assets/images.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                          SizedBox(height: 10.0),
                          const Text(
                            'Distributor',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(247, 248, 250, checkOutOpacity),
                      //borderRadius: BorderRadius.circular(30), //border corner radius
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), //color of shadow

                          spreadRadius: 5, //spread radius
                          blurRadius: 7, // blur radius
                          offset: Offset(0, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                  ),
                ])),
                Container(
                  height: 380.0,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 120.0,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(55, 75, 167, 1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.fromLTRB(20, 100, 80, 40),
                                    height: 120,
                                    width: 120,
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: CircleAvatar(
                                          radius: 70,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 70,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                imageLogin == null
                                                    ? "https://scontent.flhe5-1.fna.fbcdn.net/v/t31.18172-8/18620768_1416977505022615_5165035795391275854_o.jpg?_nc_cat=106&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=_QAHLR2HecQAX-2PQzh&_nc_ht=scontent.flhe5-1.fna&oh=00_AT9OBOte3iMqXf79hbzW2LlQRWs2AIIzWkbVWcAOaFfIXg&oe=62BD65B0"
                                                    : imageLogin),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FutureBuilder(
                                      future: getValues(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        checkTapcount = this.checkTapcount;

                                        if (snapshot.hasData) {
                                          return Text(snapshot.data.toString());
                                        }

                                        return Text(
                                          "Name: \t" +
                                              this.name +
                                              "\nHR Code: " +
                                              this.email +
                                              "\nZone: " +
                                              this.zone +
                                              "\nDesignation: \n" +
                                              this.designation +
                                              "\n",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 17,
                                              fontFamily: 'Raleway'),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: FutureBuilder(
                                  future: getValues(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    checkTapcount = this.checkTapcount;

                                    if (snapshot.hasData) {
                                      return Text(snapshot.data.toString());
                                    }

                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                        ),
                                        Text(
                                          "Start Day: " +
                                              "\n" +
                                              _splitString(start_day) +
                                              "\n",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              fontFamily: 'Raleway'),
                                        ),
                                        Text(
                                          "End Day: " + "\n"

                                          +"\n" + _splitString(checkoutDate)
                                          ,

                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,

                                              fontSize: 16,
                                              fontFamily: 'Raleway'),
                                        ),
                                        Text(
                                          "____________ " + "\n",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              fontFamily: 'Raleway'),
                                        ),
                                        Text(
                                          "Check In: \n" +
                                              _splitString(newDate) +
                                              "\n",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              fontFamily: 'Raleway'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " Check Out: \n " +
                                              _splitString(checkoutDate),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // To take AppBar Size only
                  top: 35.0,
                  left: 10.0,
                  right: 20.0,
                  child: AppBar(
                    title: const Text(
                      'Al-Khair Gadoon',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.transparent
                        .withOpacity(0)
                        .withAlpha(0)
                        .withBlue(0),
                    elevation: 0,
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    primary: false,
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _getUserLocation();
    mapController = controller;
    _mapCreated = true;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) async {
    _getUserLocation();

    position = currentPostion;
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Color.fromRGBO(55, 75, 167, 1),
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    _getUserLocation();
    String xlocation =
        currentlattitude.toString() + "," + currentlongitude.toString();

    polylineCoordinates.clear();

    if (latlng.isNotEmpty) {
      // && checkTapcount == false) {
      latlng.forEach((LatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
    if (checkTapcount == false) {
      _addPolyLine();
    }
  }

  void dispose() {

    super.dispose();
  }

  Future<void> _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      currentlongitude = position.longitude;
      currentlattitude = position.latitude;
    });
  }
}
