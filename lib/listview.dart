import 'package:alkahir/comment.dart';
import 'package:alkahir/plugins/edit_dist.dart';
import 'package:alkahir/plugins/end_day.dart';
import 'package:alkahir/plugins/sync_checkout.dart';
import 'package:alkahir/plugins/sync_screen.dart';
import 'package:alkahir/plugins/user_profile.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:background_locator/background_locator.dart';


import 'agent_list.dart';
import 'board.dart';
import 'login.dart';

class NavBar extends StatelessWidget {
  final bool status;

  final String id;
  final String email;
  final String name;
  final String zone;
  final String designation;

  final List<LatLng> latlng;

  NavBar(
      {Key? key,
        required this.status,
        required this.id,
        required this.latlng,
        required this.name,
        required this.email,    required this.zone,

        required this.designation})
      : super(key: key);

  String idNav = "";
  String emailNav = "";
  String nameNav = "";
  bool loginNav = false;
  String timeNav = "";
  String zoneNav = "";
  bool statusNav = false;
  LatLng? latlngNav;
  String designationNav = "";

  getValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    statusNav = await preferences.getBool("CheckIn")!;
    emailNav = await preferences.getString("email")!;
    idNav = preferences.getString("id")!;

    nameNav = preferences.getString("name")!;
    print(nameNav);
    loginNav = preferences.getBool("isLogin")!;
    zoneNav = preferences.getString("zone")!;
    designationNav =  preferences.getString("designation")!;

    timeNav = preferences.getString("time")!;
    latlngNav = LatLng(await preferences.getDouble("LocationLattitude")!,
        await preferences.getDouble("LocationLongitude")!);
  }

  Future<void> onStop() async {
    final _isRunning = await BackgroundLocator.isServiceRunning();

    if (_isRunning) {
      await BackgroundLocator.unRegisterLocationUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder(
              future: getValues(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return UserAccountsDrawerHeader(
                  accountName: Text(nameNav),
                  accountEmail: Text(email),
                  /*accountNumber: Text("aaa"),*/
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 100.0,
                    child: ClipOval(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => BoardView()));
                        },
                        child: Image.asset(
                          'assets/splash.png',
                          fit: BoxFit.fill,
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(55, 75, 167, 1),
                  ),
                );
              }),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BoardView()));
            },
          ),
/*
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Sync Distributor'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SyncDistributor(id: id)));
            },
          ),

*/
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Sync'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SyncCheckOut(id: id)));
            },
          ),






          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Customers'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AgentList(id: id)));
            },
          ),
          ListTile(
            leading: Icon(Icons.system_security_update_good),
            title: Text('Update Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserProfile(id: id, email: email, name: name,)));
            },
          ),

          /*   ListTile(
            leading: Icon(Icons.settings),
            title: Text('End Day'),
            onTap: () {
            showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext
            context) =>
            CustomdialogendDay(

            context,
            this.id,

            )
            );




          },
          ),

        */

          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              SharedPreferences preferences =
              await SharedPreferences.getInstance();
              await preferences.clear();
              while (Navigator.canPop(context) == true) {
                Navigator.pop(context);
              }

              onStop();




              preferences.remove("isLogin");
              preferences.setBool("isLogin", false);
              preferences.clear();
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
