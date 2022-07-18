import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alkahir/plugins/global.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'model/checkout_model.dart';
import 'model/distributor_list.dart';
import 'plugins/constglobal.dart';
import 'login.dart';
import 'board.dart';
import 'package:path_provider/path_provider.dart';

import 'package:workmanager/workmanager.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

initData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getBool("CheckIn") == null ||
      prefs.getBool("ShouldDisplay") == null ||
      prefs.getDouble("Opacity") == null ||
      prefs.getDouble("Opacity2") == null ||
      prefs.getString("time") == null ||
      prefs.getString("attendanceID") == null ||
      prefs.getString("designation") == null ||
      prefs.getString("zone") == null ||
      prefs.getDouble("currentLocationLattitude") == null ||
      prefs.getString("startDay") == null ||
      prefs.getDouble("currentLocationLongitude") == null ||
      prefs.getDouble("LocationLattitude") == null ||
      prefs.getDouble("LocationLongitude") == null ||
      prefs.getString("location_key") == null ||
      prefs.getBool("CheckIn") == false ||
      prefs.getString("checkOutTime") == null ||
      prefs.getBool("") == false ||
      prefs.getBool("isRunning") == null) {
    prefs.setBool("CheckIn", false);
    prefs.setBool("ShouldDisplay", false);
    prefs.setDouble("Opacity", 1);
    prefs.setString("time", "");
    prefs.setString("checkOutTime", "");
    prefs.setString("designation", "");

    prefs.setString("zone", "");
    prefs.setString("location_key", "");

    prefs.setString("startDay", "");

    prefs.setDouble("Opacity2", 0.3);
    prefs.setDouble("currentLocationLattitude", 0.0);
    prefs.setDouble("currentLocationLongitude", 0.0);
    prefs.setDouble("LocationLattitude", 0.0);
    prefs.setString("attendanceID", "");
    prefs.setDouble("LocationLongitude", 0.0);

    prefs.setBool("Endday", false);

    prefs.setDouble("Opacity2", 0.3);
    prefs.setBool("isRunning", false);
  }
}

ConnectivityResult _connectionStatus = ConnectivityResult.none;
final Connectivity _connectivity = Connectivity();
late StreamSubscription<ConnectivityResult> _connectivitySubscription;
bool checkInternet = false;
Future<bool> internetConnectivity() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

Uint8List dataFromBase64String(String base64String) {
  try {
    return base64Decode(base64String);
  } catch (e) {
    return base64Decode(
        "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAIAAADTED8xAAADMElEQVR4nOzVwQnAIBQFQYXff81RUkQCOyDj1YOPnbXWPmeTRef+/3O/OyBjzh3CD95BfqICMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMO0TAAD//2Anhf4QtqobAAAAAElFTkSuQmCC");
  }
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  // <-- Notice the updated return type and async
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  late List<CheckOut> finaldist = [];
  late List<Dist> finalcheck = [];
  bool valueForSync = false;
  String msgForSync = "";
  List<CheckOut> checkoutList = [];
  int k=0;

  bool checkInternet = await internetConnectivity();
  if (checkInternet == true) {
    try {
      checkoutList = await loadDataCheckOut();
    } catch (e) {
      print(e);
    }
    finaldist = checkoutList;

    if (finaldist.isNotEmpty) {
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
              Uri.parse(base_Url + "alkhair/public/api/v1/agent/trips"),
              body: d1);
          print(d1);
          print(response.statusCode);

          if (response.statusCode == 200) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove("dist_key_checkout");
          }
        } catch (e) {}
      });
    }




    List<Dist> distList = [];


    try {
      distList = await loadDataDistributor();
    }
    catch (e) {

    }




    finalcheck = distList;





    if(finalcheck.isNotEmpty )
    {
      finalcheck.forEach((element) async {

        var dataDist = element as Dist;

        var data = dataDist.toJson();

        http.MultipartRequest request = http.MultipartRequest(
            "POST",
            Uri.parse(
                base_Url + "alkhair/public/api/v1/agent/distributor"));


        Map<String, String> headers = {"Content-Type": "application/json"};




        request.files
            .add(await http.MultipartFile.fromBytes(
            'avatar[]', dataFromBase64String(element.fileOne),filename: "image"));
        request.files
            .add(await http.MultipartFile.fromBytes(
            'avatar[]', dataFromBase64String(element.fileTwo),filename: "image_2"));

        request.files
            .add(await http.MultipartFile.fromBytes(
            'avatar[]', dataFromBase64String(element.fileThree),filename: "image_3"));
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
          'width' :element.width,
          'depth':element.depth,

          'floor': element.floor,
          'owned': element.owned,
          'covered_sale': element.covered_sale,
          'uncovered_sale': element.uncovered_sale,
          'total_sale': element.total_sale,
          'credit_limit': element.credit_limit == null ? "0" : element.credit_limit,
          'companies_working_with': element.companies_working_with == null ? "" : element.companies_working_with,
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




        http.StreamedResponse response = await request.send();





        final respStr = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          // success


          k++;


          //   showAlertDialog(context, "Alert", response.reasonPhrase.toString());




          final decodedMap = json.decode(respStr);


          valueForSync = decodedMap["error"] == "true"?true :false;
          msgForSync = decodedMap['message'] ;




        }






      });



      SharedPreferences prefs = await SharedPreferences.getInstance();



      if(checkInternet ==true) {

        if(valueForSync ==false) {
          prefs.remove("dist_key");
          if(msgForSync =="")
          {
            msgForSync ="Data Sync";


          }
          //  showAlertDialog(context, "Alert", msgForSync);

        }

        else {
          if(msgForSync =="")
          {
            msgForSync ="Data Sync";


          }

        }






      }




    }




  }

  var isLoggedIn =
      (prefs.getBool('isLogin') == null) ? false : prefs.getBool('isLogin');

  runApp(MyApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn == null || isLoggedIn == false
          ? LoginPage()
          : BoardView())));
}

class MyApp extends StatelessWidget {
  var login;
  @override
  void initState() {}

  Future<bool> hasAlreadyStarted() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.getBool("isLogin") == null ||
          prefs.getBool("isLogin") == false) {
        prefs.setBool("isLogin", false);

        initData();

        return false;
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  MyApp(MaterialApp materialApp);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alkhair',
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      home: FutureBuilder(
          future: hasAlreadyStarted(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              Workmanager().initialize(
                callbackDispatcher,
                isInDebugMode: true,
              );

              return snapshot.hasData == true ? BoardView() : LoginPage();
            } else {
              Workmanager().initialize(
                callbackDispatcher,
                isInDebugMode: true,
              );
              return LoginPage();
            }
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(MaterialApp materialApp, {Key? key, required this.title})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
