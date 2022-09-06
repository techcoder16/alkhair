import 'dart:convert';

import 'package:alkahir/plugins/global.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'listview.dart';

import 'plugins/custom_dialog.dart';
import 'model/agent_model.dart';

class AgentList extends StatefulWidget {
  final String id;

  const AgentList({Key? key, required this.id}) : super(key: key);

  @override
  _agentListState createState() => _agentListState();
}

class _agentListState extends State<AgentList> {
  late ProgressDialog pr;


  String idNav = "";
  String emailNav = "";
  String nameNav = "";
  bool loginNav = false;
  String timeNav = "";
  String zoneNav = "";
  String designationNav = "";

  bool statusNav = false;
  List<LatLng> latlngNav = [];

  getValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try{statusNav = await preferences.getBool("CheckIn")!;}catch(e)  {print(e);}
    try{emailNav = await preferences.getString("email")!;}catch(e)  {print(e);}
    try{idNav = await preferences.getString("id")!;}catch(e)  {print(e);}
    try{nameNav = await preferences.getString("name")!;}catch(e)  {print(e);}
    try{loginNav = await preferences.getBool("isLogin")!;}catch(e)  {print(e);}
    try{timeNav = await preferences.getString("time")!;}catch(e)  {print(e);}
    try{zoneNav = await preferences.getString("zone")!;}catch(e)  {print(e);}
    try{designationNav = await preferences.getString("designation")!;   }catch(e)  {print(e);}


    //loadData(latlngNav);
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String assertiveURL =
      base_Url + "alkhair/storage/app/public/images/distributors/";


  String _splitString(String value) {
    var arrayOfString = value.split(',');

    arrayOfString.first = assertiveURL + arrayOfString.first;

    return arrayOfString.first;
  }

  Future<List<Agent>> _getAgent() async {
    List<Agent> agentsList = [];
    // pr.show();
    var response = await http.get(Uri.parse(
        base_Url + "alkhair/public/api/v1/agent/getdistributorslist/" +
            widget.id.toString()));



    var jsonData = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (var agentIterator in jsonData['data']) {


        Agent agent = Agent(
          agentIterator["id"].toString(),
          agentIterator["dst_code"].toString(),
          agentIterator["distributor_type"].toString(),
          agentIterator["name"].toString(),
          agentIterator["shop_name"].toString(),
          agentIterator["email"].toString(),
            agentIterator["avatar"].toString(),
          agentIterator["shop_size"].toString(),
          agentIterator["floor"].toString(),
          agentIterator["owned"].toString(),
          agentIterator["covered_sale"].toString(),
          agentIterator["uncovered_sale"].toString(),
          agentIterator["total_sale"].toString(),
          agentIterator["credit_limit"].toString(),
          agentIterator["companies_working_"].toString(),
          agentIterator["working_with_us"].toString(),
          agentIterator["our_brands"].toString(),
          agentIterator["cnic"].toString(),
          agentIterator["contact_no_1"].toString(),
          agentIterator["contact_no_2"].toString(),
          agentIterator["address"].toString(),
          agentIterator["city"].toString(),
          agentIterator["coordinates"].toString(),
          agentIterator["api_token"].toString(),
          agentIterator["password_string"].toString(),
          agentIterator["password"].toString(),
          agentIterator["email_verified_at"].toString(),
          agentIterator["remember_token"].toString(),
          agentIterator["status"].toString(),
          agentIterator["deleted_by"].toString(),
          agentIterator["deleted_at"].toString(),
          agentIterator["updated_by"].toString(),
          agentIterator["added_by"].toString(),
          agentIterator["created_at"].toString(),
          agentIterator["updated_at"].toString(),
          agentIterator["width"].toString(),
          agentIterator["depth"].toString(),
        );

        agentsList.add(agent);
        print(agent.avatar);


      }



      if (pr.isShowing()) {


        pr.hide();
      }

      return agentsList;
    } else {
      if (pr.isShowing()) {
        pr.hide();
      }

      return agentsList;
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
                  zone:zoneNav,
                  designation: designationNav,

                  latlng: latlngNav)
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
                              title: Text('Al-Khair Gadoon Ltd.'),
                              actions: const <Widget>[],
                            ),
                            Container(

                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    padding:
                                    EdgeInsets.fromLTRB(50.0, 30.0, 0.0, 0.0),
                                    child: Text('Customer List ',
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
                                  .height*1000,
                              child: FutureBuilder(
                                future: _getAgent(),
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
                                        return Center(
                                            child: Text('No Data Received'));
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
                                                backgroundImage: NetworkImage(
                                                  _splitString(snapshot
                                                      .data[index].avatar),
                                                ),
                                              ),
                                              onTap: () {

                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                    context) =>
                                                        Customdialog(
                                                            context,
                                                            snapshot.data,
                                                            index));
                                              },
                                              title: (Text(
                                                  snapshot.data[index].name)),
                                              subtitle: (Text(
                                                  snapshot.data[index].contact_no_1)),
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
                            ),
                          ]))));
        }
    );
  }
}