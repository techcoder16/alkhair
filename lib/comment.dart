import 'package:alkahir/plugins/global.dart';
import 'package:background_locator/background_locator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'listview.dart';
import 'model/agent_model.dart';
import 'model/login_model.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class CommentPage extends StatefulWidget {
  final String id;

  const CommentPage({Key? key, required this.id}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

///================================== login api ///

class _CommentScreenState extends State<CommentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _RemarksController = TextEditingController();

  String idNav = "";
  String emailNav = "";
  String nameNav = "";
  String zoneNav = "";
  String designationNav = "";
  String query = '';
  bool loginNav = false;
  String timeNav = "";
  bool checkInternet = false;
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
  }

  TextEditingController editingController = TextEditingController();
  List<Agent> agentsList = [];
  late ProgressDialog pr;
  LoginRequestModel newRequestModel = LoginRequestModel();

  Future<void> _getUserLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble("LocationLattitude", position.latitude);
    prefs.setDouble("LocationLongitude", position.longitude);
  }

/*================================== login api */

  @override
  void initState() {}
  Future<void> onStop() async {
    final _isRunning = await BackgroundLocator.isServiceRunning();

    if (_isRunning) {
      await BackgroundLocator.unRegisterLocationUpdate();
    }
  }

  String assertiveURL =
      base_Url + "alkhair/storage/app/public/images/distributors/";
  List<TextEditingController> _controllers = [];

  List<String> agentsListid = [];
  String _splitString(String value) {
    var arrayOfString = value.split(',');

    arrayOfString.first = assertiveURL + arrayOfString.first;

    return arrayOfString.first;
  }

  List<String> agentsListIdSearch = [];

  /*void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(agentsListIdSearch);
    if(query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }
*/
  Future<List<Agent>> _getAgent(
      id, List<TextEditingController> _controllers) async {
    agentsList = [];

    // pr.show();
    var response = await http.get(Uri.parse(
        base_Url + "api/v1/agent/getdistributors/" +
            id));

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

          /// agentsListIdSearch.add(agentIterator["name"].toString());
        );

        agentsList.add(agent);
      }

      // print(agentsList[0].dst_code);
      // agentsListIdSearch = agentsList ;

      return agentsList;
    } else {
      return agentsList;
    }
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
        onPressed: () {
          if (Navigator.canPop(context) == true) {
            Navigator.pop(context);
          }
        });

    String _splitString(String value) {
      var arrayOfString = value.split(',');

      arrayOfString.first = assertiveURL + arrayOfString.first;

      return arrayOfString.first;
    }

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

  Future<List<Agent>> searchDist(String query) async{

    query = editingController.text;
    //print(query);


    //print(agentsList.length);
    if(agentsList.isNotEmpty) {
   //   print(agentsList![0].city);

    }

    if(agentsList.isEmpty)
      {
     await _getAgent(widget.id, _controllers);
      }

    final agents = agentsList.where((searchAgent) {
      final titleLower = searchAgent.name.toLowerCase();
      final authorLower = searchAgent.city.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      agentsList = agents;
    });
 //   agentsList = [];

      return agents;


  }

  Future<void> endDay(String id, BuildContext context, String text,
      List<TextEditingController> controllers) async {
    var now = DateTime.now();
    var jsonResponse = null;
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedDate = DateFormat.Hms().format(now);

    var newDate =
        formatter.format(now).toString() + " " + formattedDate.toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int i = 0;
    String? aid = prefs.getString("attendanceID");
    text = "";
    agentsListid.forEach((element) {});

    _controllers.forEach((element) {
      try {
        text = text + element.text + ":" + agentsListid[i] + "~|";
      } catch (e) {}

      i++;
    });

    var formattedDate1 = DateFormat.Hms().format(now);

    var newDate1 =
        formatter.format(now).toString() + " " + formattedDate1.toString();
    Map data = {'device_time': newDate1, 'agn_code': id, 'remarks': text};

    var response = await http.post(
        Uri.parse(
            base_Url + "api/v1/agent/daily-remarks"),
        body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        _controllers = [];
        //showAlertDialog(context, "Alert", "Day is Offically Ended");

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _controllers = [];
    agentsListid = [];

//============================================= loading dialoge

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
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Color.fromRGBO(55, 75, 167, 1),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    title: Text('Al-Khair Gadoon Ltd.'),
                    actions: const <Widget>[],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 13.0, right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                        Row(children: [
                          Flexible(
                            flex: 1,
                            child: TextField(
                              controller: editingController,
                              cursorColor: Colors.grey,
              onChanged: searchDist,

                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                hintText: 'Search',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                prefixIcon: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Icon(Icons.search),
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                        ]),

                        //  height:MediaQuery.of(context).size.height   -500 ,
                        FutureBuilder(

                            future: searchDist(editingController.text),
                            initialData: [],
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {

                              for (int i = 0; i < snapshot.data.length; i++) {
                                _controllers.add(TextEditingController());
                                agentsListid
                                    .add(snapshot.data[i].dst_code.toString());
                              }
                              ;


                              if (snapshot.hasError) {
                                return Center(child: Text('No Data Received'));
                              } else {
                                return snapshot.data == null
                                    ? SizedBox(
                                        height: 200,
                                      )
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          print(editingController.text);
                                          return ListTile(
                                            leading: CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                _splitString(snapshot
                                                    .data[index].avatar),
                                              ),
                                            ),
                                            onTap: () {},
                                            subtitle: (Column(

                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  snapshot.data[index].name +
                                                      "\n",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                TextField(
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                  controller:
                                                      _controllers[index],
                                                  onSubmitted: (text) {},
                                                  cursorColor: Colors.grey,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Remarks ',
                                                          fillColor:
                                                              Colors.grey,
                                                          focusColor:
                                                              Colors.grey,
                                                          hoverColor:
                                                              Colors.grey,
                                                          labelStyle: TextStyle(
                                                              fontFamily:
                                                                  'Raleway',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.grey),
                                                          icon: Icon(
                                                            Icons.add_comment,
                                                            color: Colors.grey,
                                                          ),
                                                          focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          55,
                                                                          75,
                                                                          167,
                                                                          1)))),
                                                ),
                                              ],
                                            )),
                                            selectedColor:
                                                Color.fromRGBO(55, 75, 167, 1),
                                            selectedTileColor:
                                                Color.fromRGBO(55, 75, 167, 1),
                                            selected: false,
                                            focusColor:
                                                Color.fromRGBO(55, 75, 167, 1),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider();
                                        },
                                      );
                              }
                            }),

                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Please Add Comments",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal,
                              )),
                        ) //
                            ),

                        SizedBox(height: 24.0),

                      ],
                    ),

                  ),
                  Material(

                    borderRadius: BorderRadius.circular(8.0),
                    shadowColor: Colors.blueAccent,
                    color: Color.fromRGBO(55, 75, 167, 1),
                    elevation: 7.0,
                    child:
                    InkWell(
                      child: Container(height: 50,
                        width: 200,
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),

                        child: Text(
                          "Add Remarks",
                          style:
                          TextStyle(color: Colors.white, fontSize: 17.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () async {
                        await pr.show();

                        endDay(widget.id, context, _RemarksController.text,
                            _controllers);

                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.setBool("SessionDay", false);

                        Navigator.pop(context);

                        if (pr.isShowing()) {
                          await pr.hide();
                          //  showAlertDialog(context, "Alert", "Comments");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
