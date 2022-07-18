
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:location/location.dart';


class MapScreen extends StatefulWidget {

final bool status;
  final List<LatLng> ListLat;
  final LatLng currentLocation;
  final String id ;
  final String name;
  final String email;

  const MapScreen(
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
  Location location = Location();
  Future<LatLng> get() async {
    final _locationData = await location.getLocation();
    double? long =   _locationData.longitude;
    double? lat =   _locationData.latitude;


    return LatLng(long!, lat!);
  }
  var status_of_button = false;
  final Set<Marker> _markers = {};
  final Set<Polyline>_polyline={};
  late GoogleMapController mapController;
  // double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  // double _destLatitude = 6.849660, _destLongitude = 3.648190;
  double _originLatitude = 26.48424, _originLongitude = 50.04551;
  double _destLatitude = 26.46423, _destLongitude = 50.06358;

  LatLng value_latlng = LatLng(0, 0);
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBSIo75YZ1hfbKAQPDvo0Tfyys9Zo6c9hk";
  static const LatLng _center = const LatLng(31.5028557, 74.2837891);



  final LatLng _lastMapPosition = _center;
  List<LatLng> latlng = [];



  @override
  void initState() {
    super.initState();

    get().then((value) {
      setState(() {

        print("furqan1: " + value.latitude.toString());
        value_latlng   =value;

      });
    });


    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    print(status_of_button);
    if(status_of_button == true) {
      get().then((value) {
        setState(() {
          print("furqan1: " + value.latitude.toString());
          value_latlng = value;

          widget.ListLat.add(value_latlng);

        });
      });
    }



    return SafeArea(
      child: Scaffold(
           body:Column(children: [
             SizedBox(

      height: 400,


          child:GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(value_latlng.latitude, value_latlng.longitude), zoom: 10),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines:  Set<Polyline>.of(polylines.values),
          )

    ,),

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

                     setState(() {
                       LatLng _news = LatLng(33.567997728, 72.635997456);

                       latlng.add(_news);
                       _markers.add(Marker(
                         // This marker id can be anything that uniquely identifies each marker.
                         markerId: MarkerId(_lastMapPosition.toString()),
                         //_lastMapPosition is any coordinate which should be your default
                         //position when map opens up
                         position: _lastMapPosition,

                         icon: BitmapDescriptor.defaultMarker,

                       ));
                       _polyline.add(Polyline(
                         polylineId: PolylineId(_lastMapPosition.toString()),
                         visible: true,
                         //latlng is List<LatLng>
                         points: latlng,
                         color: Colors.red,
                       ));
                     });

                     status_of_button = false;
                     print(latlng[latlng.length-1]);
                     mapController.setMapStyle("[]");

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
                     get().then((value) {
                       setState(() {
                         print("furqan1: " + value.latitude.toString());
                         value_latlng = value;

                         latlng.add(value_latlng);
                         print(latlng);
                       });
                     });
                     status_of_button = true;


                   },
                   child: Center(
                     child: Text(
                       'Check In',
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


    polylineCoordinates.add(LatLng( 33.56635, 72.64417));
    polylineCoordinates.add(LatLng( 33.57635, 72.63417));

    polylineCoordinates.add(LatLng( 33.56635, 72.64417));


    //    33.56635 72.64417
    //  33.56822 72.63664




    _addPolyLine();
  }
}
