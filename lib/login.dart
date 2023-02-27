import 'package:alkahir/plugins/dialog_list.dart';
import 'package:alkahir/plugins/global.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'plugins/constglobal.dart';
import 'model/login_model.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

///================================== login api ///


class _LoginScreenState extends State<LoginPage> {


  bool saveAdress = false;
  bool _passwordVisible = true;
  final TextEditingController _userEmailController = TextEditingController();

  final TextEditingController _userPasswordController = TextEditingController();
  late ProgressDialog pr;
  LoginRequestModel newRequestModel = LoginRequestModel();
bool permissionGranted =false;



  Future<void> _getUserLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble("LocationLattitude", position.latitude);
    prefs.setDouble("LocationLongitude", position.longitude);
  }


  Future<bool> signIn(String email, pass) async {




    _getUserLocation();
    var jsonResponse = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();


    Map data = {'email': email, 'password': pass};

    pr.show();








    var response = await http.post(
        Uri.parse(
            base_Url + "api/v1/agent/login"),
        body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse == null) {
        if (pr.isShowing() == true) {
          pr.hide();
        }
        prefs.setBool("isLogin", false);

        showAlertDialog(context, "Alert", "Login Failed!");

        return false;
      }

      if (jsonResponse != null) {
        prefs.setBool("isLogin", true);

        setState(() {
          if (pr.isShowing() == true) {
            pr.hide();
          }
        });
      }


      if (jsonResponse['error'] == false ) {
        if (pr.isShowing() == true) {
          pr.hide();
        }
        prefs.setBool("isLogin", true);





        newRequestModel = LoginRequestModel.fromJson(
          jsonResponse['data'],
        );
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt("login", 1);
        preferences.setString("name", newRequestModel.name);
        preferences.setString("email", newRequestModel.hr_code);
        preferences.setString("id", newRequestModel.id);
        preferences.setString("designation", newRequestModel.designation);
        preferences.setString("zone", newRequestModel.zone);
        preferences.setString("hr_code", newRequestModel.hr_code);
        preferences.setString("avatar", newRequestModel.avatar);


      showAlertDialog(context, "Alert", "Login Successfull!");









        return true;
      }
      prefs.setBool("isLogin", false);

      showAlertDialog(context, "Alert", "Login Failed!");

      return false;
    }
    prefs.setBool("isLogin", false);
    showAlertDialog(context, "Alert", "Login Failed!");

    return false;
  }

/*================================== login api */


  Future<bool> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      while (Navigator.canPop(context) == true) {Navigator.pop(context);}




      return false;
    }


    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        while (Navigator.canPop(context) == true) {Navigator.pop(context);}

        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));


        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {


      return false;
    }



    return true;
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    }
  }

  @override
  void initState() {


    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false);


    //============================================= loading dialoge
    initPr(context);



    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 70.0),
                        SizedBox(height: 40.0),
                        Container(
                          alignment: Alignment.center,
                          child: Container(
                            child: Image.asset('assets/splash.png'),
                            height: 150.0,
                            width: 150,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _userEmailController,
                        decoration: const InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(55, 75, 167, 1)))),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _userPasswordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            labelStyle: const TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(55, 75, 167, 1)))),
                      ),
                      SizedBox(height: 5.0),
                      SizedBox(height: 40.0),
                      SizedBox(
                        height: 50.0,
                        width: 250,
                        child: Material(

                          borderRadius: BorderRadius.circular(8.0),
                          shadowColor: Colors.blueAccent,
                          color: Color.fromRGBO(55, 75, 167, 1),
                          elevation: 7.0,

                          child: InkWell(

                            onTap: () async{
                              print(_determinePosition());

                              await _getStoragePermission();


                              if(await _determinePosition()== true && permissionGranted == true ) {






                                signIn(_userEmailController.text,
                                    _userPasswordController.text)
                                    .then((value) {
                                  setState(() {
                                    saveAdress = value;
                                  });
                                });
                              }
                              else if(await _determinePosition()== false)
                                {




                                  showAlertDialog(this.context, "Alert", "Please Allow Location Permission");


                                }
                            },
                            child: const Center(
                              child: Text(
                                'LOGIN',
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
        ));
  }
}
