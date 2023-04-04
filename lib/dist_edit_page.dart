import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:alkahir/assets/cities.dart';
import 'package:alkahir/plugins/global.dart';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:csc_picker/csc_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'board.dart';
import 'listview.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'model/MapLocation.dart';
import 'model/image_uploadmodel.dart';
import 'plugins/functions.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class EditDistributor extends StatefulWidget {
  final String id;
  final String email;
  final String name;

  final bool status;
  final String lanlat;
  final String ddistributor_type;
  final String dname;
  final String did;
  final String shop_name;
  final String demail;
  final String cnic;
  final String address;
  final String city;
  final String coordinates;

  final String shop_size;
  final String floor;
  final String owned;

  final String covered_sale;
  final String uncovered_sale;
  final String total_sale;

  final String credit_limit;

  final String companies_working_with;
  final String working_with_us;

  final String our_brands;

  final String contact_no_1;
  final String contact_no_2;
  final String password;

  final String password_confirmation;
  final String added_by;
  final String avatar;
  final String width;
  final String depth;
  final String dst_code;
  final String zone;
  final String designation;

  const EditDistributor({
    Key? key,
    required this.id,
    required this.email,
    required this.name,
    required this.status,
    required this.lanlat,
    required this.zone,
    required this.designation,
    required this.ddistributor_type,
    required this.dname,
    required this.shop_name,
    required this.demail,
    required this.cnic,
    required this.address,
    required this.city,
    required this.coordinates,
    required this.shop_size,
    required this.floor,
    required this.owned,
    required this.covered_sale,
    required this.uncovered_sale,
    required this.total_sale,
    required this.credit_limit,
    required this.companies_working_with,
    required this.working_with_us,
    required this.our_brands,
    required this.contact_no_1,
    required this.contact_no_2,
    required this.password,
    required this.password_confirmation,
    required this.added_by,
    required this.avatar,
    required this.did,
    required this.depth,
    required this.width,

    required this.dst_code,
  }) : super(key: key);

  @override
  _editDistributorState createState() => _editDistributorState();
}

class Brands {
  final int id;
  final String name;

  Brands({
    required this.id,
    required this.name,
  });
}

class _editDistributorState extends State<EditDistributor> {
  ReceivePort port = ReceivePort();
  LocationDto? lastLocation;
  int imagecount = 0;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  String _value = "";
  String _value_brand = "";
  List<String> selected = [];
  late List<String> _cityitems;
List<String> _valueCompanies =[];

  late String _name;
  late String _contact;
  late String _email;
  File? _image;
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  bool checkInternet = false;
  late bool v1 = false;
  late bool v2 = false;
  late bool v3 = false;
  late bool v4 = false;

  String assertiveURL =
     "";
  late int value_type;
  late String stringDistributorValueType="";
  bool ownedCheck = false;
  bool workingCheck = false;
  late  LatLng currentPostion=LatLng(0,0);

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

  Position? position;
  late ProgressDialog pr;

  LatLng currentLocation = LatLng(0, 0);

 List<String> _brands = [
    ( "Al Khair Foam"),
    ( "I Foam"),
    ("Araamco"),
    ("Foamage"),
    ("SereneFoam"),
  ];

  //listDist.add(item['name']);



  Future<File> downloadAndSaveImage(String url) async {
    final cacheManager = CacheManager(Config("mycache"));
    final file = await cacheManager.getSingleFile(url);
    return file;
  }



  List<String> _selectedBrands = [];

