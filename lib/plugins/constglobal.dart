
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';


import 'package:alkahir/plugins/sync_checkout_new.dart';
import 'package:http/http.dart' as http;
import '../model/checkout_model.dart';
import '../model/distributor_list.dart';
import 'global.dart';
const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
const rescheduledTaskKey = "be.tramckrijte.workmanagerExample.rescheduledTask";
const failedTaskKey = "be.tramckrijte.workmanagerExample.failedTask";
const simpleDelayedTask = "be.tramckrijte.workmanagerExample.simpleDelayedTask";
const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";
const simplePeriodic1HourTask =
    "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";


void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {


    late List<CheckOut> finaldist = [];
    late List<Dist> finalcheck = [];

    List<CheckOut> checkoutList = [];

    switch (task) {
      case simpleTaskKey:
        print("$simpleTaskKey was executed. inputData = $inputData");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("test", true);
        print("Bool from prefs: ${prefs.getBool("test")}");
        break;
      case rescheduledTaskKey:
        final key = inputData!['key']!;
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('unique-$key')) {
          print('has been running before, task is successful');
          return true;
        } else {
          await prefs.setBool('unique-$key', true);
          print('reschedule task');
          return false;
        }
      case failedTaskKey:
        print('failed task');
        return Future.error('failed');
      case simpleDelayedTask:
        print("$simpleDelayedTask was executed");
        break;
      case simplePeriodicTask:
        {
          Timer timerObj;


          timerObj = Timer.periodic(Duration(seconds: 15), (timer) async {

            try {
              checkoutList = await loadDataCheckOut();
            } catch (e) {

            }
            finaldist = checkoutList;



            if (finaldist.isNotEmpty ) {
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
                      Uri.parse(
                          base_Url + "api/v1/agent/trips"),
                      body: d1);
                  print(d1);
                  print(response.statusCode );

                  if (response.statusCode == 200) {

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove("dist_key_checkout");
                  }
                } catch (e) {


                }
              });







            }


          }
              );


        }

        break;
      case simplePeriodic1HourTask:
        print("$simplePeriodic1HourTask was executed");
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory? tempDir = await getTemporaryDirectory();
        String? tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}
