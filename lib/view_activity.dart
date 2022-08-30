import 'dart:convert';

import 'package:alkahir/plugins/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'listview.dart';
import 'model/agentActivity_model.dart';

import 'model/agent_model.dart';

class ViewActivity extends StatefulWidget {
  final String id;

  const ViewActivity({Key? key, required this.id}) : super(key: key);

  @override
  _viewActivityState createState() => _viewActivityState();
}

class _viewActivityState extends State<ViewActivity> {
  late ProgressDialog pr;

  String idNav = "";
  String emailNav = "";
  String nameNav = "";
  bool loginNav = false;
  String timeNav = "";
  String zoneNav = "";
  String designationNav = "";
  late String selectDateInString;
  late DateTime selectedDate = DateTime.now();
  String initValue = "Select your Date";
  bool isDateSelected = false;
  final TextEditingController _userDateController = TextEditingController();
  bool statusNav = false;
  List<LatLng> latlngNav = [];

  String start_day = "";
  String endDay = "";

  Future<void> getStartEndDay() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var jsonResponse = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = await preferences.getString("id").toString();
    final TextEditingController _userDateController = TextEditingController();
    Map data = {'agn_code': id};

    try {
      var response = await http.post(
          Uri.parse(

              base_Url + "alkhair/public/api/v1/agent/last-checkin-checkout"),

          body: data);
      print(response.body);
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print(jsonResponse["message"]['started_at']);
        start_day = jsonResponse["message"]['started_at'];
        endDay = jsonResponse["message"]['ended_at'];

        start_day ??= "";

        endDay ??= "";
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getValues() async {
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

  var getDistance = '0';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String assertiveURL =
      base_Url + "alkhair/storage/app/public/images/distributors/";

  String _splitString(String value) {
    var arrayOfString = value.split(',');

    arrayOfString.first = assertiveURL + arrayOfString.first;

    return arrayOfString.first;
  }

  Future<List<AgentActivity>> _getActivity(String date) async {
    List<AgentActivity> viewList = [];
    // pr.show();

    Map data = {'date': date, 'agn_code': widget.id};
var response;

    try {
       response = await http.post(

          Uri.parse(
              base_Url + "alkhair/public/api/v1/agent/daily-remarks-index"),


          body: data);
    }
    catch(e)
    {
      print(e);
    }
print(data);

    var jsonData = json.decode(response.body);
    try {
      getDistance = jsonData['attendance']['total_distance'];
    }
    catch(e)
    {
      print(e);
    }
    print(response.body);
    print("furqan");
    if (response.statusCode == 200) {
      for (var viewActivityIterator in jsonData['activties']) {
        AgentActivity agentActivity = AgentActivity(
          viewActivityIterator["dst_code"].toString(),
          viewActivityIterator["remarks_on"].toString(),
          viewActivityIterator["remarks"].toString(),
          viewActivityIterator["device_time"].toString(),
          viewActivityIterator["name"].toString(),
          viewActivityIterator["contact_no_1"].toString(),
          viewActivityIterator["contact_no_2"].toString(),
          viewActivityIterator["avatar"].toString(),
          viewActivityIterator["covered_sale"].toString(),
          viewActivityIterator["uncovered_sale"].toString(),
          viewActivityIterator["distributor_type"].toString(),
          viewActivityIterator["total_sale"].toString(),
          viewActivityIterator["credit_limit"].toString(),
          viewActivityIterator["shop_name"].toString(),
          viewActivityIterator["our_brands"].toString(),
          viewActivityIterator["distributor_city"].toString(),
          viewActivityIterator["distributor_address"].toString(),
          viewActivityIterator["companies_working_with"].toString(),
          viewActivityIterator["owned"].toString(),
          viewActivityIterator["time"].toString(),
        );

        print(agentActivity.covered_sale);
        viewList.add(agentActivity);
      }

      if (pr.isShowing()) {
        pr.hide();
      }

      return viewList;
    } else {
      if (pr.isShowing()) {
        pr.hide();
      }

      return viewList;
    }
  }

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
        future: Future.wait([getValues(), getStartEndDay()]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              drawer: NavBar(
                  status: statusNav,
                  id: widget.id,
                  email: emailNav,
                  name: nameNav,
                  zone: zoneNav,
                  designation: designationNav,
                  latlng: latlngNav),
              key: _scaffoldKey,
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(50.0, 30.0, 0.0, 0.0),
                            child: Text('View Activity ',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Table(
                          border: TableBorder.symmetric(
                              inside: BorderSide.none,
                              outside: BorderSide(width: 1)),
                          defaultColumnWidth: FixedColumnWidth(80.0),
                          children: [
                            TableRow(children: [
                              Container(
                                color: Color.fromRGBO(106, 136, 171, 1),
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text('Agent',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            backgroundColor: Color.fromRGBO(
                                                106, 136, 171, 1),
                                          )),
                                    ]),
                              ),
                              Container(
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(nameNav.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                    ]),
                              ),
                              Container(
                                color: Color.fromRGBO(106, 136, 171, 1),
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text('Start Day',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            backgroundColor: Color.fromRGBO(
                                                106, 136, 171, 1),
                                          )),
                                    ]),
                              ),
                              Container(
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(start_day.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                    ]),
                              ),
                            ]),
                            TableRow(children: [
                              Container(
                                color: Color.fromRGBO(106, 136, 171, 1),
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text('Zone',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            backgroundColor: Color.fromRGBO(
                                                106, 136, 171, 1),
                                          )),
                                    ]),
                              ),
                              Container(
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(zoneNav.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                    ]),
                              ),
                              Container(
                                color: Color.fromRGBO(106, 136, 171, 1),
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text('End Day',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            backgroundColor: Color.fromRGBO(
                                                106, 136, 171, 1),
                                          )),
                                    ]),
                              ),
                              Container(
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(endDay.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                    ]),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        height: 50,
                        width: 200,
                        color: Color.fromRGBO(106, 136, 171, 1),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Distance in kms: " + getDistance.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    backgroundColor:
                                        Color.fromRGBO(106, 136, 171, 1),
                                  )),
                            ]),
                      ),
                      Container(
                          padding: const EdgeInsets.all(50),
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
                                      print(datePick);
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
                                  onChanged: (value) {
                                    _getActivity(value);
                                  },
                                ),
                              ),
                            ],
                          )),
                      SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: FutureBuilder(
                          future: _getActivity(_userDateController.text),
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
                                          itemExtent: 500.0,
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
                                                border: TableBorder.symmetric(
                                                    inside: BorderSide.none,
                                                    outside:
                                                        BorderSide(width: 1)),
                                                defaultColumnWidth:
                                                    FixedColumnWidth(
                                                        MediaQuery.of(context)
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
                                                            Text(
                                                                'Visiting Card',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                            Text(
                                                                'Customer Type',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                      height: 100,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 70,
                                                              child: Image.network(snapshot
                                                                      .data[
                                                                          index]
                                                                      .avatar ??
                                                                  "https://scontent.flhe5-1.fna.fbcdn.net/v/t31.18172-8/18620768_1416977505022615_5165035795391275854_o.jpg?_nc_cat=106&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=_QAHLR2HecQAX-2PQzh&_nc_ht=scontent.flhe5-1.fna&oh=00_AT9OBOte3iMqXf79hbzW2LlQRWs2AIIzWkbVWcAOaFfIXg&oe=62BD65B0"),
                                                            ),
                                                          ]),
                                                    ),
                                                    Container(
                                                      height: 100,
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
                                                                    .data[index]
                                                                    .time,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      15.0,
                                                                )),
                                                          ]),
                                                    ),
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .distributor_type,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
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
                                                            Text(
                                                                'Customer\nName',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                            Text(
                                                                'Shop Name',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                            Text('Added On',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .name,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .shop_name,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .device_time,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
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
                                                            Text('Remarks',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                            Text('Covered Sale',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                            Text(
                                                                'Uncovered Sale',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Flexible(child:Text(


                                                                snapshot
                                                                    .data[index]
                                                                    .remarks,
                                                                maxLines: 3,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.center,

                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )


                                                            ),),
                                                          ]),
                                                    ),
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .covered_sale,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .uncovered_sale,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),

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
                                                            Text('Address',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                            Text('Companies Working With',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                            Text('Our Brands',
                                            style:
                                            TextStyle(
                                            color: Colors
                                                .white,
                                            fontSize:
                                            15.0,
                                            backgroundColor:
                                            Color.fromRGBO(
                                            106,
                                            136,
                                            171,
                                            1),
                                            )),
                                            ]),
                                            ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                          Flexible(child:  Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .distributor_address,
                                                              textAlign: TextAlign.center,
                                                              overflow: TextOverflow.ellipsis,

                                                              maxLines: 2,

                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                ))),
                                                          ]),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .companies_working_with,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                            Container(
                                            height: 50,
                                            child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                            Flexible(child:Text(
                                            snapshot
                                                .data[index]
                                                .our_brands,

                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                            style:
                                            TextStyle(
                                            fontSize:
                                            12.0,
                                            )),),
                                            ]),
                                            ),

                                                  ]),


                                               /*   TableRow(children: [
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
                                                            Text('City',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                            Text('Address',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .distributor_city,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .distributor_address,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
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
                                                            Text('Companies',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
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
                                                            Text('Owned',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .companies_working_with,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .owned,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),*/
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                }
                            }
                          },
                        ),
                      ),
                    ]),
              ));
        });
  }
}
