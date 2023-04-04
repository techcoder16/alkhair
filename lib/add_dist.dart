import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:alkahir/assets/cities.dart';
import 'package:alkahir/model/distributor_list.dart';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'board.dart';
import 'listview.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'model/MapLocation.dart';



class addDistributor extends StatefulWidget {
  final String id;
  final String email;
  final String name;

  final bool status;
  final LatLng lanlat;
  final String zone;

  final String desgination;

  const addDistributor(
      {Key? key,
      required this.id,
      required this.email,
      required this.name,
      required this.status,
      required this.lanlat,
      required this.zone,
      required this.desgination})
      : super(key: key);

  @override
  _addDistributorState createState() => _addDistributorState();
}

class Brands {
  final int id;
  final String name;

  Brands({
    required this.id,
    required this.name,
  });
}

class _addDistributorState extends State<addDistributor> {


  ReceivePort port = ReceivePort();
  LocationDto? lastLocation;
  int imagecount = 0;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  String _value = "";
  String _value_brand = "";
  List<String> selected = [];
  late List<String> _cityitems;

  File? _image;
  String? countryValue = "";
  String? stateValue = "";
  bool isTapped=false;

  String? cityValue = "";
  bool checkInternet = false;
  late bool v1 = false;
  late bool v2 = false;
  late bool v3 = false;
  late bool v4 = false;
   late  LatLng currentPostion=LatLng(0,0);

  late int value_type = 0;
  final TextEditingController _distributorCompaniesController =
      TextEditingController();
  final TextEditingController _distributorCardLimitController =
      TextEditingController();
  final TextEditingController _distributorTotalSaleController =
      TextEditingController();
  final TextEditingController _distributorUSaleController =
      TextEditingController();
  final TextEditingController _distributorShopSizeController =
      TextEditingController();

  final TextEditingController _distributorFloorController =
      TextEditingController();
  final TextEditingController _distributorShopSizeControllerw =
      TextEditingController();
  final TextEditingController _distributorSaleController =
      TextEditingController();
  final TextEditingController _distributorContactTController =
      TextEditingController();

  final TextEditingController _distributorNameController =
      TextEditingController();
  final TextEditingController _distributorShopNameController =
      TextEditingController();
  final TextEditingController _distributorEmailController =
      TextEditingController();
  final TextEditingController _distributorCNICController =
      TextEditingController();
  final TextEditingController _distributorContactNumController =
      TextEditingController();
  final TextEditingController _distributorAddressController =
      TextEditingController();
  final TextEditingController _distributorCityController =
      TextEditingController();
  final TextEditingController _distributorCoordinatesController =
      TextEditingController();

  bool _fieldValidator = false;
  String _errorMessage = '';
  String _errorFieldMessage = '';
  bool _emailValidator = true;
  bool _passwordValidator = true;

