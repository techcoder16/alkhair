
// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' ;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:location/location.dart';

class MapScreen extends StatefulWidget {

   bool status;
  final List<LatLng> ListLat;
  final LatLng currentLocation;
  final String id ;
  final String name;
  final String email;

   MapScreen(
      {Key? key,
        required this.id,
        required this.email,
        required this.ListLat,
        required this.currentLocation,
        required this.name,
        required this.status

      })
      : super(key: key);



  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


  var val = false;
  late GoogleMapController mapController;
  // double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  // double _destLatitude = 6.849660, _destLongitude = 3.648190;
  List<LatLng> latlng = [];

  double _originLatitude = 33.567997728, _originLongitude =72.635997456;
  double _destLatitude = 33.567997728, _destLongitude = 72.635997456;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzo75YZ1hfbKAQPDvo0Tfyys9Zo6c9hk";
  var status_of_button = false;
  int changeopacity = 1;
  LatLng currentPostion = LatLng(0, 0);

  LatLng value_latlng = LatLng(0, 0);

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }
  Location location = Location();


  Future<LatLng> get() async {
    final _locationData = await location.getLocation();
    double? long =   _locationData.longitude;
    double? lat =   _locationData.latitude;


    return LatLng(lat!, long!);
  }





  @override
  void initState() {
    currentPostion = widget.currentLocation;
    value_latlng=widget.currentLocation;
    _originLatitude = widget.currentLocation.latitude;
    _originLatitude = widget.currentLocation.latitude;
    _destLatitude = widget.currentLocation.latitude;
    _destLongitude = widget.currentLocation.latitude;

    if(val == false)
    {
      get().then((value) {
        setState(() {

          value_latlng = value;
          latlng.add(value_latlng);



        });
      });
      val = true;
      _getUserLocation();


      location.getLocation().then((value)
      {
        setState((){
          value_latlng =value as LatLng;

        });

      });

    }


    super.initState();
    polylineCoordinates.clear();

    get().then((value) {
      setState(() {

        value_latlng = value;
        _originLatitude = value.latitude;
        _originLongitude = value.longitude;


      });
    });
    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker

    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    currentPostion = widget.currentLocation;
    value_latlng=widget.currentLocation;
    _originLatitude = widget.currentLocation.latitude;
    _originLatitude = widget.currentLocation.latitude;
    _destLatitude = widget.currentLocation.latitude;
    _destLongitude = widget.currentLocation.latitude;


    _getUserLocation();


    if(widget.status == true) {
      get().then((value) {
        setState(() {
          value_latlng = value;
          widget.ListLat.add(value_latlng);



        });
      });
    }



    return SafeArea(
        child: Scaffold(
        body:Column(children: [
        Container(


        height: 400,

          child: GoogleMap(
            initialCameraPosition: CameraPosition(

                target:widget.currentLocation, zoom: 10),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,

            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
    ),


          SizedBox(height: 40.0),


          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(30, 50, 10, 0),
            height: 150,
            width: 150,
            child: InkWell(
              onTap: () {


              //  widget.ListLat.add(LatLng(24.860966,  66.990501));

                _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
                    BitmapDescriptor.defaultMarker);

                /// destination marker

                _getPolyline();


                widget.status = false;

                status_of_button = false;


              },
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Image.asset(
                    'assets/Picture2.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Check Out",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(247, 248, 250,  1),
              //  borderRadius: BorderRadius.circular(30), //border corner radius
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 7, // blur radius
                  offset: Offset(0, 2), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
                ),
                //you can set more BoxShadow() here
              ],
            ),
          ),


        ],
    ),
    ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.walking,
        wayPoints: [PolylineWayPoint(location: "31,74")]);
   /* if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        print(point.latitude.toString()+ " "+ point.longitude.toString());




      });
    }*/
    polylineCoordinates.clear();
    if( widget.ListLat.isNotEmpty && widget.status == false) {

      widget.ListLat.forEach((LatLng point) {
        polylineCoordinates.add(LatLng(point.latitude,point.longitude));


      });


    }
    if( widget.status == false) {
      _addPolyLine();
    }
  }
}