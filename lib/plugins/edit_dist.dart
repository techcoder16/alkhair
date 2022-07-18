import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dist_edit_page.dart';
import '../listview.dart';
import '../model/MapLocation.dart';
import '../plugins/custom_dialog.dart';
import '../model/agent_model.dart';
import 'global.dart';

class EditAgentList extends StatefulWidget {
  final String id;

  const EditAgentList({Key? key, required this.id}) : super(key: key);

  @override
  _agentEditListState createState() => _agentEditListState();
}

class _agentEditListState extends State<EditAgentList> {
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
    statusNav = await preferences.getBool("CheckIn")!;
    emailNav = await preferences.getString("email")!;
    idNav = await preferences.getString("id")!;
    nameNav = await preferences.getString("name")!;
    loginNav = await preferences.getBool("isLogin")!;
    timeNav = await preferences.getString("time")!;
    zoneNav = await preferences.getString("zone")!;
    designationNav = await preferences.getString("designation")!;

 //   loadData(latlngNav);
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
        base_Url + "alkhair/public/api/v1/agent/getdistributors/" +
            widget.id.toString()));

    var jsonData = json.decode(response.body);

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
          agentIterator["companies_working_with"].toString(),
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
          agentIterator["depth"].toString(),
          agentIterator["width"].toString(),
        );


        agentsList.add(agent);
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
                                    padding: EdgeInsets.fromLTRB(
                                        50.0, 30.0, 0.0, 0.0),
                                    child: Text('Distributor Edit ',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height + 200,
                              child: FutureBuilder(
                                future: _getAgent(),
                                initialData: [],
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return new Center(
                                          child:
                                              new CircularProgressIndicator());

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
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        _splitString(snapshot
                                                            .data[index]
                                                            .avatar),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditDistributor(
                                                                    id: idNav,
                                                                    email:
                                                                        emailNav,
                                                                    name:
                                                                        nameNav,
                                                                    zone:
                                                                        zoneNav,
                                                                    designation:
                                                                        designationNav,
                                                                    lanlat: " ",
                                                                    did: snapshot
                                                                        .data[
                                                                            index]
                                                                        .id,
                                                                    dst_code: snapshot
                                                                        .data[
                                                                            index]
                                                                        .dst_code,
                                                                    status:
                                                                        statusNav,
                                                                    ddistributor_type: snapshot
                                                                        .data[
                                                                            index]
                                                                        .distributor_type,
                                                                    dname: snapshot
                                                                        .data[
                                                                            index]
                                                                        .name,
                                                                    shop_name: snapshot
                                                                        .data[
                                                                            index]
                                                                        .shop_name,
                                                                    demail: snapshot
                                                                        .data[
                                                                            index]
                                                                        .email,
                                                                    cnic: snapshot
                                                                        .data[
                                                                            index]
                                                                        .cnic,
                                                                    address: snapshot
                                                                        .data[
                                                                            index]
                                                                        .address,
                                                                    city: snapshot
                                                                        .data[
                                                                            index]
                                                                        .city,
                                                                    coordinates: snapshot
                                                                        .data[
                                                                            index]
                                                                        .coordinates,
                                                                    shop_size: snapshot
                                                                        .data[
                                                                            index]
                                                                        .shop_size,
                                                                    floor: snapshot
                                                                        .data[
                                                                            index]
                                                                        .floor,
                                                                    owned: snapshot
                                                                        .data[
                                                                            index]
                                                                        .owned,
                                                                    covered_sale: snapshot
                                                                        .data[
                                                                            index]
                                                                        .covered_sale,
                                                                    uncovered_sale: snapshot
                                                                        .data[
                                                                            index]
                                                                        .uncovered_sale,
                                                                    total_sale: snapshot
                                                                        .data[
                                                                            index]
                                                                        .total_sale,
                                                                    credit_limit: snapshot
                                                                        .data[
                                                                            index]
                                                                        .credit_limit,
                                                                    companies_working_with: snapshot
                                                                        .data[
                                                                            index]
                                                                        .companies_working_with,
                                                                    working_with_us: snapshot
                                                                        .data[
                                                                            index]
                                                                        .working_with_us,
                                                                    our_brands: snapshot
                                                                        .data[
                                                                            index]
                                                                        .our_brands,
                                                                    contact_no_1: snapshot
                                                                        .data[
                                                                            index]
                                                                        .contact_no_1,
                                                                    contact_no_2: snapshot
                                                                        .data[
                                                                            index]
                                                                        .contact_no_2,
                                                                    password: snapshot
                                                                        .data[
                                                                            index]
                                                                        .password,
                                                                    password_confirmation:
                                                                        "000",
                                                                    added_by: snapshot
                                                                        .data[
                                                                            index]
                                                                        .added_by,
                                                                    avatar: snapshot
                                                                        .data[
                                                                            index]
                                                                        .avatar,
                                                                    width: snapshot
                                                                        .data[
                                                                            index]
                                                                        .width,
                                                                    depth: snapshot
                                                                        .data[
                                                                            index]
                                                                        .depth,
                                                                  )));
                                                    },
                                                    title: (Text(snapshot
                                                        .data[index].name)),
                                                    subtitle: (Text(snapshot
                                                        .data[index].email)),
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
                                                  return Divider();
                                                },
                                              );
                                      }
                                  }
                                },
                              ),
                            ),
                          ]))));
        });
  }
}
