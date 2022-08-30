import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:alkahir/assets/cities.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

import '../listview.dart';
import '../model/MapLocation.dart';
import '../model/profileUpdate.dart';
import 'global.dart';

class UserProfile extends StatefulWidget {
  final String id;
  final String name;

  final String email;
  const UserProfile({
    Key? key,
    required this.id, required this.email, required this.name,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String idNav = "";
  String emailNav = "";
  String nameNav = "";
  bool loginNav = false;
  String timeNav = "";
  String zoneNav = ""; String designationNav = "";
  late List<String> _cityitems;

  bool statusNav = false;
  ConnectivityResult? _connectivityResult;
  late ProgressDialog pr;



  bool validateMobile(String value) {
    String pattern = r'(^(?:[0-9]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return false;
    }
    else if (value.length==10) {
      return true;
    }
    return false;
  }


  profileUpdate profileRemarks = profileUpdate("address", "city", "contact_no") ;


  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<LatLng> latlngNav = [];
  Future<void>  getValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      statusNav = await preferences.getBool("CheckIn")!;
    }
    catch(e)
    {
      print(e);
    }
    emailNav = await preferences.getString("email")!;
    idNav = await preferences.getString("id")!;
    nameNav = await preferences.getString("name")!;
    loginNav = await preferences.getBool("isLogin")!;
    try {
      timeNav = await preferences.getString("time")!;
    }
    catch(e)
    {
      print(e);
    }

    zoneNav = await preferences.getString("zone")!;
    designationNav = await preferences.getString("designation")!;

  }


  Future<bool> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      return true;
    } else if (result == ConnectivityResult.mobile) {
      return true;
    }


    return false;


  }

Future<bool> getProfileData()
async {
var jsonResponse =null;

  var response = await http.get(
    Uri.parse(
        base_Url + "alkhair/public/api/v1/agent/agents/" +
            idNav),
  );

  print(response.body);

  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);

       profileRemarks = profileUpdate(
          jsonResponse['message']["address"].toString(),
          jsonResponse['message']["city"].toString(),
          jsonResponse['message']["contact_no"].toString()
      );










  }
  print(profileRemarks.address);