  int validateField(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorFieldMessage = "";
        _fieldValidator = false;
      });
      return 0;
    } else {
      setState(() {
        _errorFieldMessage = "";
        _fieldValidator = true;
      });
      return 1;
    }
    return 0;
  }

  Position? position;
  late ProgressDialog pr;

  LatLng currentLocation = LatLng(0, 0);

  static List<Brands> _brands = [
    Brands(id: 1, name: "Al Khair Foam"),
    Brands(id: 2, name: "I Foam"),
    Brands(id: 3, name: "Araamco"),
    Brands(id: 4, name: "Foamage"),
    Brands(id: 5, name: "SereneFoam"),
  ];

  final _items = _brands
      .map((brands) => MultiSelectItem<Brands>(brands, brands.name))
      .toList();

  List<Brands> _selectedBrands = [];

  Future getGalleryImage() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image as File;
      Navigator.pop(context);
    });
  }

  Future<void> getValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //  loadData(latlng);
  }

  int validateMobile(String value) {
    String pattern = r'(^(?:[0-9]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 0;
    } else if (value.length == 10) {
      return 1;
    }
    return 0;
  }

  //============================== Image from gallery
  Future getCameraImage() async {
    final ImagePicker _picker = ImagePicker();

    final File? image = (await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50)) as File?;
    setState(() {
      _image = image;
      Navigator.pop(context);
    });
  }
  //============================== Image from gallery

  //============================== Show from gallery

  void _resetState() {
    setState(() {
      pr.hide();
    });
  }
  Future<void> _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);

    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<bool> submit(
      String distributor,
      shop,
      email,
      cnic,
      contactNo,
      address,
      city,
      coordinates,
      String companies,
      String card,
      String totalSales,
      usales,
      shopsize,
      floor,
      sale,
      contactt,
      _value_brand_param,
      id,
      bool workingCheck,
      // ignore: non_constant_identifier_names
      bool ownedCheck,
      List<XFile>? attachments,
      int value_type,
      String width,
      depth) async {
    attachments?.forEach((element) {});
    initConnectivity();

    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    coordinates =
        position.latitude.toString() + "," + position.longitude.toString();



    Map<String, String> data = {
      'distributor_type': value_type.toString(),
      'name': distributor,
      'shop_name': shop,
      'email': email,
      'cnic': cnic,
      'address': address,
      'city': city,
      'coordinates': coordinates.toString(),
      'added_by': id.toString(),
      'width': width,
      'depth': depth,
      'floor': floor,
      'owned': ownedCheck == true ? "1" : "0",
      'covered_sale': sale,
      'uncovered_sale': usales,
      'total_sale': totalSales,
      'credit_limit': card,
      'companies_working_with': companies,
      'working_with_us': workingCheck == true ? "1" : "0",
      "our_brands": _value_brand_param,
      'contact_no_1': contactNo,
      'contact_no_2': contactt,
      'password': "000000",
      "password_confirmation": "000000",
      'added_by': id,
    };
  String   img64FileOne = "";
    String   img64FileTwo = "";
    String   img64FileThree = "";


    if(attachments![0]!.path != "abdef") {
      File compressedFileOne = await FlutterNativeImage.compressImage(
          attachments![0]!.path,
          quality: 10,
          percentage: 20);

      final bytesFileOne = File(compressedFileOne.path).readAsBytesSync();

      img64FileOne = base64Encode(bytesFileOne);
    }
    if(attachments![1]!.path != "abc")
    {
    File compressedFileTwo = await FlutterNativeImage.compressImage(
    attachments![1]!.path,
    quality: 10,
    percentage: 20);
    final bytesFileTwo = File(compressedFileTwo.path).readAsBytesSync();
    img64FileTwo = base64Encode(bytesFileTwo);


    }

    if(attachments![2]!.path != "abcef")
      {
      File compressedFileThree = await FlutterNativeImage.compressImage(
          attachments![2]!.path,
          quality: 10,
          percentage: 20);

    final bytesFileThree = File(compressedFileThree.path).readAsBytesSync();
    img64FileThree = base64Encode(bytesFileThree);



    }


    saveDataDistributor(
        value_type.toString(),
        distributor,
        shop,
        email,
        cnic,
        address,
        city,
        coordinates,
        shopsize,
        floor,
        ownedCheck == true ? "1" : "0",
        sale,
        usales,
        totalSales,
        card,
        companies,
        workingCheck == true ? "1" : "0",
        _value_brand_param,
        contactNo,
        contactt,
        "0000000",
        "0000000",
        id,
        img64FileOne!,
        img64FileTwo!,
        img64FileThree!,
      depth, width
        );


//loadDataDistributor();
    Navigator.push(context, MaterialPageRoute(builder: (context) => BoardView()));
//    showAlertDialog(context, "Alert", "Customer Added!", 1);

//
    return true;
  }

  showAlertDialog(BuildContext context, String title, String desc, int x) {
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
          if (x == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BoardView()));
          }

          if (pr.isShowing()) {
            pr.hide();
          }
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

  ///  ===================== internet check ===================================

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  var types_dist = <String>['Distributor', 'Dealer', 'Retailer'];

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();

      if (result == ConnectivityResult.mobile) {
        checkInternet = true;
      } else if (result == ConnectivityResult.wifi) {
        checkInternet = true;
      } else {
        checkInternet = false;
      }
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  ///  ===================== internet check ===================================

  Future<void> updateUI(LocationDto data) async {
    await _updateNotificationText(data);
    latlng.add(LatLng(data.latitude, data.longitude));

    saveData(data.latitude, data.longitude);

    setState(() {
      if (data != null) {
        lastLocation = data;
      }
    });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: "AlKhair Location Tracker received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }

  @override
  void initState() {
    _getUserLocation();

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );

    List dataList = CitiesJson["data"]["list"];

    _cityitems = List.generate(
      dataList.length,
      (i) => "${dataList[i]["name"]}",
    );
  }

  //========================= Gellary / Camera AlerBox
  List<XFile>? _imageFileList = [
    XFile("assets/noimage.png"),
    XFile("assets/noimage.png"),
    XFile("assets/noimage.png")
  ];

  late XFile? fileOne = XFile("assets/noimage.png");
  late XFile? fileTwo = XFile("assets/noimage.png");
  late XFile? fileThree = XFile("assets/noimage.png");

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _onImageButtonPressed(ImageSource source, int value,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final List<XFile>? pickedFileList = await _picker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            if (value == 1) {
              fileOne = pickedFileList![0];
            } else if (value == 2) {
              fileTwo = pickedFileList![0];
            } else if (value == 3) {
              fileThree = pickedFileList![0];
            }

            pr.isShowing() == true ? pr.hide() : '';
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    } else {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            if (value == 1) {
              fileOne = pickedFile!;
            } else if (value == 2) {
              fileTwo = pickedFile!;
            } else if (value == 3) {
              fileThree = pickedFile!;
            }

            pr.isShowing() == true ? pr.hide() : '';
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    }
  }

  @override
  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();

    if (retrieveError != null) {
      return retrieveError;
    }

    return Row(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: 120,
            width: 80,
            child: Stack(
              children: <Widget>[
                kIsWeb
                    ? Image.network(fileOne!.path, fit: BoxFit.fill)
                    : fileOne.runtimeType == XFile &&
                            fileOne?.path != 'assets/noimage.png'
                        ? Image.file(
                            File(fileOne!.path),
                            fit: BoxFit.fill,
                          )
                        : Image.asset(fileOne!.path),
                Positioned(
                  right: 5,
                  top: 25,
                  left: 53,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 30,
                      color: Color.fromRGBO(55, 75, 167, 1),
                    ),
                    onTap: () {
                      setState(() {
                        fileOne = XFile("assets/noimage.png");
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 55,
                  left: 53,
                  child: InkWell(
                    child: Icon(
                      Icons.add_circle,
                      size: 30,
                      color: Color.fromRGBO(55, 75, 167, 1),
                    ),
                    onTap: () {
                      setState(() {
                        _onAlertPress(1);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: 120,
            width: 80,
            child: Stack(
              children: <Widget>[
                kIsWeb
                    ? Image.network(fileTwo!.path, fit: BoxFit.fill)
                    : fileTwo.runtimeType == XFile &&
                            fileTwo?.path != 'assets/noimage.png'
                        ? Image.file(
                            File(fileTwo!.path),
                            fit: BoxFit.fill,
                          )
                        : Image.asset(fileTwo!.path),
                Positioned(
                  right: 5,
                  top: 25,
                  left: 53,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 30,
                      color: Color.fromRGBO(55, 75, 167, 1),
                    ),
                    onTap: () {
                      setState(() {
                        fileTwo = XFile("assets/noimage.png");
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 55,
                  left: 53,
                  child: InkWell(
                    child: Icon(
                      Icons.add_circle,
                      size: 30,
                      color: Color.fromRGBO(55, 75, 167, 1),
                    ),
                    onTap: () {
                      setState(() {
                        _onAlertPress(2);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: 120,
            width: 80,
            child: Stack(
              children: <Widget>[
                kIsWeb
                    ? Image.network(fileThree!.path, fit: BoxFit.fill)
                    : fileThree.runtimeType == XFile &&
                            fileThree?.path != 'assets/noimage.png'
                        ? Image.file(
                            File(fileThree!.path),
                            fit: BoxFit.fill,
                          )
                        : Image.asset(fileThree!.path),
                Positioned(
                  right: 5,
                  top: 25,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 30,
                      color: Color.fromRGBO(55, 75, 167, 1),
                    ),
                    onTap: () {
                      setState(() {
                        fileThree = XFile("assets/noimage.png");
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 55,
                  child: InkWell(
                    child: Icon(
                      Icons.add_circle,
                      size: 30,
                      color: Color.fromRGBO(55, 75, 167, 1),
                    ),
                    onTap: () {
                      setState(() {
                        _onAlertPress(3);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Choose Image'),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  if (pr.isShowing()) {
                    pr.hide();
                  }

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    if (pr.isShowing()) {
                      pr.hide();
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _onAlertPress(int value) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Stack(children: <Widget>[
            CupertinoAlertDialog(
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Column(
                    children: const <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Icon(Icons.image_search, color: Colors.black, size: 60),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Gallery'),
                    ],
                  ),
                  onPressed: () {
                    _onImageButtonPressed(
                      ImageSource.gallery,
                      value,
                      context: context,
                      isMultiImage: true,
                    );
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Column(
                    children: const <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Icon(Icons.camera_alt_rounded,
                          color: Colors.black, size: 60),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Take Photo'),
                    ],
                  ),
                  onPressed: () {
                    pr.show();
                    _onImageButtonPressed(ImageSource.camera, value,
                        context: context);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Column(
                    children: const <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text('Close'),
                    ],
                  ),
                  onPressed: () {
                    if (pr.isShowing()) {
                      pr.hide();
                    }
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ]);
        });
  }

  // ================================= Image from camera

  bool saveAdress = false;
  bool ownedCheck = false;
  bool workingCheck = false;
  List<LatLng> latlng = [];

  @override
  Widget build(BuildContext context) {
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

    //============================================= loading dialoge
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false);

    //Optional
    pr.style(
      padding: EdgeInsets.all(16),
      message: 'Please wait...',
      borderRadius: 3.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        strokeWidth: 3,
        backgroundColor: Color.fromRGBO(55, 75, 167, 1),
      ),
      elevation: 2.0,
      insetAnimCurve: Curves.bounceIn,
      progressTextStyle: TextStyle(
          color: Color.fromRGBO(55, 75, 167, 1),
          fontSize: 2.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.normal,
          color: Colors.grey),
    );

    _distributorCoordinatesController.text = currentPostion.latitude.toString() +
        "," +
        currentPostion.longitude.toString();

    return FutureBuilder(
        future: Future.wait([getValues()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              key: _scaffoldKey,
              drawer: NavBar(
                status: widget.status,
                id: widget.id,
                email: widget.email,
                name: widget.name,
                latlng: latlng,
                zone: widget.zone,
                designation: widget.desgination,
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                    SingleChildScrollView(
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  child: Image.asset('assets/splash.png'),
                                  height: 100.0,
                                  width: 100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ///=====================================

                    Container(
                        padding:
                            EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            Column(children: <Widget>[
                              Row(
                                children: const [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text("Shop"),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text("Visiting Card"),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text("Person"),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(7.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromRGBO(55, 75, 167, 1))),
                                height: 120,
                                width: 300,
                                child: !kIsWeb &&
                                        defaultTargetPlatform ==
                                            TargetPlatform.android
                                    ? FutureBuilder<void>(
                                        future: retrieveLostData(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<void> snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                              return const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10,
                                                    10,
                                                    20,
                                                    20), //apply padding to LTRB, L:Left, T:Top, R:Right, B:Bottom
                                                child: Text("No Image yet"),
                                              );
                                            case ConnectionState.done:
                                              return SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                  child: _handlePreview());
                                            default:
                                              if (snapshot.hasError) {
                                                return Text(
                                                  'Pick image/video error: ${snapshot.error}}',
                                                  textAlign: TextAlign.center,
                                                );
                                              } else {
                                                return const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10,
                                                      10,
                                                      20,
                                                      20), //apply padding to LTRB, L:Left, T:Top, R:Right, B:Bottom
                                                  child: Text("No Image yet"),
                                                );
                                              }
                                          }
                                        },
                                      )
                                    : SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: _handlePreview()),
                              ),
                              /*  Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Semantics(
                                    label: 'image_picker_from_gallery',
                                    child: FloatingActionButton(
                                      onPressed: _onAlertPress,
                                      heroTag: 'image0',
                                      tooltip: 'Pick Image from gallery',
                                      child: const Icon(Icons.upload),
                                      backgroundColor:
                                      Color.fromRGBO(55, 75, 167, 1),
                                    ),
                                  ),
                                ],
                              ),*/
                            ]),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _errorMessage + "\n" + _errorFieldMessage,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Multi"),
                              ),
                            ),

                            SizedBox(height: 20.0),

                            ///=====================================

                            TextField(
                              controller: _distributorNameController,
                              decoration: const InputDecoration(
                                  labelText: 'Customer Name *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.account_box),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              onChanged: (value) {

                              },
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: _distributorEmailController,
                              decoration: const InputDecoration(
                                  labelText: 'EMAIL',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.email),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(13),
                              ],
                              controller: _distributorCNICController,
                              decoration: const InputDecoration(
                                  labelText: 'CNIC',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.assignment_ind_outlined),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(10),
                              ],
                              controller: _distributorContactNumController,
                              decoration: const InputDecoration(
                                  prefixText: '+92 ',
                                  labelText: 'Contact Number *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.phone_iphone),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {

                              },
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(10),
                              ],
                              maxLength: 10,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              controller: _distributorContactTController,
                              decoration: const InputDecoration(
                                  prefixText: '+92 ',
                                  labelText: 'Contact Number 2',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.phone_iphone),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: _distributorAddressController,
                              decoration: const InputDecoration(
                                  labelText: 'Address *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.house),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              onChanged: (value) {

                              },
                            ),
                            SizedBox(height: 20.0),

                            Container(
                              padding: const EdgeInsets.only(right: 0),
                              child: DropdownSearch<String>(
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                //   alignment: Alignment.centerLeft,
                                // isDense: true,
                                popupItemDisabled: (String s) =>
                                    s.startsWith('I'),
                                dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(0.0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    labelText: 'City *',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                    icon: Icon(Icons.location_city),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                55, 75, 167, 1)))),

                                items: _cityitems,

                                onChanged: (value) => setState(() {
                                  _value = value!;
                                }),
                              ),
                            ),

                            TextField(
                              controller: _distributorShopNameController,
                              decoration: const InputDecoration(
                                  labelText: 'Shop Name *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.shop_2),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              onChanged: (value) {

                              },
                            ),
                            SizedBox(height: 20.0),

                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  labelText: 'Customer Type *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.location_city),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              items: types_dist.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                value_type = types_dist.indexOf(value!);

                                // print(value_type);
                              },
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.add_location_alt,
                                    color: Colors.grey),

                                SizedBox(
                                  width: 10,
                                ), //SizedBox
                                Text(
                                  'Working with Us (Yes/No) * ',
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ), //Text

                                Checkbox(
                                  value: v1,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      workingCheck = true;

                                      v2 = false;
                                      v1 = true;
                                    });
                                  },
                                ),

                                Checkbox(
                                  value: v2,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      workingCheck = false;

                                      v1 = false;
                                      v2 = true;
                                    });
                                  },
                                ),
                                //Checkbox
                              ], //<Widget>[]
                            ),
                            const SizedBox(height: 20.0),
                            Visibility(
                              visible: v1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.grey,
                                  ),
                                  Expanded(
                                    child: MultiSelectDialogField(
                                      items: _items,
                                      selectedColor: Colors.grey,
                                      buttonIcon: Icon(
                                        Icons.account_circle,
                                        color: Colors.grey,
                                      ),
                                      title: Text(
                                        "Brands *",
                                        style: TextStyle(
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey),
                                      ),
                                      buttonText: Text(
                                        "Brands",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (List<Brands> results) {
                                        _selectedBrands = results;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.add_location_alt,
                                    color: Colors.grey),

                                SizedBox(
                                  width: 10,
                                ), //SizedBox
                                Text(
                                  'Own (Yes/No)',
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ), //Text

                                Checkbox(
                                  value: v3,
                                  onChanged: (bool? value) {
                                    setState(() {

                                      ownedCheck = true;

                                      v3 = true;
                                      v4 = false;
                                    });
                                  },
                                ),

                                Checkbox(
                                  value: v4,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      ownedCheck = false;

                                      v3 = false;
                                      v4 = true;
                                    });
                                  },
                                ),

                                //Checkbox
                              ], //<Widget>[]
                            ),

                            TextField(
                              controller: _distributorFloorController,
                              decoration: const InputDecoration(
                                  labelText: 'Floor *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.add_shopping_cart_rounded),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              keyboardType: TextInputType.number,

                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.add_shopping_cart_rounded,
                                    color: Colors.grey),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Shop Size *',
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey)),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(width: 20.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,

                                  child: TextField(
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    controller: _distributorShopSizeControllerw,
                                    decoration: const InputDecoration(
                                        labelText: 'Width (In feet) *',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    55, 75, 167, 1)))),
                                    onChanged: (value) {

                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: TextField(
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    controller: _distributorShopSizeController,
                                    decoration: const InputDecoration(
                                        labelText: 'Depth (In feet) *',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    55, 75, 167, 1)))),
                                    onChanged: (value) {

                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.0),

                            TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _distributorSaleController,
                              decoration: const InputDecoration(
                                  labelText: 'Covered Sale *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.point_of_sale),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              onChanged: (value) {

                              },
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (text) {
                                if (_distributorUSaleController.text == "") {
                                  _distributorSaleController.text = "0";
                                }

                                if (_distributorSaleController.text == "") {
                                  _distributorSaleController.text = "0";
                                }

                                double value = double.parse(
                                        _distributorSaleController.text
                                            .toString()) +
                                    double.parse(_distributorUSaleController
                                        .text
                                        .toString());

                                _distributorTotalSaleController.text =
                                    value.toString();
                              },
                              controller: _distributorUSaleController,
                              decoration: const InputDecoration(
                                  labelText: 'Uncovered Sale *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.point_of_sale),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _distributorTotalSaleController,
                              decoration: const InputDecoration(
                                  labelText: 'Total Sale *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.point_of_sale),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              onChanged: (value) {

                              },
                              keyboardType: TextInputType.number,
                            ),

                            SizedBox(height: 20.0),
                            TextField(
                              controller: _distributorCardLimitController,
                              decoration: const InputDecoration(
                                  labelText: 'Credit Limit *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(
                                    Icons.production_quantity_limits,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              showCursor: true,
                              maxLines: 2,
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.justify,
                              controller: _distributorCompaniesController,
                              decoration: const InputDecoration(
                                  labelText: 'Other Brands *',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.house),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),

                              onChanged: (value) {

                              },



                            ),


                            const SizedBox(height: 20.0),

                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(width: 0.0),
                                Expanded(child:

                                      TextField
                                    (
                                      controller: _distributorCoordinatesController,
                                      decoration: InputDecoration(

                                      labelText: 'Current Coordinates',
                                      labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                      icon: Icon(Icons.add_location_rounded ),

                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  55, 75, 167, 1)))),
                                ),


              ),

                                Expanded(

                                child:  IconButton(
                                    icon: const Icon(Icons.add_location_alt_sharp),
                                    color: Colors.grey,

                                    onPressed: () {

                                      _getUserLocation();

                                    }
                                    ,
                                  ),

                                ),
             ], ),



                            SizedBox(height: 20.0),

                            SizedBox(
                              height: 50.0,
                              width: 250,
                              child: Material(
                                borderRadius: BorderRadius.circular(8.0),
                                shadowColor: Colors.blueAccent,
                                color: Color.fromRGBO(55, 75, 167, 1),

                                child: InkWell(

                                  onTap: ()
                                  {
                                    _getUserLocation();

                                  if(!isTapped){



                                    int x = 1;
                                    x = x *
                                        validateField(
                                            _distributorShopSizeController
                                                .text);
                                    x = x *
                                        validateField(
                                            _distributorShopNameController
                                                .text);

                                    x = x *
                                        validateField(
                                            _distributorSaleController.text);

                                    x = x *
                                        validateField(
                                            _distributorNameController.text);

                                    x = x *
                                        validateField(
                                            _distributorShopNameController
                                                .text);

                                    x = x *
                                        validateField(
                                            _distributorContactNumController
                                                .text);
                                    x = x *
                                        validateField(
                                          _distributorAddressController.text,
                                        );
                                    x = x *
                                        validateField(
                                            _distributorUSaleController.text);
                                    x = x *
                                        validateField(
                                            _distributorFloorController.text);
                                    x = x *
                                        validateField(
                                            _distributorTotalSaleController
                                                .text);
                                    x = x *
                                        validateField(
                                            _distributorCardLimitController
                                                .text);
                                    x = x *
                                        validateField(
                                            _distributorShopSizeControllerw
                                                .text);

                                    x = x *
                                        validateMobile(
                                            _distributorContactNumController
                                                .text);


                                    x = x *
                                        validateField(
                                            _distributorCompaniesController
                                                .text);


                        x = x* validateField(_value);


                                    if (x == 0) {
                                      showAlertDialog(
                                          context, "Alert", "Field Missing", x);
                                      return;
                                    } else {
                                      List dataList =
                                          CitiesJson["data"]["list"];
                                      var valueSizeShop =
                                          _distributorShopSizeController.text +
                                              "," +
                                              _distributorShopSizeControllerw
                                                  .text;

                                      try {
                                        _imageFileList![0] = (fileOne?.path !=
                                                "assets/noimage.png"
                                            ? fileOne
                                            : XFile("abdef"))!;
                                        _imageFileList![1] = (fileTwo?.path !=
                                                "assets/noimage.png"
                                            ? fileTwo
                                            : XFile("abc"))!;
                                        _imageFileList![2] = (fileThree?.path !=
                                                "assets/noimage.png"
                                            ? fileThree
                                            : XFile("abcef"))!;

                                        _selectedBrands.forEach((element) {
                                          _value_brand +=
                                              element.name.toString() + ",";
                                        });
                                      } catch (e) {
                                        showAlertDialog(context, "Alert",
                                            "Image not found", 0);
                                        return;
                                      }

                                      if (true) {

                                        isTapped=true;
                                        submit(
                                                _distributorNameController.text,
                                                _distributorShopNameController
                                                    .text,
                                                _distributorEmailController
                                                    .text,
                                                _distributorCNICController.text,
                                                _distributorContactNumController
                                                    .text,
                                                _distributorAddressController
                                                    .text,
                                                _value,
                                                _distributorCoordinatesController
                                                    .text,
                                                _distributorCompaniesController
                                                    .text,
                                                _distributorCardLimitController
                                                    .text,
                                                _distributorTotalSaleController
                                                    .text,
                                                _distributorUSaleController
                                                    .text,
                                                valueSizeShop.toString(),
                                                _distributorFloorController
                                                    .text,
                                                _distributorSaleController.text,
                                                _distributorContactTController
                                                    .text,
                                                _value_brand,
                                                widget.id,
                                                workingCheck,
                                                ownedCheck,
                                                _imageFileList,
                                                value_type,
                                                _distributorShopSizeController
                                                    .text,
                                                _distributorShopSizeControllerw
                                                    .text)
                                            .then((value) {
                                          setState(() {

                                            saveAdress = value;
                                            _selectedBrands = [];
                                            _value_brand = "";


                                          });
                                        });
                                        _selectedBrands = [];
                                      } else {
                                        showAlertDialog(context, "Alert",
                                            "Image Missing", 0);
                                      }
                                    }
                                  }
        },
                                  child: const Center(

                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Raleway'),
                                      ),

                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 20.0),
                  ],
                ),
              ));
        });
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
