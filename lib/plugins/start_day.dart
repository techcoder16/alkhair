import 'dart:async';
import 'dart:convert';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'global.dart';

ConnectivityResult _connectionStatus = ConnectivityResult.none;
final Connectivity _connectivity = Connectivity();
late StreamSubscription<ConnectivityResult> _connectivitySubscription;

bool checkInternet =false;

///  ===================== internet check ===================================

Future<void> _updateConnectionStatus(ConnectivityResult result) async {

    _connectionStatus = result;

}

Future<void> initConnectivity() async {
  late ConnectivityResult result;

  try {
    result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.mobile) {
      checkInternet = true;
    } else if (result == ConnectivityResult.wifi) {
      checkInternet = true;
    } else {
      checkInternet = false;
    }
  } on PlatformException catch (e) {
    return;
  }


  return _updateConnectionStatus(result);
}

///  ===================== internet check ===================================

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
      onPressed: () {

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



Future<void> startDay(String id,BuildContext context) async {



  var now = DateTime.now();
  var jsonResponse = null;
 var  formatter = DateFormat('yyyy-MM-dd');
  var formattedDate = DateFormat.Hms().format(now);


 var newDate = formatter.format(now).toString() +
      " " +
      formattedDate.toString();


  Map data = {'agn_code': id, 'started_at': newDate};



  var response = await http.post(
      Uri.parse(
          base_Url + "api/v1/agent/dayIn"),
      body: data);

  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {

 // showAlertDialog(context, "Alert", "Day is started");
  SharedPreferences prefs = await SharedPreferences.getInstance();


print(jsonResponse['data']['attendance_id']);


  prefs.setString("attendanceID",  jsonResponse['data']['attendance_id'].toString());




    }
  }


}

CustomdialogStartDay(BuildContext context,String id)
{




  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    child: dialogContent(context,id),


  );

}

Widget dialogContent(BuildContext context,String id) {



  return Container(
    margin: EdgeInsets.only(left: 0.0,right: 0.0),
    child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 18.0,
          ),
          margin: EdgeInsets.only(top: 13.0,right: 8.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(55, 75, 167, 1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                ),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(

                      "Please Start your Day"
                        , style:TextStyle(fontSize: 20.0,color: Colors.white

                          ,   fontFamily: 'Raleway',
                          fontWeight: FontWeight.normal,
                        )),


                  )//
              ),



              SizedBox(height: 24.0),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                  decoration: BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0)),
                  ),
                  child:  Text(
                    "Start Day",
                    style: TextStyle(color: Colors.blue,fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap:(){


startDay(id,context);
                  Navigator.pop(context);
                },
              )

            ],
          ),
        ),

      ],
    ),
  );
}


