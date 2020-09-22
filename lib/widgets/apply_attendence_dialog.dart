import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:baniadam/screens/employee/camera_view.dart';
import 'package:location/location.dart';
import '../data_provider/api_service.dart';
import 'package:dio/dio.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:camera/camera.dart';

class AttendenceConfirmationDialog extends StatefulWidget {
  final String currentUserRole;
  final String uId;
  final String userName;
  final String flag;

//  final String imagePath;
//  final camera;

  AttendenceConfirmationDialog({
    this.currentUserRole,
    this.uId,
    this.userName,
    this.flag,
//    this.imagePath,
//    this.camera,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AttendenceConfirmationDialogState();
  }
}

class _AttendenceConfirmationDialogState
    extends BaseState<AttendenceConfirmationDialog> {
  Map<String, dynamic> data;
  Map<int, dynamic> _reasons;
  int selectedValue;
  String _fileName;
  var _filePath;

//  List<int> _reasonId;
//  List<String> _reasonValue;

  @override
  void initState() {
    print(widget.uId);
    data = Map();
    _reasons = new Map();
    super.initState();
    _getRequestReasons();
//    initPlatformState();
    print(_currentLocation);
//    print(widget.imagePath);
  }

  StreamSubscription<LocationData> _locationSubscription;
  LocationData _currentLocation;
  Location _locationService = new Location();
  bool _permission = false;
  String error;
  bool currentWidget = true;

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }
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

  void _getRequestReasons() async {
    data = await ApiService.getAttendanceRequestReasons();
    debugPrint(data['attributes'].toString());
    if (data != null) {
      setState(() {
//        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < data['attributes'].length; i++) {
          _reasons[data['attributes'][i]['id']] =
              data['attributes'][i]['value'];
        }
      });
    }
  }

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

//  void _applyforAttendence(String uid,String did,String lat,String lng,String flag,String reason) async {
//    final Map<String, dynamic> responseData =
//    await ApiService.attendanceRequest(uid,did,lat,lng,flag,reason);
//
//    if (responseData != null) {
//      String flag = responseData['flag'];
//      Navigator.of(context).pop(flag);
//    }
//  }

  void _applyForAttendance(BuildContext context, FormData data, String currentUserRole) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;

    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                camera: firstCamera, data: data, userName: widget.userName,currentUserRole:currentUserRole)));

//    final Map<String, dynamic> successinformation =
//        await ApiService.attendanceRequest(data);
//
//    String flag;
//    if (successinformation['success']) {
//      setState(() {
//        flag = successinformation['message'];
//      });
//    }
//    Navigator.of(context).pop(flag);
  }

  _reasonField() {
    return FormField<String>(
      validator: (value) {
        if (value == null) {
          return "Select your area";
        }
      },
//      onSaved: (value) {
//        formData['town'] = value;
//      },
      builder: (
        FormFieldState<String> state,
      ) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new InputDecorator(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0.0),
                labelText: 'Area',
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: new Text("Select Town"),
                  value: selectedValue.toString(),
                  onChanged: (String newValue) {
                    state.didChange(newValue);
                    setState(() {
                      newValue = selectedValue.toString();
                    });
                  },
                  items: _menuItems(_reasons),
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              state.hasError ? state.errorText : '',
              style:
                  TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(5.0),
        title: Center(
            child: Text(
          'Attendance confirmation',
          style: TextStyle(fontSize: 20.0),
        )),
        content: SingleChildScrollView(
            child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Do you want to give your attendance now?'),
//                  Container(
//                    child: Center(child: Text('Create attendance request?')),
//                  ),
                  SizedBox(
                    height: 10.0,
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
//                  Container(
//                    padding: EdgeInsets.only(left: 15.0,bottom: 10.0),
//                    child: Text('* required fields',style: TextStyle(color: Colors.red,fontSize: 12.0),),
//                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
//                      RaisedButton(
//                        color: Theme.of(context).buttonColor,
//                        child: Text(
//                          'Cancel',
//                          style: TextStyle(color: Colors.white),
//                        ),
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                      ),


//                      RaisedButton(
//                        color: Theme.of(context).buttonColor,
//                        child: Text(
//                          'Proceed',
//                          style: TextStyle(color: Colors.white),
//                        ),
//                        onPressed: () async {
//                          if (selectedValue == null) {
//                            FormData data = new FormData.from({
//                              'did': '10',
//                            });
//                            _applyForAttendance(context, data);
//                          } else {
//                            FormData data = new FormData.from({
//                              'did': '10',
//                              'request_reason': selectedValue.toString(),
//                            });
//                            _applyForAttendance(context, data);
//                          }
//                        },
//                      ),

                      InkWell(
                        child: Container(
                          width: 100.0,
                          height: 35.0,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                              borderRadius: BorderRadius.all(Radius.circular(3.0)),
                            ),
                          ),
                          child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark),
                              )),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: 100.0,
                          height: 35.0,
                          decoration: ShapeDecoration(
                            color: Theme.of(context).buttonColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colors.grey.shade500),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            'Proceed',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        onTap: () async {
//                          if (selectedValue == null) {
//                            FormData data = new FormData.from({
//                              'did': '10',
//                            });
//                            _applyForAttendance(context, data,widget.currentUserRole);
//                          } else {
//                            FormData data = new FormData.from({
//                              'did': '10',
//                              'request_reason': selectedValue.toString(),
//                            });
//                            _applyForAttendance(context, data,widget.currentUserRole);
//                          }

                          if (selectedValue == null) {
                            Map<String,dynamic>  mapData = Map();
                            mapData.putIfAbsent('did', () => '10');
                            FormData data = new FormData.fromMap(mapData);
                            _applyForAttendance(context, data,widget.currentUserRole);
                          } else {
                            Map<String,dynamic>  mapData = Map();
                            mapData.putIfAbsent('did', () => '10');
                            mapData.putIfAbsent('request_reason', () => selectedValue.toString());
                            FormData data = new FormData.fromMap(mapData);
                            _applyForAttendance(context, data,widget.currentUserRole);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ],
          ),
        ))
        // _filterOptions(context),
        );
  }
}
