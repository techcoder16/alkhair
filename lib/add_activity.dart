import 'dart:convert';

import 'package:alkahir/plugins/global.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'board.dart';
import 'listview.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'model/remarks_model.dart';

class AddActivity extends StatefulWidget {
  final String id;

  const AddActivity({Key? key, required this.id}) : super(key: key);

  @override
  _AddActivityState createState() => _AddActivityState();
}

class ListDist {
  final String dist;
  final String code;

  ListDist({
    required this.dist,
    required this.code,
  });
}

class _AddActivityState extends State<AddActivity> {
  final TextEditingController _distController = TextEditingController();
  late List<String> newDist = [];
  late List<String> newDistCode = [];
  late List<String> newRemarksOn = [];

  late List<String> newRemarksId = [];

  List<String> listDist = [];
  List<String> listDistCode = [];
  late ProgressDialog pr;
  String idNav = "";
  String emailNav = "";
  String nameNav = "";
  String zoneNav = "";
  String designationNav = "";
  late String selectDateInString;
  late DateTime selectedDate = DateTime.now();
  String initValue = "Select your Date";
  bool isDateSelected = false;

  bool loginNav = false;
  String timeNav = "";
  bool checkInternet = false;
  bool statusNav = false;
  List<LatLng> latlngNav = [];
  String _errorMessage = '';
  List<String> selectedNew = [];
  static List<ListDist> _items = [];
  bool valueDate = false;
  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);
  List<TimeOfDay> _timeController = [];
  //TimeOfDay.now().replacing(hour: 11, minute: 30);

  bool iosStyle = true;

  void onTimeChanged(TimeOfDay newTime, int index) {
    setState(() {
      _timeController[index] = newTime;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _fieldValidator = true;
  final TextEditingController _userDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final List<TextEditingController> _valueController = [];
  final List<TextEditingController> _valueTimeController = [];

  void validateField(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Field can not be empty";
        _fieldValidator = false;
      });
    } else {
      setState(() {
        _errorMessage = "";
        _fieldValidator = true;
      });
    }
  }

  Future<void> getDropDownCustomer() async {
    listDist = listDist.toSet().toList();

    listDistCode = listDistCode.toSet().toList();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      idNav = await preferences.getString("id")!;
      listDist = [];
      listDistCode = [];
      var jsonResponse = null;

      var response = await http.get(
        Uri.parse(
            base_Url + "alkhair/public/api/v1/agent/getdistributors/" + idNav),
      );

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        jsonResponse['data'].forEach((item) {
          listDist.add(item['name']);
          listDistCode.add(item['dst_code']);
        });

        listDist = listDist.toSet().toList();

        listDistCode = listDistCode.toSet().toList();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<RemarksModel>> getCustomerRemarks(
      date, List<String> distCodes) async {
    List<RemarksModel> remarksList = [];

    Map data = {"date": date, "agn_code": idNav, "dst_code": distCodes};
    var jsonResponse;

    var response;
    try {
      response = await http.post(
          Uri.parse(
              "http://alkhair.hameedsweets.com/alkhair/public/api/v1/agent/check-remark"),
          headers: {'Content-type': 'application/json'},
          body: json.encode(data));
    } catch (e) {
      print(e);
    }

    var jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      try {
        newRemarksOn = [];
        _valueController.clear();
        _timeController.clear();
        _valueTimeController.clear();

        newRemarksId = [];
        for (var viewRemarksIterator in jsonData['message']) {
          RemarksModel agentRemarks = RemarksModel(
            viewRemarksIterator["dst_code"].toString(),
            viewRemarksIterator["distributor_name"].toString(),
            viewRemarksIterator["time"].toString(),
            viewRemarksIterator["remarks_on"].toString(),
            viewRemarksIterator["remark_id"].toString(),
            viewRemarksIterator["remarks"].toString(),






          );

          remarksList.add(agentRemarks);

          newRemarksOn.add(agentRemarks.remarks_on.toString());

          newRemarksId.add(agentRemarks.remark_id.toString());


          _valueController.add(
              TextEditingController(text: agentRemarks.remarks.toString()));
          TimeOfDay _startTime = TimeOfDay(hour:int.parse(agentRemarks.time.split(":")[0]),minute: int.parse(agentRemarks.time.split(":")[1]));


          _timeController.add(_startTime);


          _valueTimeController.add(TextEditingController(text: ""));
        }
      } catch (e) {
        print(e);
      }
      if (valueDate == false) {
        remarksList = [];
        return remarksList;
      }
      return remarksList;
    } else {
      return remarksList;
    }
  }

  Future<bool> checkAttendance(String id, date) async {
    Map data = {
      "agn_code": idNav,
      "date": date,
    };
    var jsonResponse = null;

    var response = await http.post(
        Uri.parse(base_Url + "alkhair/public/api/v1/agent/check-attendance"),
        body: data);

    String value = "";
    if (response.statusCode == 200) {
      try {
        jsonResponse = json.decode(response.body);
        value = jsonResponse['message'].toString();
      } catch (e) {
        print(e);
      }
    }
    if (value == "true") {
      valueDate = true;

      return true;
    }
    return false;
  }

  Future<void> getValues() async {
//
    listDist = listDist.toSet().toList();

    listDistCode = listDistCode.toSet().toList();

    SharedPreferences preferences = await SharedPreferences.getInstance();

    idNav = await preferences.getString("id")!;
try {statusNav = await preferences.getBool("CheckIn")!;} catch(e) {}

try {emailNav = await preferences.getString("email")!;                }catch(e){}
try {idNav = await preferences.getString("id")!;      }catch(e){}
try {nameNav = await preferences.getString("name")!;      }catch(e){}
try {loginNav = await preferences.getBool("isLogin")!;      }catch(e){}
try {timeNav = await preferences.getString("time")!;      }catch(e){}
try {zoneNav = await preferences.getString("zone")!;      }catch(e){}
try {designationNav = preferences.getString("designation")!;      }catch(e){}

  }


  Future<bool>   deleteRemarks(remarksId,agnCode)
 async {

   var jsonResponse = null;

    Map data = {
      "agn_code":agnCode ,
      "remark_id":remarksId
    };


    pr.show();
    var response = await http.post(
        Uri.parse(

            base_Url + "alkhair/public/api/v1/agent/daily-remarks/destroy"),
        headers: { 'Content-type': 'application/json',
          'Accept': 'application/json'},
        body: json.encode(data));






    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse == null) {
        if (pr.isShowing() == true) {
          pr.hide();
        }



        showAlertDialog(context, "Alert", "Delete Activity Failed!");

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

        showAlertDialog(context, "Alert", "Delete Remarks Successfull!");


        return true;
      }

      showAlertDialog(context, "Alert", jsonResponse["message"]);

      return false;
    }

    showAlertDialog(context, "Alert", "Delete Remarks Failed!");

    return false;



  }


  Future<bool> AddActivityNew(
      String id,
      dst_code,
      remarks,
      name,
      List<String> newRemarksOn,
      List<TextEditingController> valueController,
      List<TimeOfDay> timeController) async {
    var jsonResponse = null;
    List<String> timeNew = [];

    timeController.forEach((element) {
      timeNew.add(element.format(context));
    });

    var timeNow = DateTime.now();
    newRemarksOn.toSet().toList();

    newRemarksId.toSet().toList();

    final String formattedString = timeNow.toString();
    List<String> remarks = [];
    valueController.forEach((element) {
      remarks.add(element.text);
    });
    remarks.toSet().toList();

    Map data = {
      "device_time": formattedString,
      "remarks_on": newRemarksOn,
      "agn_code": idNav,
      "dst_code": dst_code,
      "remarks": remarks,
      "time": timeNew,
    };

//return false;

    pr.show();
    var response = await http.post(
        Uri.parse(

            "http://alkhair.hameedsweets.com/alkhair/public/api/v1/agent/daily-remarks-activity"),
        headers: { 'Content-type': 'application/json',
          'Accept': 'application/json'},
        body: json.encode(data));


    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse == null) {
        if (pr.isShowing() == true) {
          pr.hide();
        }

        showAlertDialog(context, "Alert", "Adding Activity Failed!");

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

        showAlertDialog(context, "Alert", "Adding Activity Successfull!");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BoardView()));

        return true;
      }

      showAlertDialog(context, "Alert", "Adding Activity Failed!");

      return false;
    }

    showAlertDialog(context, "Alert", "Adding Activity Failed!");

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
  ///
  @override
  void initState() {
    listDist = listDist.toSet().toList();

    listDistCode = listDistCode.toSet().toList();

    setState(() {
      getValues();
    });
    getDropDownCustomer();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
setState(() {

  listDist = listDist.toSet().toList();

  listDistCode = listDistCode.toSet().toList();
});


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
    //============================================= loading dialoge

    return FutureBuilder(
        future: Future.wait([getValues()]),
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
              body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
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
                              child: Text('Add Activity',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60.0),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: GestureDetector(
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                  onTap: () async {
                                    final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));

                                    if (datePick != null &&
                                        datePick != selectedDate) {
                                      setState(() {
                                        selectedDate = datePick;
                                        isDateSelected = true;

                                        selectDateInString =
                                            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"; // 08/14/2019
                                        _userDateController.text =
                                            selectDateInString;
                                      });
                                    }
                                    await checkAttendance(
                                        widget.id, _userDateController.text);
                                  }),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextField(
                                maxLength: 1,
                                readOnly: true,
                                enabled: false,
                                controller: _userDateController,
                                decoration: const InputDecoration(
                                    labelText: 'Date',
                                    counterText: '',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                223, 28, 0, 1)))),
                                onTap: () async {
                                  await checkAttendance(
                                      widget.id, _userDateController.text);
                                },
                                onChanged: (value) async {
                                  validateField(value);
                                  await checkAttendance(
                                      widget.id, _userDateController.text);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                        child: DropdownSearch<String>.multiSelection(
                          mode: Mode.DIALOG,
                          showSearchBox: true,
                          //   alignment: Alignment.centerLeft,
                          // isDense: true,a

                          dropdownSearchDecoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Customer *',
                              labelStyle: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                              icon: Icon(Icons.location_city),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(55, 75, 167, 1)))),

                          items: listDist,


                          onChanged: (value) => setState(() {
                            newDist = [];
                            newDistCode = [];
                            value.forEach((element) {
                              newDist.add(element);
                              newDistCode
                                  .add(listDistCode[listDist.indexOf(element)]);
                            });

                            newDist.toSet().toList();
                            newDistCode.toSet().toList();

                            getCustomerRemarks(
                                _userDateController.text, newDistCode);
                          }),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FutureBuilder(
                          future: getCustomerRemarks(
                              _userDateController.text, newDistCode),
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
                                  return Center(child: Text(''));
                                } else {
                                  return snapshot.data == null
                                      ? SizedBox(
                                          height: 200,
                                        )
                                      : ListView.builder(
                                          itemExtent: 240.0,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                                horizontalTitleGap: 0.0,
                                                dense: false,
                                                title: Table(
                                                    border:
                                                        TableBorder.symmetric(
                                                            inside:
                                                                BorderSide.none,
                                                            outside: BorderSide(
                                                                width: 1)),
                                                    defaultColumnWidth:
                                                        FixedColumnWidth(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.15),
                                                    children: [
                                                      TableRow(children: [
                                                        Container(
                                                          color: Color.fromRGBO(
                                                              106, 136, 171, 1),
                                                          height: 50,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Text('Name',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      backgroundColor: Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                    )),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Color.fromRGBO(
                                                              106, 136, 171, 1),
                                                          height: 50,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Text('Time',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      backgroundColor: Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                    )),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Color.fromRGBO(
                                                              106, 136, 171, 1),
                                                          height: 50,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Text('Remarks',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      backgroundColor: Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                    )),
                                                              ]),
                                                        ),

                                                      ]),
                                                      TableRow(children: [
                                                        Container(
                                                          height: 130,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .distributor_name
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                    )),
                                                              ]),
                                                        ),
                                                        Container(
                                                          height: 130,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                TextField(
                                                                    controller:
                                                                        _valueTimeController[
                                                                            index],

                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      focusedBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      enabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      errorBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      disabledBorder:
                                                                          InputBorder
                                                                              .none,

                                                                          labelText:  _timeController[
                                                                          index]

                                                                              .format(
                                                                              context)
                                                                    ),
                                                                    //
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                    )),
                                                                TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    shadowColor:
                                                                        Colors
                                                                            .blueAccent,
                                                                    backgroundColor:
                                                                        Color.fromRGBO(
                                                                            55,
                                                                            75,
                                                                            167,
                                                                            1),
                                                                    elevation:
                                                                        4.0,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      showPicker(
                                                                        context:
                                                                            context,
                                                                        value: _timeController[
                                                                            index],
                                                                        onChange:
                                                                            (TimeOfDay
                                                                                newDay) {
                                                                          _timeController[index] =
                                                                              newDay;
                                                                          _timeController[index] =
                                                                              newDay;

                                                                          _valueTimeController[index].text =
                                                                              _timeController[index].format(context);
                                                                        },
                                                                        disableMinute:
                                                                            false,

                                                                        minuteInterval:
                                                                            MinuteInterval.ONE,
                                                                        // Optional onChange to receive value as DateTime
                                                                        onChangeDateTime:
                                                                            (DateTime
                                                                                dateTime) {
                                                                          // print(dateTime);

                                                                          _valueTimeController[index].text =
                                                                              _timeController[index].format(context);

                                                                          debugPrint(
                                                                              "[debug datetime]:  $dateTime");
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    "Time Picker",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          height: 130,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                TextField(
                                                                    enabled:
                                                                        true,
                                                                    maxLines: 5,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    controller:
                                                                        _valueController[
                                                                            index],
                                                                    decoration: InputDecoration(
                                                                        hintText: snapshot
                                                                            .data[
                                                                                index]
                                                                            .remarks,
                                                                        labelStyle: TextStyle(
                                                                            fontFamily:
                                                                                'Raleway',
                                                                            fontWeight: FontWeight
                                                                                .normal,
                                                                            color: Colors
                                                                                .grey),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(55, 75, 167, 1)))),
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                    )),


                                                              ]),

                                                        ),


                                                      ]),
                                                    ])

                                            ,

                                            subtitle:
                                                    Container(

                                           decoration:  BoxDecoration(
                                            border: Border.all(),
                                            ),
                                          child:

                                                      IconButton(
                                                          icon: Icon(Icons.delete),
                                                          color: Colors.grey,
                                                          onPressed:(){

                                                            deleteRemarks(newRemarksId[index],idNav);


                                                          }
                                                      ),




                                                    ),

                                            );
                                          });
                                }
                            }
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 50, right: 0),
                        height: 50.0,
                        width: 350,
                        child: Material(
                          borderRadius: BorderRadius.circular(8.0),
                          shadowColor: Colors.blueAccent,
                          color: Color.fromRGBO(55, 75, 167, 1),
                          elevation: 7.0,
                          child: InkWell(
                            onTap: () async {
                              if (valueDate == true) {
                                AddActivityNew(
                                    widget.id,
                                    newDistCode,
                                    _remarksController.text,
                                    _distController.text,
                                    newRemarksOn,
                                    _valueController,
                                    _timeController);
                              } else {
                                showAlertDialog(
                                    context, "Alert", "No Attendence Found");
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Add Activity',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Raleway'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )));
        });
  }
}
