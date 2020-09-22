import 'dart:async';
import 'dart:io';
import 'package:baniadam/widgets/base_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/screens/dashboard.dart';
import 'package:baniadam/widgets/apply_attendence_dialog.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:toast/toast.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class TakePictureScreen extends StatefulWidget {
  final user;
  final userId;
  final CameraDescription camera;
  final FormData data;
  final String userName;
  final String currentUserRole;
  final bool isManualRequest;
  final String time;
  final int selectedFlag;

//  final empId;
  const TakePictureScreen(
      {Key key,
      this.user,
      this.userId,
      @required this.camera,
      this.data,
      this.userName,
      this.currentUserRole,
      this.isManualRequest,
      this.time,
      this.selectedFlag})
      : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends BaseState<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  DateTime now;
  String _timeString;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.low,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

//    _timeString =
//        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
//    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
//    now = DateTime.now();
  }

  void _getCurrentTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 4 / 5,
                    child: CameraPreview(_controller)),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .5 / 5,
                    child: Center(
                      child: Text(
                        'Take selfie',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 25.0),
                      ),
                    )),
//                Container(
//                    child: Column(
//                  children: <Widget>[
//                    Text('Current Time:'),
//                    Text(
//                      _timeString,
//                      style: TextStyle(fontSize: 30),
//                    ),
//                  ],
//                )),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  child: Container(
                    width: 100.0,
                    height: 30.0,
                    child: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Align(
              alignment: Alignment.topCenter,
//                child:InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width * 9 / 10,
                height: MediaQuery.of(context).size.height * 7 / 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3.0,
                      color: Colors.grey,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                heroTag: "btn22",
                backgroundColor: Colors.grey,
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    final path = join(
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now()}.png',
                    );
                    await _controller.takePicture(path);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            user: widget.user,
                            userId: widget.userId,
                            imagePath: path,
                            data: widget.data,
                            userName: widget.userName,
                            currentUserRole: widget.currentUserRole,
                            isManualRequest: widget.isManualRequest,
                            time: widget.time,
                            selectedFlag: widget.selectedFlag,
                          ),
                        ));
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute<dynamic>(
//                        builder: (context) => DisplayPictureScreen(
//                            user: widget.user,
//                            userId: widget.userId,
//                            imagePath: path,
//                            data: widget.data,
//                            userName: widget.userName,
//                            currentUserRole: widget.currentUserRole,
//                            isManualRequest : widget.isManualRequest,
//                            time:widget.time,
//                        ),
//                      ),
//                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final user;
  final userId;
  final String imagePath;
  final FormData data;
  final String userName;
  final String currentUserRole;
  final bool isManualRequest;
  final String time;
  final int selectedFlag;

  const DisplayPictureScreen(
      {Key key,
      this.user,
      this.userId,
      this.userName,
      this.imagePath,
      this.data,
      this.currentUserRole,
      this.isManualRequest,
      this.time,
      this.selectedFlag})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends BaseState<DisplayPictureScreen> {
  String currentAttendanceFlag;
  FormData data;
  FormData selfieData;
  String img;
  File file;
  bool _processImage = false;

  StreamSubscription<LocationData> _locationSubscription;
  LocationData _currentLocation;
  Location _locationService = new Location();
  bool _permission = false;
  String error;
//  Map<String, dynamic> reasonData;
  List<dynamic> reasonData;
  Map<int, dynamic> _reasons;
  int selectedValue;

//  MediaQueryData queryData;

  @override
  void initState() {
    data = widget.data;
    selfieData = new FormData();
    reasonData = [];
    _reasons = new Map();
    _getRequestReasons();
//    queryData = MediaQuery.of(context);
    super.initState();
//    initPlatformState();
    getImage();
  }

  void _getRequestReasons() async {
    reasonData = await ApiService.getAttendanceRequestReasons1();
    if (reasonData != null) {
      setState(() {
//        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < reasonData.length; i++) {
          _reasons[reasonData[i]['id']] =
              reasonData[i]['value'];
        }
      });
    }
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 100);

    var location = new Location();
    try {
      _currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      _currentLocation = null;
    }

//    LocationData location;
//    try {
//      bool serviceStatus = await _locationService.serviceEnabled();
//      print("Service status: $serviceStatus");
//      if (serviceStatus) {
//        _permission = await _locationService.requestPermission();
//        print("Permission: $_permission");
//        if (_permission) {
//          location = await _locationService.getLocation();
//
//          _locationSubscription = _locationService
//              .onLocationChanged()
//              .listen((LocationData result) async {
//            if (mounted) {
//              setState(() {
//                _currentLocation = result;
//              });
//            }
//          });
//        }
//      } else {
//        bool serviceStatusResult = await _locationService.requestService();
//        print("Service status activated after request: $serviceStatusResult");
//        if (serviceStatusResult) {
//          initPlatformState();
//        }
//      }
//    } on PlatformException catch (e) {
//      print(e);
//      if (e.code == 'PERMISSION_DENIED') {
//        error = e.message;
//      } else if (e.code == 'SERVICE_STATUS_ERROR') {
//        error = e.message;
//      }
//      location = null;
//    }
  }

  slowRefresh() async {
    _locationSubscription.cancel();
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.BALANCED, interval: 10000);
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {
      if (mounted) {
        setState(() {
          _currentLocation = result;
        });
      }
    });
  }

  Future getImage() async {
    file = await FlutterExifRotation.rotateImage(
      path: widget.imagePath,
    );
    if (file != null) {
      setState(() {
        img = file.path;
      });
    }
//    }
  }

  bool isLocationFound = false;

  List<DropdownMenuItem> _menuItems(Map<dynamic, dynamic> items) {
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((k, v) {
      itemWidgets.add(DropdownMenuItem(
        value: k,
        child: Text(v.toString()),
      ));
    });
    return itemWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return
      !_processImage ?
      Scaffold(
            appBar: AppBar(
              title: Text('Confirm attendance'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashboardPage(currentUserRole: widget.currentUserRole))),
              ),
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
//                    Expanded(
//                        flex: 4,
//                        child: Column(
//                          children: <Widget>[
//              Container(
//                height: MediaQuery.of(context).size.height * 1 / 10,
//                child: Center(
//                  child: Text(
//                    'Confirm attendance',
//                    style: Theme.of(context).textTheme.title,
//                  ),
//                ),
//              ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
//                      decoration: BoxDecoration(
//                        border: Border.all(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
//                      ),
                      height: MediaQuery.of(context).size.height * 4 / 10,
                      child: Center(
                        child: Image.file(File(widget.imagePath)),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 1.5 / 10,
                      width: MediaQuery.of(context).size.width * 3 / 5,
                      child: Center(
                        child: Text(
                          widget.userName,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 30.0),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
//                      Text('Reason :'),
//                      _reasonField(),
                        DropdownButton(
                          hint: Text(
                            'Select reason (optional)',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          // Not necessary for Option 1
                          value: selectedValue,
                          elevation: 3,
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue = newValue;
                              print(selectedValue.toString());
                            });
                          },
                          items: _menuItems(_reasons),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 4 / 5,
                        height: MediaQuery.of(context).size.height * .8 / 10,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(3, 3))
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Material(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Theme.of(context).buttonColor,
                            child: InkWell(
                                onTap: _processImage
                                    ? null
                                    : () async {
                                        await initPlatformState();
                                        if (_currentLocation == null) {
                                          Toast.show(
                                              'Please turn on gps location and try again',
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.BOTTOM);
                                        } else {
                                          setState(() {
                                            _processImage = true;
                                          });
                                          slowRefresh();
                                          FormData data;
                                          if (selectedValue != null) {
//                                            data = new FormData.from({
//                                              'did': '10',
//                                              'lng': _currentLocation.longitude
//                                                  .toString(),
//                                              'lat': _currentLocation.latitude
//                                                  .toString(),
//                                              'request_reason':
//                                                  selectedValue.toString(),
//                                            });
                                            Map<String,dynamic>  mapData = Map();
                                            mapData.putIfAbsent('did', () => '10');
                                            mapData.putIfAbsent('lng', () => _currentLocation.longitude);
                                            mapData.putIfAbsent('lat', () => _currentLocation.latitude);
                                            mapData.putIfAbsent('request_reason', () => selectedValue.toString());
                                            data = FormData.fromMap(mapData);
                                          } else {
//                                            data = new FormData.from({
//                                              'did': '10',
//                                              'lng': _currentLocation.longitude
//                                                  .toString(),
//                                              'lat': _currentLocation.latitude
//                                                  .toString(),
//                                            });

                                            Map<String,dynamic>  mapData = Map();
                                            mapData.putIfAbsent('did', () => '10');
                                            mapData.putIfAbsent('lng', () => _currentLocation.longitude);
                                            mapData.putIfAbsent('lat', () => _currentLocation.latitude);
                                            data = FormData.fromMap(mapData);
                                          }

                                          final Map<String, dynamic>
                                              successinformation =
                                              await ApiService
                                                  .attendanceRequest(data);
                                          String flag;
                                          if (successinformation['success']) {
                                            var id;
                                            setState(() {
                                              _processImage = false;
                                              flag =
                                                  successinformation['message'];
                                              id = successinformation['id'];
                                            });
//                                            selfieData.add(
//                                              'selfie',
//                                              UploadFileInfo(
//                                                  file, widget.imagePath),
//                                            );
                                            selfieData = FormData.fromMap({"selfie": await MultipartFile.fromFile(file.path,filename:'test'),});
                                            ApiService.updateAttendanceRequest(
                                                id, selfieData);

//                                            Navigator.pushReplacement(
//                                                context,
//                                                MaterialPageRoute(
//                                                    builder: (context) =>
//                                                        DashboardPage(currentUserRole: widget.currentUserRole)));

                                          }
                                          else {
//                                            Navigator.of(context).push(
//                                              MaterialPageRoute(
//                                                  builder: (context) =>
//                                                      DashboardPage(currentUserRole: widget.currentUserRole)),
//                                            );
                                            Toast.show(
                                                'Please try again!!!', context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          }

                                          if (successinformation == null) {
                                            setState(() {
                                              _processImage = false;
                                            });
                                            Toast.show('Please try again!!!',
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                            // Navigator.of(context)
//                                                  .pushAndRemoveUntil(
//                                                      MaterialPageRoute(
//                                                          builder: (context) =>
//                                                              DashboardPage(currentUserRole: widget.currentUserRole)),
//                                                      (Route<dynamic> route) =>
//                                                          false);
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DashboardPage(currentUserRole: widget.currentUserRole,employeeMenu: true,)));
                                        }
                                      },
                                child: Center(
                                  child: Text('Confirm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold)),
                                )))),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2 / 10,
                    ),

                    Container(
                        width: MediaQuery.of(context).size.width * 4 / 5,
                        height: MediaQuery.of(context).size.height * .8 / 10,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
//                              Material(
//                                child: InkWell(
//                                  child: Container(
//                                    width: MediaQuery.of(context).size.width *
//                                        1.9 /
//                                        5,
//                                    decoration: ShapeDecoration(
//                                      color: Theme.of(context).primaryColorDark,
//                                      shape: RoundedRectangleBorder(
//                                        side: BorderSide(
//                                            width: 1.0,
//                                            style: BorderStyle.solid,
//                                            color: Colors.grey.shade500),
//                                        borderRadius: BorderRadius.all(
//                                            Radius.circular(5.0)),
//                                      ),
//                                    ),
//                                    child: Center(
//                                        child: Text(
//                                      'Another selfie',
//                                      style: TextStyle(
//                                          color: Colors.white,
//                                          fontSize: 18.0,
//                                          fontWeight: FontWeight.bold),
//                                    )),
//                                  ),
//                                  onTap: () {
//                                    Navigator.of(context).pop();
//                                  },
//                                ),
//                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width *
                                      1.9 /
                                      5,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 4,
                                          offset: Offset(3, 3))
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Material(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: Theme.of(context).buttonColor,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Center(
                                            child: Text('Another selfie',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )))),

                              Container(
                                  width: MediaQuery.of(context).size.width *
                                      1.9 /
                                      5,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 4,
                                          offset: Offset(3, 3))
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Material(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: Theme.of(context).buttonColor,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardPage(currentUserRole: widget.currentUserRole)));
                                          },
                                          child: Center(
                                            child: Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ))))
                            ])),
                  ],
                )),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Confirm attendance'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardPage(currentUserRole: widget.currentUserRole))),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