  Future getGalleryImage() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image as File;
      Navigator.pop(context);
    });
  }
  int validateMobile(String value) {
    String pattern = r'(^(?:[0-9]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 0;
    }
    else if (value.length==10) {
      return 1;
    }
    return 0;
  }


  Future<void> getValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
  }

  //============================== Image from gallery
  Future getCameraImage() async {
    final ImagePicker _picker = ImagePicker();

    final File? image = (await _picker.pickImage(
      source: ImageSource.camera,
    )) as File?;
    setState(() {
      _image = image;
      Navigator.pop(context);
    });
  }
  //============================== Image from gallery

  //============================== Show from gallery
  Future<void> _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      _distributorCoordinatesController.text = currentPostion.latitude.toString() + "," + currentPostion.longitude.toString();
    });
  }

  void _resetState() {
    setState(() {
      pr.hide();
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
      ValueBrandParam,
      id,
      bool valueCheck2,
      bool valueCheck,
      List<XFile>? attachments,
      int valueType,
      String did,
      String width,
      depth) async {
    attachments?.forEach((element) {

    });
    initConnectivity();

    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    coordinates =
        position.latitude.toString() + "," + position.longitude.toString();

    SharedPreferences preferences = await SharedPreferences.getInstance();



    id = await preferences.getString("id").toString();




    Map<String, String> data = {
      'distributor_type': valueType.toString(),
      'name': distributor,
      'shop_name': shop,
      'email': email,
      'cnic': cnic,
      'address': address,
      'city': city,
      'coordinates': coordinates.toString(),
      'added_by': id.toString(),
      'shop_size': shopsize,
      'width': width,
      'depth': depth,
      'floor': floor,
      'owned': valueCheck == true ? "1" : "0",
      'covered_sale': sale,
      'uncovered_sale': usales,
      'total_sale': totalSales,
      'credit_limit': card,
      'companies_working_with': companies,
      'working_with_us': valueCheck2 == true ? "1" : "0",
      "our_brands": ValueBrandParam,
      'contact_no_1': contactNo,
      'contact_no_2': contactt,
      'password': "000000",
      "password_confirmation": "000000",
      'added_by': id,
      'dst_code': did
    };


    http.MultipartRequest request = http.MultipartRequest("POST",
        Uri.parse(base_Url + "api/v1/agent/UpdateDistributor"));

    Map<String, String> headers = {"Content-Type": "application/json"};

    int x = 0;
    for (var i=0;i< attachments!.length;i++) {

      if (attachments[i]!.path.contains("http")) {

        final file1 = await downloadAndSaveImage(attachments[i].path)!;



        // final http.Response responseData =
        //     await http.get(Uri.parse(assertiveURL + element.path));
        // Uint8List uint8list = responseData.bodyBytes;
        //
        // uint8list = responseData.bodyBytes;
        // var buffer = uint8list.buffer;
        // ByteData byteData = ByteData.view(buffer);
        // var tempDir = await getTemporaryDirectory();
        // File file1 = await File('${tempDir.path}/img' + x.toString())
        //     .writeAsBytes(buffer.asUint8List(
        //         byteData.offsetInBytes, byteData.lengthInBytes));






        try {
          request.files
              .add(await http.MultipartFile.fromPath('avatar[]', file1.path));
        } catch (e) { print(e);}
      } else {
        try {
      request.files
              .add(await http.MultipartFile.fromPath('avatar[]', attachments[i]!.path));
        } catch (e) {print(e);}
      }
    }


    request.headers.addAll(headers);
    request.fields.addAll(data);

   // pr.show();

    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();


    if (response.statusCode == 200) {
      // success
      if (pr.isShowing()) {
        pr.hide();
      }
      final decodedMap = json.decode(respStr);

      try {

        showAlertDialog(context, "Alert", decodedMap['message'],0,pr);


        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BoardView()));



      } catch (e) {
        print(e);
      }
    } else {
      if (pr.isShowing()) {
        pr.hide();
      }

      // error
      showAlertDialog(context, "Alert", "Customer Cannot be Edited!",0,pr);
    }

    return true;
  }

  ///  ===================== internet check ===================================

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  var typesDist = <String>['Distributor', 'Dealer', 'Retailer'];

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

   // _distributorCoordinatesController.text = currentPostion.latitude.toString() +
     //   "," +
       // currentPostion.longitude.toString();

    _distributorNameController.text = widget.dname;
    _distributorShopNameController.text = widget.shop_name;
    _distributorEmailController.text = widget.demail;
    _distributorCNICController.text = widget.cnic;
    _distributorContactNumController.text = widget.contact_no_1;

    _distributorAddressController.text = widget.address;

    _value = widget.city;

   // _distributorCoordinatesController.text = widget.coordinates;

    _distributorCompaniesController.text = widget.companies_working_with;
    _distributorCardLimitController.text = widget.credit_limit;
    _distributorTotalSaleController.text = widget.total_sale;
    _distributorUSaleController.text = widget.uncovered_sale;

    _distributorFloorController.text = widget.floor;
    _distributorSaleController.text = widget.covered_sale;
    _distributorContactTController.text = widget.contact_no_2;
    _value_brand = widget.our_brands;
    final splitNames= widget.our_brands.split(',');
    for (int i = 0; i < splitNames.length; i++){
      _valueCompanies.add(splitNames[i]);
    }

    _distributorShopSizeControllerw.text = widget.width;
    _distributorShopSizeController.text = widget.depth;

    value_type = 0;
    if(widget.ddistributor_type == 'Retailer')
      {
        value_type = 2;

      }
    else if (widget.ddistributor_type == 'Dealer'){
      value_type =1;
    }
    else{
      value_type = 0;
    }

    stringDistributorValueType = widget.ddistributor_type;

    var spBrand = widget.our_brands.split(",");
    var spImage = widget.avatar.split(",");



    try {
      fileOne = XFile(assertiveURL + spImage[0].trim());
      fileTwo = XFile(assertiveURL + spImage[1].trim());
      fileThree = XFile(assertiveURL + spImage[2].trim());
      print(fileOne);
      print(fileTwo);
      print(fileThree);
      print(spImage[0]);
      print(spImage[1]);
      print(spImage[2]);

    } catch (e) {
      print(e);
    }

    if (spBrand.length < 1) {
      fileOne = XFile(assertiveURL + spImage[0]);
    }





    if (value_check_2 = widget.working_with_us == "1") {
      v1 = true;
v2 =false;

      workingCheck =true;
    } else {
      v1 = false;
      v2=true;
      workingCheck =false;
    }

    if (value_check = widget.owned == "1") {
      v3 = true;
      v4=false;
      ownedCheck=true;
    } else {
      v4 = true;
      v3=false;

      ownedCheck =false;

    }

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

  bool _fieldValidator = false;
  String _errorMessage = '';
  String _errorFieldMessage = '';
  bool _emailValidator = true;
  bool _passwordValidator = true;


  int validateField(String val) {
    if(val.isEmpty){
      setState(() {
        _errorFieldMessage = "";
        _fieldValidator = false;


      });
      return 0;

    }
    else
    {    setState(() {
      _errorFieldMessage = "";
      _fieldValidator = true;


    });
    return 1;

    }
    return 0;
  }



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
                        ? fileOne!.path.contains("http:") == true
                            ? Image.network(fileOne!.path)
                            : Image.file(
                                File(fileOne!.path),
                                fit: BoxFit.fill,
                              )
                        : Image.network(fileOne!.path),
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
                        ? fileTwo!.path.contains("http:") == true
                            ? Image.network(fileTwo!.path)
                            : Image.file(
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
                        ? fileThree!.path.contains("http:") == true
                            ? Image.network(fileThree!.path)
                            : Image.file(
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
                   // pr.show();
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
  bool value_check = false;
  bool value_check_2 = false;
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

    return FutureBuilder(
        future: Future.wait([getValues()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          return Scaffold(
              key: _scaffoldKey,
              drawer: NavBar(
                  status: widget.status,
                  id: widget.id,
                  email: widget.email,
                  name: widget.name,
                  latlng: latlng,
                  zone: widget.zone,
                  designation: widget.designation),
              resizeToAvoidBottomInset: true,
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
                              onChanged: (value)
                              {

                                validateField(value);

                              },


                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: _distributorEmailController,
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                  icon: Icon(Icons.email),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(55, 75, 167, 1)))),

                              onChanged: (value)
                              {

                                validateField(value);

                              },


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

                              onChanged: (value)
                              {

                                validateField(value);

                              },



                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(10),
                              ],
                              maxLength: 10,
                              maxLengthEnforcement:      MaxLengthEnforcement.enforced,

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
                              onChanged: (value)
                              {

                                validateField(value);

                              },



                            ),
                            SizedBox(height: 20.0),
                            Visibility(visible: true, child:TextField(

                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(10),
                              ],
                              maxLengthEnforcement:MaxLengthEnforcement.enforced,
                              maxLength: 10,
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

                              onChanged: (value)
                              {

                                validateField(value);

                              },



                            ),),

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

                              onChanged: (value)
                              {

                                validateField(value);

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

                           selectedItem: _value,

                                onChanged: (value) => setState(() {

                                  _value = value!;


                                    validateField(value);





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


                              items: typesDist.map((String value) {
                                return DropdownMenuItem<String>(

                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  value_type = typesDist.indexOf(value!);
                                  stringDistributorValueType = value;
                                });

                              },

                              value:  typesDist[value_type] ?? null,

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
                                  'Working with Us (Yes/No) ',
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ), //Text

                                Checkbox(
                                  value: v1,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      this.value_check_2 = value!;
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
                                      this.value_check_2 = value!;
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
                                    child: DropdownSearch<String>.multiSelection(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      selectedItems: _valueCompanies,

                                      dropdownSearchDecoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          labelText: 'Brands *',
                                          labelStyle: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),

                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(55, 75, 167, 1)))),

                                      items: _brands,


    onChanged: (value) => setState(() {
      _selectedBrands = value;

    })



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
                                      this.value_check = value!;
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
                                      this.value_check = value!;

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
                                  child: Text('Shop Size',
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

                                    onPressed: () async {


                                 await    _getUserLocation();


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
                                elevation: 7.0,
                                child: InkWell(
                                  onTap: () {
                                    _getUserLocation();


                                    int x = 1;
                                    x =  x * validateField(_distributorShopSizeController.text);


                                    x = x * validateField(_distributorShopNameController.text);


                                    x = x * validateField(_distributorSaleController.text);



                                    x = x *  validateField(_distributorNameController.text);


                                    x = x *     validateField(_distributorShopNameController.text);



                                    x = x *      validateField(_distributorContactNumController.text);


                                    x = x *     validateField(_distributorAddressController.text,);


                                    x = x *      validateField(  _distributorUSaleController.text      );


                                    x = x *    validateField(  _distributorFloorController.text      );


                                    x = x *     validateField(  _distributorTotalSaleController.text      );


                                    x = x *   validateField(  _distributorCardLimitController.text      );



                                    x = x *   validateField(  _distributorShopSizeControllerw.text      );


                                    x = x * validateMobile(_distributorContactNumController.text);


                                    x = x *
                                        validateField(
                                            _distributorCompaniesController
                                                .text);


                                    x = x* validateField(_value);


                                    if (x == 0) {
                                      showAlertDialog(
                                          context, "Alert", "Field Missing", x,pr);
                                      return;
                                    }
                                    else {
                                      List dataList = CitiesJson["data"]["list"];
                                      var valueSizeShop =
                                          _distributorShopSizeController.text +
                                              "," +
                                              _distributorShopSizeControllerw
                                                  .text;

                                      try {
                                      _imageFileList![0] =
                                      (fileOne?.path != "assets/noimage.png"
                                          ? fileOne
                                          : XFile("abc def"))!;
                                      _imageFileList![1] =
                                      (fileTwo?.path != "assets/noimage.png"
                                          ? fileTwo
                                          : XFile("abc def"))!;
                                      _imageFileList![2] =
                                      (fileThree?.path != "assets/noimage.png"
                                          ? fileThree
                                          : XFile("abc def"))!;
                                      _value_brand = "";

                                      _selectedBrands.forEach((element) {
                                        _value_brand +=
                                            element.toString() + ",";
                                      });

          } catch (e) {
          showAlertDialog(context, "Alert",
          "Image not found", 0,pr);
          return;
          }




                                      submit(
                                          _distributorNameController.text,
                                          _distributorShopNameController.text,
                                          _distributorEmailController.text,
                                          _distributorCNICController.text,
                                          _distributorContactNumController
                                              .text,
                                          _distributorAddressController.text,
                                          _value,
                                          _distributorCoordinatesController
                                              .text,
                                          _distributorCompaniesController
                                              .text,
                                          _distributorCardLimitController
                                              .text,
                                          _distributorTotalSaleController
                                              .text,
                                          _distributorUSaleController.text,
                                          valueSizeShop.toString(),
                                          _distributorFloorController.text,
                                          _distributorSaleController.text,
                                          _distributorContactTController.text,
                                          _value_brand,
                                          widget.id,
                                          workingCheck,
                                          ownedCheck,
                                          _imageFileList,
                                          value_type,
                                          widget.dst_code,
                                          _distributorShopSizeControllerw.text,
                                          _distributorShopSizeController.text)
                                          .then((value) {
                                        setState(() {
                                          saveAdress = value;
                                          _selectedBrands = [];
                                          _value_brand = "";
                                        });
                                      });


_value_brand = "";

                                    _selectedBrands = [];
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
