import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../board.dart';
import '../listview.dart';

import '../model/checkout_model.dart';
import '../model/distributor_list.dart';
import 'global.dart';

class SyncCheckOut extends StatefulWidget {
  final String id;

  const SyncCheckOut({Key? key, required this.id}) : super(key: key);

  @override
  _syncCheckOutState createState() => _syncCheckOutState();
}

class _syncCheckOutState extends State<SyncCheckOut> {
  late ProgressDialog pr;
  bool valueForSync = false;
  String msgForSync = "";
  late List<CheckOut> finaldist = [];
  late List<Dist> finalcheck = [];

  String idNav = "";
  String emailNav = "";
  String nameNav = "";
  String zoneNav = "";
  String designationNav = "";

  bool loginNav = false;
  String timeNav = "";
  bool checkInternet = false;
  bool statusNav = false;
  List<LatLng> latlngNav = [];
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  getValues() async {
//

    SharedPreferences preferences = await SharedPreferences.getInstance();


    try{statusNav = await preferences.getBool("CheckIn")!;}catch(e)  {print(e);}
    try{emailNav = await preferences.getString("email")!;}catch(e)  {print(e);}
    try{idNav = await preferences.getString("id")!;}catch(e)  {print(e);}
    try{nameNav = await preferences.getString("name")!;}catch(e)  {print(e);}
    try{loginNav = await preferences.getBool("isLogin")!;}catch(e)  {print(e);}
    try{timeNav = await preferences.getString("time")!;}catch(e)  {print(e);}
    try{zoneNav = await preferences.getString("zone")!;}catch(e)  {print(e);}
    try{designationNav = await preferences.getString("designation")!;   }catch(e)  {print(e);}
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

  void initState() {
    initConnectivity();
    ;
  }

  Future<bool> submitCheckOut() async {
    await initConnectivity();
    if (finaldist.isNotEmpty && checkInternet == true) {
      finaldist.forEach((element) async {
        var dataCheckOut = element as CheckOut;

        var data = dataCheckOut.toJson();


        Map<String, String> d1 = {
          'agn_code': element.agn_code,
          // "start_coordinates": element.start_coordinates,
          //     'date': element.date,
          'started_at': element.started_at,
          'distance': element.distance,
          //   'remarks': element.remarks,
          'ended_at': element.ended_at,
          //   'end_coordinates': element.end_coordinates,
          'coor': element.end_coordinates
        };



        try {
          var response = await http.post(
              Uri.parse(base_Url + "api/v1/agent/trips"),
              body: d1);

          print(response.statusCode);

          if (response.statusCode == 200) {}
        } catch (e) {}
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      initConnectivity();
      if (checkInternet == true) {
        prefs.remove("dist_key_checkout");
      } else if (checkInternet == false) {
        showAlertDialog(context, "Alert", "Failed to Sync:No connectivity");
      } else {
        showAlertDialog(context, "Alert", "Sync Failed!");
      }

      showAlertDialog(context, "Alert", "Data Sync");
      if (pr.isShowing()) {
        pr.hide();
      }

      return true;
    } else {
      showAlertDialog(context, "Alert", "Failed Sync No Internet!");
    }

    return false;
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<List<CheckOut>> _getCheckOut() async {
    List<CheckOut> checkoutList = [];

    try {
      checkoutList = await loadDataCheckOut();
    } catch (e) {}
    finaldist = checkoutList;

    if (pr.isShowing()) {
      pr.hide();
    } else {
      if (pr.isShowing()) {
        pr.hide();
      }
    }

    return checkoutList;
  }

  Uint8List dataFromBase64String(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      return base64Decode(
          "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAIAAADTED8xAAADMElEQVR4nOzVwQnAIBQFQYXff81RUkQCOyDj1YOPnbXWPmeTRef+/3O/OyBjzh3CD95BfqICMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMO0TAAD//2Anhf4QtqobAAAAAElFTkSuQmCC");
    }
  }

  Future<bool> submitDist() async {
    int k = 0;
    initConnectivity();

    if (finalcheck.isNotEmpty) {
      print(finalcheck);

      var i=0;
      for (var element in finalcheck) {
i=i+1;



        var dataDist = element as Dist;

        var data = dataDist.toJson();

        http.MultipartRequest request = http.MultipartRequest("POST",
            Uri.parse(base_Url + "api/v1/agent/distributor"));

        Map<String, String> headers = {"Content-Type": "multipart/form-data"};

        request.files.add(await http.MultipartFile.fromBytes(
            'avatar[]', dataFromBase64String(element.fileOne),
            filename: "image"+i.toString()));
        request.files.add(await http.MultipartFile.fromBytes(
            'avatar[]', dataFromBase64String(element.fileTwo),
            filename: "image_2"+i.toString()));

        request.files.add(await http.MultipartFile.fromBytes(
            'avatar[]', dataFromBase64String(element.fileThree),
            filename: "image_3"+i.toString()));
        element.working_with_us == null ? "" : element.working_with_us;

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
          'width': element.width,
          'depth': element.depth,
          'floor': element.floor,
          'owned': element.owned,
          'covered_sale': element.covered_sale,
          'uncovered_sale': element.uncovered_sale,
          'total_sale': element.total_sale,
          'credit_limit':
              element.credit_limit == null ? "0" : element.credit_limit,
          'companies_working_with': element.companies_working_with == null
              ? ""
              : element.companies_working_with,
          'working_with_us': element.working_with_us ?? "",
          "our_brands": element.our_brands,
          'contact_no_1': element.contact_no_1,
          'contact_no_2': element.contact_no_2,
          'password': element.password,
          "password_confirmation": element.password_confirmation,
          'added_by': element.added_by,
        };

        request.headers.addAll(headers);
        request.fields.addAll(d1);

        //  pr.show();



        try {
          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {

            var responseData = await response.stream.toBytes();
            var responseToString = String.fromCharCodes(responseData);
            var jsonBody = jsonDecode(responseToString);
            setState(() {
              print(jsonBody);
            });

            // success
            print("success");

            final respStr = await response.stream.bytesToString();


            k++;

            //   showAlertDialog(context, "Alert", response.reasonPhrase.toString());

            final decodedMap = json.decode(respStr);

            valueForSync = decodedMap["error"] == "true" ? true : false;
            msgForSync = decodedMap['message'];

          }
        } catch (e) {}

      }
      if (pr.isShowing()) {
        pr.hide();
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      initConnectivity();


      if (checkInternet == true) {
        if (valueForSync == false) {
          prefs.remove("dist_key");
          if (msgForSync == "") {
            msgForSync = "Data Sync";
          }
          showAlertDialog(context, "Alert", msgForSync);
        } else {
          if (msgForSync == "") {
            msgForSync = "Data Sync";
          }

          showAlertDialog(context, "Alert", msgForSync);
        }
      } else if (checkInternet == false) {
        showAlertDialog(context, "Alert", "Failed to Sync:No connectivity");
      } else {
        showAlertDialog(context, "Alert", "Sync Failed!");
      }

      if (pr.isShowing()) {
        pr.hide();
      }

      return true;
    }

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
        try {
          if (Navigator.canPop(context) == true) {
            Navigator.pop(context);
          }

          if (pr.isShowing()) {
            pr.hide();
          }
        } catch (e) {
          "";
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
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ///================================== show alert =========================
  ///======================== dist list==========================

  String assertiveURL =
      "http://alkhair.rextech.pk/alkhair/storage/app/public/images/distributors/";

  String _splitString(String value) {
    var arrayOfString = value.split(',');

    arrayOfString.first = assertiveURL + arrayOfString.first;

    return arrayOfString.first;
  }

  Future<List<Dist>> _getDist() async {
    List<Dist> distList = [];

    try {
      distList = await loadDataDistributor();
    } catch (e) {}

    finalcheck = distList;

    if (pr.isShowing()) {
      pr.hide();
    } else {
      if (pr.isShowing()) {
        pr.hide();
      }
    }

    return distList;
  }

  ///======================== dist list==========================
  ///
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true);

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

    pr.update(
      progress: 50.0,
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return FutureBuilder(
        future: getValues(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              drawer: NavBar(
                status: statusNav,
                id: widget.id,
                email: emailNav,
                name: nameNav,
                latlng: latlngNav,
                zone: zoneNav,
                designation: designationNav,
              ),
              key: _scaffoldKey,
              body:

              SingleChildScrollView(


             child:    Column(
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
                              title: Text('Al-Khair Gadoon Ltd.'),
                              actions: const <Widget>[],
                            ),
                            Container(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        50.0, 30.0, 0.0, 0.0),
                                    child: Text('List to Sync',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height:20),

                            Stack(children: <Widget>[

          FutureBuilder(
                                future: _getCheckOut(),
                                initialData: [],
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator());

                                    default:
                                      if (snapshot.hasError) {
                                        ;

                                        return Center(child: Text(''));
                                      } else {
                                        return snapshot.data == null
                                            ? SizedBox(
                                                height: 200,
                                              )
                                            : ListView.separated(
                                          physics:NeverScrollableScrollPhysics(),

                                                shrinkWrap:
                                                    true, //just set this property
                                                padding:
                                                    const EdgeInsets.all(8.0),


                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index ==
                                                      snapshot.data!.length) {
                                                    return SizedBox(
                                                      height: 50.0,
                                                      width: 200,
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        shadowColor:
                                                            Colors.blueAccent,
                                                        color: Color.fromRGBO(
                                                            55, 75, 167, 1),
                                                        elevation: 7.0,
                                                        child: InkWell(
                                                          onTap: () async {

                                                            if (finaldist
                                                                    .isEmpty &&
                                                                finalcheck
                                                                    .isEmpty) {
                                                            } else {

                                                              submitDist();

                                                              submitCheckOut();

                                                              Navigator.push(
                                                                  context, MaterialPageRoute(builder: (context) => BoardView()));




                                                            }
                                                          },
                                                          child: const Center(
                                                            child: Text(
                                                              'SUBMIT SYNC DATA NEW',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontFamily:
                                                                      'Raleway'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  return ListTile(
                                                    onTap: () {
                                                      // submitDist(snapshot.data[index]);
                                                    },
                                                    title: (Center(
                                                      child: Text(
                                                        snapshot
                                                            .data[index].date,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey),
                                                      ),
                                                    )),
                                                    subtitle: Column(
                                                        children: <Widget>[
                                                          Text("Start Time: " +
                                                              snapshot
                                                                  .data[index]
                                                                  .started_at),
                                                          Text("End Time: " +
                                                              snapshot
                                                                  .data[index]
                                                                  .ended_at),
                                                        ]),
                                                    selectedColor:
                                                        Color.fromRGBO(
                                                            55, 75, 167, 1),
                                                    selectedTileColor:
                                                        Color.fromRGBO(
                                                            55, 75, 167, 1),
                                                    selected: false,
                                                    focusColor: Color.fromRGBO(
                                                        55, 75, 167, 1),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return Divider(
                                                    thickness: 2,
                                                  );
                                                },
                                              );
                                      }
                                  }
                                },
                              ),
                            ]),
                            Container(

                              child: Stack(children: <Widget>[
                                FutureBuilder(
                                  future: _getDist(),
                                  initialData: [],
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:

                                      default:
                                        if (snapshot.hasError) {
                                          ;

                                          return Center(child: Text(''));
                                        } else {
                                          return snapshot.data == null
                                              ? SizedBox(
                                                  height: 200,
                                                )
                                              : ListView.separated(
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      snapshot.data!.length + 1,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    if (index ==
                                                        snapshot.data!.length) {
                                                      return Container(
                                                        height: 50.0,
                                                        width: 50,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          shadowColor:
                                                              Colors.blueAccent,
                                                          color: Color.fromRGBO(
                                                              55, 75, 167, 1),
                                                          elevation: 7.0,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              await pr.show();

                                                              if (finaldist
                                                                      .isEmpty &&
                                                                  finalcheck
                                                                      .isEmpty) {
                                                              } else {

                                                                submitDist();

                                                                submitCheckOut();
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => BoardView()));



                                                              }
                                                              try {
                                                                //  showAlertDialog(context,"Alert", "Successfully Synced");
                                                                //showAlertDialog(context, "Alert", "Data Sync");
                                                              } catch (e) {}
                                                              if (pr
                                                                  .isShowing()) {
                                                                Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            10),
                                                                    () {});

                                                                await pr.hide();
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => BoardView()));

                                                              }
                                                            },
                                                            child: const Center(
                                                              child: InkWell(
                                                                child: Text(
                                                                  'SUBMIT SYNC DATA',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontFamily:
                                                                          'Raleway'),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return ListTile(
                                                      leading: CircleAvatar(
                                                        radius: 50,
                                                        backgroundImage:
                                                            MemoryImage(
                                                          dataFromBase64String(
                                                              snapshot
                                                                  .data[index]
                                                                  .fileOne),
                                                        ),
                                                      ),
                                                      onTap: () {},
                                                      title: (Text(snapshot
                                                          .data[index].name)),
                                                      subtitle: Column(
                                                          children: <Widget>[
                                                            Text(snapshot
                                                                .data[index]
                                                                .email)
                                                          ]),
                                                      selectedColor:
                                                          Color.fromRGBO(
                                                              55, 75, 167, 1),
                                                      selectedTileColor:
                                                          Color.fromRGBO(
                                                              55, 75, 167, 1),
                                                      selected: false,
                                                      focusColor:
                                                          Color.fromRGBO(
                                                              55, 75, 167, 1),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return Divider(
                                                      thickness: 2,
                                                    );
                                                  },
                                                );
                                        }
                                    }
                                  },
                                ),
                                Divider(
                                  thickness: 4,
                                ),
                              ]),
                            ),
                          ])));
        });
  }
}
