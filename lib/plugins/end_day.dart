import 'dart:convert';

import 'package:alkahir/plugins/start_day.dart';
import 'package:background_locator/background_locator.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import '../model/agent_model.dart';

final TextEditingController _RemarksController =
TextEditingController();



Future<void> onStop() async {
  final _isRunning = await BackgroundLocator.isServiceRunning();

  if (_isRunning) {
    await BackgroundLocator.unRegisterLocationUpdate();
  }
}
late ProgressDialog pr;
String assertiveURL =
    "http://alkhair.rextech.pk/alkhair/storage/app/public/images/distributors/";
List<TextEditingController> _controllers = [];

List<String> agentsListid = [];
String _splitString(String value) {
  var arrayOfString = value.split(',');

  arrayOfString.first = assertiveURL + arrayOfString.first;

  return arrayOfString.first;
}


Future<List<Agent>> _getAgent(id, List<TextEditingController> _controllers) async {
  List<Agent> agentsList = [];

  // pr.show();
  var response = await http.get(Uri.parse(
      "http://alkhair.rextech.pk/alkhair/public/api/v1/agent/getdistributors/" +id));




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



Future<void> endDay(String id,BuildContext context, String text, List<TextEditingController> controllers) async {
  var now = DateTime.now();
  var jsonResponse = null;
  var  formatter = DateFormat('yyyy-MM-dd');
  var formattedDate = DateFormat.Hms().format(now);


  var newDate = formatter.format(now).toString() +
      " " +
      formattedDate.toString();



  SharedPreferences prefs = await SharedPreferences.getInstance();
int i=0;
  String? aid =  prefs.getString("attendanceID");
text = "";
  agentsListid.forEach((element) {



  });


  _controllers.forEach((element) {
try {


  text = text + element.text + ":" + agentsListid[i] + "~|";
}
catch(e)
  {

  }

i++;

});



  var formattedDate1 = DateFormat.Hms().format(now);

  var newDate1 =
      formatter.format(now).toString() + " " + formattedDate1.toString();
  Map data = {'device_time': newDate1,'agn_code': id,
  'remarks':text
  };




  var response = await http.post(
      Uri.parse(
          "http://alkhair.rextech.pk/alkhair/public/api/v1/agent/daily-remarks"),
      body: data);

  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);


    if (jsonResponse != null) {
_controllers = [];
      //showAlertDialog(context, "Alert", "Day is Offically Ended");

    }
  }


}

CustomdialogendDay(BuildContext context,String id)
{




  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    child: dialogContent(context,id),


  );

}

Widget dialogContent(BuildContext context,String id) {
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


  return   SingleChildScrollView(



    child:


    Stack(
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
              SizedBox(height: 40.0),







              SingleChildScrollView(

             //  height:MediaQuery.of(context).size.height   -500 ,
                child: FutureBuilder(
                    future: _getAgent(id,_controllers),
                    initialData: [],
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {

                      for(int i = 0; i<snapshot.data.length;i++)
                        {

                          _controllers.add(TextEditingController());
                          agentsListid.add(snapshot.data[i].dst_code.toString());



                        }
                      ;





                      if (snapshot.hasError) {
                        return Center(
                            child: Text('No Data Received'));
                      } else {
                        return snapshot.data == null
                            ? SizedBox(
                          height: 200,
                        )
                            : ListView.separated(
                          shrinkWrap: true,
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


                              },



                              subtitle: (Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [





                            Text(
                              snapshot.data[index].name + "\n" +
                            snapshot.data[index].email,style:TextStyle(color:Colors.white),)
,
                                TextField(

                                  style: TextStyle(color: Colors.white),


controller:_controllers[index],
                                  onSubmitted: (text)
                                  {

                                  },

                                  cursorColor: Colors.white,


                                  decoration: const InputDecoration(
                                      labelText: 'Remarks ',
                                      fillColor: Colors.white
                                      ,
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,

                                      labelStyle: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.normal,

                                          color: Colors.white),
                                      icon: Icon(Icons.add_comment,color: Colors.white, ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color:

                                              Color.fromRGBO(55, 75, 167, 1)))),
                                ),


                              ],
                              )),

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

                ),
              ),




              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(

                        "Please Add Comments"
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
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0)),

                    color:Colors.white,

                  ),
                  child:  Text(
                    "Add Remarks",
                    style: TextStyle(color: Colors.blue,fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap:() async {

                  await pr.show();




                  endDay(id,context,_RemarksController.text,_controllers);


                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("SessionDay", false);

                  Navigator.pop(context);

      if(pr.isShowing())
        {
          await pr.hide();
        //  showAlertDialog(context, "Alert", "Comments");
        }

                },
              )
,

            ],
          ),
        ),


        Positioned(
          right: 0.0,
          child: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: Color.fromRGBO(55, 75, 167, 1)),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