return true;




}


  Future<bool> updateProfile(
      String name, email, address, contact_no, city, id) async {
    var jsonResponse = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();

//    Map<String, String> headers = {"Content-Type": "application/json"};

    Map data = {
      'agn_code': id,
      'name': email,
      'email': email,
      'contact_no': contact_no,
      'address': address,
      'city': city
    };

    pr.show();
    var response = await http.post(
        Uri.parse(
            base_Url + "alkhair/public/api/v1/agent/agents/" +
                idNav),
        body: data);
print(response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse == null) {
        if (pr.isShowing() == true) {
          pr.hide();
        }

        print(jsonResponse);

        showAlertDialog(context, "Alert", "Update Profile Failed!");

        return false;
      }

      if (jsonResponse != null) {
        setState(() {
          if (pr.isShowing() == true) {
            pr.hide();
          }
        });
      }

      if (jsonResponse['error'] == false) {
        if (pr.isShowing() == true) {
          pr.hide();
        }

        showAlertDialog(context, "Alert", "Update Profile Successfull!");

        SharedPreferences preferences = await SharedPreferences.getInstance();

        return true;
      }

      print(jsonResponse);

      showAlertDialog(context, "Alert", "Update Profile Failed!");

      return false;
    }

    print(jsonResponse);

    showAlertDialog(context, "Alert", "Update Profile Failed!");

    return false;
  }

  ///================================== show alert =========================

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
        if (pr.isShowing()) {
          pr.hide();
        }
      },
    );

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

  ///================================== show alert =========================
  void initState() {



 

    setState(() {
      getValues();
      getProfileData();

      _checkConnectivityState();
    });
    List dataList = CitiesJson["data"]["list"];

    _cityitems = List.generate(
      dataList.length,
          (i) => "${dataList[i]["name"]}",
    );

  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //============================================= loading dialoge
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false);

    //Optional
    pr.style(
      padding: const EdgeInsets.all(16),
      message: 'Please wait...',
      borderRadius: 3.0,
      backgroundColor: Colors.white,
      progressWidget: const CircularProgressIndicator(
        strokeWidth: 3,
        backgroundColor:  Color.fromRGBO(55, 75, 167, 1),
      ),
      elevation: 2.0,
      insetAnimCurve: Curves.bounceIn,
      progressTextStyle: const TextStyle(
          color:   Color.fromRGBO(55, 75, 167, 1), fontSize: 2.0, fontWeight: FontWeight.w400),
      messageTextStyle: const TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.normal,
          color: Colors.grey),
    );
    //============================================= loading dialoge

    return FutureBuilder(
        future: Future.wait([getValues(),_checkConnectivityState(),getProfileData()]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          print(snapshot.data);

          return Scaffold(
              drawer: NavBar(
                status: statusNav,
                id: widget.id,
                email: emailNav,
                name: nameNav,
                latlng: latlngNav,
                zone:zoneNav,
                designation: designationNav,

              ),
              key: _scaffoldKey,
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                /*   physics: BouncingScrollPhysics(),*/

                child:Container(
                  height: 1000,
                  width: 1000,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppBar(
                        backgroundColor: Color.fromRGBO(55, 75, 167, 1),
                        leading: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                        ),
                        title: Text('Al-Khair Gadoon'),
                        actions: const <Widget>[],
                      ),
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding:
                              EdgeInsets.fromLTRB(50.0, 30.0, 0.0, 0.0),
                              child: Text('User Profile',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),

                      Container(
                          padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                          child: Column(
                            children: <Widget>[
                              Container(

                                child: Text("Agent CODE: " + widget.id,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal)),
                              ),
                              SizedBox(height: 20.0),
                              Container(

                                child: Text("HR CODE: " + widget.email,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal)),
                              ),
                              SizedBox(height: 20.0),
                              Container(

                                child: Text("Name: " + widget.name,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal)),
                              ),

                              SizedBox(height: 20.0),
                              TextField(

                                controller: _addressController,
                                decoration:  InputDecoration(
                                  hintText: profileRemarks.address,

                                    labelStyle: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                    icon: Icon(Icons.house),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                            Color.fromRGBO(55, 75, 167, 1)))),
                              ),
                              SizedBox(height: 20.0),

                              Container(
                                padding: const EdgeInsets.only(right: 0),
                                child: DropdownSearch<String>(
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  //   alignment: Alignment.centerLeft,
                                  // isDense: true,

                                  dropdownSearchDecoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(0.0),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.white),
                                      ),
                                      labelText: profileRemarks.city,

                                      labelStyle: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey),
                                      icon: Icon(Icons.location_city),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  55, 75, 167, 1)))),

                                  items: _cityitems,

                                  onChanged: (value) => setState(() {
                                    _cityController.text = value!;


                                  }),
                                ),
                              ),
                              /* TextField(
                              controller: _cityController,
                              decoration: const InputDecoration(
                                  labelText: 'City',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.location_city),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                            ),*/
                              SizedBox(height: 20.0),
                              TextField(

                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                maxLength: 10,
                                controller: _contactController,
                               inputFormatters: <TextInputFormatter>[

                                   FilteringTextInputFormatter.digitsOnly,
                                   new LengthLimitingTextInputFormatter(10),


                               ],
                                decoration:  InputDecoration(

                                    prefixText: '+92 ',

                                    hintText: profileRemarks.contact_no,
                                    labelStyle: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                    icon: Icon(Icons.phone_iphone),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                            Color.fromRGBO(55, 75, 167, 1)))),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 5.0),
                              SizedBox(height: 40.0),
                              Container(
                                height: 50.0,
                                width: 250,
                                child: Material(
                                  borderRadius: BorderRadius.circular(8.0),
                                  shadowColor: Colors.blueAccent,
                                  color: Color.fromRGBO(55, 75, 167, 1),
                                  elevation: 7.0,
                                  child: InkWell(
                                    onTap: () async {
print(_contactController.text);

                                      bool valueContactNumber = validateMobile(_contactController.text);
                                      print(valueContactNumber);


                                      if(valueContactNumber == true)

                                      {
                                            updateProfile(
                                        widget.name,
                                        widget.email,

                                        _addressController.text,
                                        _contactController.text,
                                        _cityController.text,
                                        widget.id,

                                      ).then((value) {
                                        setState(() {});
                                      });

                                      }
else
  {

    showAlertDialog(context, "Alert", "Number not Valid");

  }
                                    },
                                    child: const Center(
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Raleway'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          )),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ));
        });

    // TODO: implement build
    throw UnimplementedError();
  }
}
