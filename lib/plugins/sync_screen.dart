import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alkahir/model/distributor_list.dart';

import '../listview.dart';

import 'custom_dialog.dart';
import 'global.dart';




class SyncDistributor extends StatefulWidget {
  final String id;

  const SyncDistributor({Key? key, required this.id}) : super(key: key);

  @override
  _syncDistributorState createState() => _syncDistributorState();
}

class _syncDistributorState extends State<SyncDistributor> {
  late ProgressDialog pr;

  late List<Dist> finaldist;

  String idNav = "";
  String emailNav = "";
  String nameNav = "";
  bool loginNav = false;
  bool checkInternet = false;
  String timeNav = "";
  String zoneNav = "";
  String designationNav = "";

  bool statusNav = false;
  List<LatLng> latlngNav = [];
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  getValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    statusNav = await preferences.getBool("CheckIn")!;
    emailNav = await preferences.getString("email")!;
    idNav = await preferences.getString("id")!;
    nameNav = await preferences.getString("name")!;
    loginNav = await preferences.getBool("isLogin")!;
    timeNav = await preferences.getString("time")!;
    zoneNav = await preferences.getString("zone")!;
    designationNav = await preferences.getString("designation")!;
  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
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
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }


  Future<bool> submitDist() async {
    int k =0;
    initConnectivity();


if(finaldist.isNotEmpty && checkInternet == true)
{
  finaldist.forEach((element) async {

    var dataDist = element as Dist;

    var data = dataDist.toJson();
print(data);
    http.MultipartRequest request = http.MultipartRequest(
        "POST",
        Uri.parse(
            base_Url + "alkhair.rextech.pk/api/v1/agent/distributor"));

    Map<String, String> headers = {"Content-Type": "application/json"};


print(element.fileThree);


print(data);

print("heeeeello");
    request.files
        .add(await http.MultipartFile.fromBytes(
        'avatar[]', dataFromBase64String(element.fileOne),filename: "image"));
    request.files
        .add(await http.MultipartFile.fromBytes(
    'avatar[]', dataFromBase64String(element.fileTwo),filename: "image_2"));

    request.files
        .add(await http.MultipartFile.fromBytes(
    'avatar[]', dataFromBase64String(element.fileThree),filename: "image_3"));

    print(dataFromBase64String(element.fileThree));

    Map<String, String> d1 = {
      'distributor_type': element.distributor_type,
      'name': element.name,
      'shop_name': element.shop_name,
      'email': element.email,
      'cnic': element.cnic,
      'address': element.address,
      'city': element.city,
      'coordinates': element.coordinates.toString(),
      'added_by': element.added_by.toString(),
      'shop_size': element.shop_size,
      'floor': element.floor,
      'owned': element.owned,
      'covered_sale': element.covered_sale,
      'uncovered_sale': element.uncovered_sale,
      'total_sale': element.total_sale,
      'credit_limit': element.credit_limit == null ? "0" : element.credit_limit,
      'companies_working_with': element.companies_working_with == null ? "" : element.companies_working_with,
      'working_with_us': element.working_with_us == null ? "" : element.working_with_us,
      "our_brands": element.our_brands,
      'contact_no_1': element.contact_no_1,
      'contact_no_2': element.contact_no_2,
      'password': element.password,
      "password_confirmation": element.password_confirmation,
      'added_by': element.added_by
    };



    print(request.files.length);

    request.headers.addAll(headers);
    request.fields.addAll(d1);
    print(d1);
    //  pr.show();



    try {
    http.StreamedResponse response = await request.send();
    print(response);
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
    // success

      print(response.reasonPhrase);
      k++;
      print(k);
      print(respStr);
      showAlertDialog(context, "Alert", response.reasonPhrase.toString());



//prefs.remove("dist_key");



      final decodedMap = json.decode(respStr);

   // showAlertDialog(context, "Alert", decodedMap['message']);
    }


    }
    catch (e) {
    print(e);
    }


  });



  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("dist_key");




  return true;
}
showAlertDialog(context, "Alert", "Failed Sync No Internet!");
return false;
  }


  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String assertiveURL =
       base_Url + "alkhair/storage/app/public/images/distributors/";


  String _splitString(String value) {
    var arrayOfString = value.split(',');

    arrayOfString.first = assertiveURL + arrayOfString.first;

    return arrayOfString.first;
  }


  Future<List<Dist>> _getDist() async {
    List<Dist> distList = [];


    try {
      distList = await loadDataDistributor();
    }
    catch (e) {
      print(e);
    }




    finaldist = distList;


    if (pr.isShowing()) {
      pr.hide();
    }
    else {
      if (pr.isShowing()) {
        pr.hide();
      }
    }


    return distList;
  }

  Uint8List dataFromBase64String(String base64String) {
    try
    {
      return base64Decode(base64String);
    }
    catch(e)
    {
      return base64Decode("iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAIAAADTED8xAAADMElEQVR4nOzVwQnAIBQFQYXff81RUkQCOyDj1YOPnbXWPmeTRef+/3O/OyBjzh3CD95BfqICMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMO0TAAD//2Anhf4QtqobAAAAAElFTkSuQmCC");

    }

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

  @override
  Widget build(BuildContext context) {
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

    return FutureBuilder(
        future: getValues(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              drawer:
              NavBar(
                  status: statusNav,
                  id: widget.id,
                  email: emailNav,
                  name: nameNav,

                  latlng: latlngNav,
              zone:zoneNav,
                designation: designationNav,
              )
              ,


              key: _scaffoldKey,

              body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
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
                              title: Text('Al Khair'),
                              actions: const <Widget>[],
                            ),
                            Container(

                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    padding:
                                    EdgeInsets.fromLTRB(50.0, 30.0, 0.0, 0.0),
                                    child: Text('Distributor List to Sync',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            Container(

                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height +700,

                              child:Stack(children:<Widget>[


                                FutureBuilder(
                                future: _getDist(),
                                initialData: [],
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return new Center(
                                          child: new CircularProgressIndicator());

                                    default:
                                      if (snapshot.hasError) {
                                        ;
                                        print(snapshot.error);
                                        return Center(

                                            child: Text(''));
                                      } else {
                                        return snapshot.data == null
                                            ? SizedBox(
                                          height: 200,
                                        )
                                            : ListView.separated(
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                radius: 50,
                                                backgroundImage: MemoryImage(

                                                  dataFromBase64String(
                                                      snapshot.data[index]
                                                          .fileOne)   ,

                                                ),

                                              ),
                                              onTap: () {
    print( snapshot.data[index]
        .fileOne);

                                               // submitDist(snapshot.data[index]);
                                              },
                                              title: (Text(
                                                  snapshot.data[index].name)),
                                              subtitle: Column(children :<Widget>[Text(
                                                  snapshot.data[index].email
                                              )



                                              ]

                                              )



                                              ,


                                              selectedColor: Color.fromRGBO(
                                                  55, 75, 167, 1),
                                              selectedTileColor: Color.fromRGBO(
                                                  55, 75, 167, 1),
                                              selected: false,
                                              focusColor: Color.fromRGBO(
                                                  55, 75, 167, 1),
                                            );
                                          },

                                          separatorBuilder: (context, index) {
                                            return Divider();
                                          },
                                        );
                                      }
                                  }
                                },



                              ),
                                Container(
                                  height: 50.0,
                                  width: 250,
                                  margin: EdgeInsets.fromLTRB(70
                                      , 500, 10, 0),

                                  child: Material(
                                    borderRadius: BorderRadius.circular(8.0),
                                    shadowColor: Colors.blueAccent,
                                    color: Color.fromRGBO(55, 75, 167, 1),
                                    elevation: 7.0,
                                    child: InkWell(
                                      onTap: () async{

                                        submitDist();
                                        showAlertDialog(context, "Alert", "Data Sync");



                                      },
                                      child: const Center(
                                        child: Text(
                                          'SUBMIT SYNC DATA',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ]),

                            ),




                          ]))));
        }
    );
  }

}