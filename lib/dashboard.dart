import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';


class MyAppnew extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyAppnew> {
  List<Marker> _markers = <Marker>[];
  Completer<GoogleMapController> _controller = Completer();

  Location location = Location();
  Future<LatLng> get() async {
    final _locationData = await location.getLocation();
  double? long =   _locationData.longitude;
    double? lat =   _locationData.latitude;


    return LatLng(long!, lat!);
  }

 _fetchOffers()
{
  get().then((value) {
    setState(() {

      print("furqan1: " + value.latitude.toString());

    });
  });
}

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    get().then((value) {
      setState(() {

        print("furqan1: " + value.latitude.toString());

      });
    });


  }




  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
          title: Text('Alkhair',textAlign: TextAlign.center,),
          backgroundColor: Colors.red,
        )

        ,

       body: SingleChildScrollView(
        child: Column

        (

            children: <Widget>[
        SizedBox(
          height: 500,



        child: FutureBuilder<LatLng>(


          future: get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final locationModel = snapshot.data!;

              LatLng _center =  LatLng(locationModel.longitude, locationModel.latitude);
              Set<Marker> _markers={};
              print(locationModel.longitude.toString()+ " "+ locationModel.latitude.toString());


              _markers.add(
                  Marker(
                      markerId: MarkerId('SomeId'),
                      position: LatLng(locationModel.longitude, locationModel.latitude),
                      infoWindow: InfoWindow(
                          title: 'Your current location'
                      )
                  )
              );


              return GoogleMap(

                circles: {Circle( circleId: CircleId('currentCircle'),
                  center: LatLng(_center.latitude,_center.longitude),
                  radius: 2000,
                  fillColor: Colors.blue.shade100.withOpacity(0.5),
                  strokeColor:  Colors.blue.shade100.withOpacity(0.1),
                ),},
                  onCameraMove: (cameraPosition) => print('MAPPP MOVEEE: $cameraPosition')
    ,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
    markers: Set<Marker>.of(_markers),
                initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
              );
            }
            return const CircularProgressIndicator();
          },
        ),


      ),


              Container(
                padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Text('Press check in to start tracking',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal)),
              ),

              SizedBox(height: 40.0),

              SizedBox(

                height: 40.0,
                width: 300,
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  shadowColor: Colors.redAccent,
                  color: Colors.red,
                  elevation: 9.0,
                  child: GestureDetector(
                    onTap: () {






                    },
                    child: Center(
                      child: Text(
                        'Check Out',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ),
              ),

    ],

    ),

    ),
      ),
    );
  }

  void newfun() {}
}