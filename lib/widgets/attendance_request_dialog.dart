import 'package:baniadam/screens/employee/camera_view.dart';
import 'package:baniadam/screens/employee/leave_requests_for_employee.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:baniadam/screens/dashboard.dart';
import 'package:intl/intl.dart';
import '../data_provider/api_service.dart';
import 'package:toast/toast.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:camera/camera.dart';
import 'apply_attendence_dialog.dart';
import 'package:dio/dio.dart';

class AttendanceRequestDialogPage extends StatefulWidget {
  final userId;
  final userName;
  final currentUserRole;
  final bool employeeMenu;

  AttendanceRequestDialogPage({
    this.userId,
    this.userName,
    this.currentUserRole,
    this.employeeMenu,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AttendanceRequestDialogPageState();
  }
}

class _AttendanceRequestDialogPageState
    extends BaseState<AttendanceRequestDialogPage> {
  bool editable = false;
  bool disableButton = false;
  bool isApplied = false;
  final format = DateFormat('yyyy-MM-dd');
  DateTime today;
  String formattedDate;

  TimeOfDay _time = TimeOfDay.fromDateTime(DateTime.now());
  static const menuItems = <String>['in', 'out'];

  Map<String, dynamic> reasonData;
  Map<int, dynamic> _reasons;
  int selectedValue;

  @override
  void initState() {
    today = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(today);
    reasonData = Map();
    _reasons = new Map();
    _getRequestReasons();
    super.initState();
  }

  void _getRequestReasons() async {
    reasonData = await ApiService.getAttendanceRequestReasons();
    debugPrint(reasonData['attributes'].toString());
    if (reasonData != null) {
      setState(() {
//        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < reasonData['attributes'].length; i++) {
          _reasons[reasonData['attributes'][i]['id']] =
              reasonData['attributes'][i]['value'];
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

  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  int flagType;

  void handleRadioValue(int value) {
    setState(() {
      flagType = value;
    });
  }

  Widget _alertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
          child: Column(
        children: <Widget>[
          Center(
            child: Text(
              'New attendance Request',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text(
              formattedDate.toString(),
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      )
//        child: Center(
//          child: Text(
//            'New attendance Request',
//            style: TextStyle(fontSize: 20.0),
//          ),
//        ),
          ),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 240.0,
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio<int>(
                          activeColor: Theme.of(context).primaryColorDark,
                          value: 0,
                          groupValue: flagType,
                          onChanged: handleRadioValue,
                        ),
                        Text('First IN'),
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Radio<int>(
                          activeColor: Theme.of(context).primaryColorDark,
                          value: 1,
                          groupValue: flagType,
                          onChanged: handleRadioValue,
                        ),
                        Text('Last OUT'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20.0,
              ),
//              ListTile(
//                title: Text('Choose flag: '),
//                trailing: DropdownButton<String>(
//                  value:_selectedFlag,
//                  hint:Text('choose'),
//                  onChanged: (String newValue){
//                    setState(() {
//                      _selectedFlag = newValue;
//                    });
//                  },
//                  items: _dropDownMenuItems,
//                ),
//              ),
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.timer),
                      onPressed: () {
                        selectTime(context);
                      },
                    ),
                    Container(
                        width: 80.0,
//                    child: Text(picked.hour.toString() + ':' + picked.minute.toString() ),
                        child: Text(_time.format(context))),
                  ],
                ),
              ),

              SizedBox(
                height: 30.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: 100.0,
                          height: 35.0,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colors.grey.shade500),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
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
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        onTap: () async {
                          FormData data;
//                          if (selectedValue != null) {
//                            data = new FormData.from({
//                              'did': '10',
//                              'time': _time.hour.toString() +
//                                  ":" +
//                                  _time.minute.toString(),
//                              'request_reason':
//                              selectedValue.toString(),
//                            });
//                          } else {
//                            data = new FormData.from({
//                              'did': '10',
//                              'time': _time.hour.toString() +
//                                  ":" +
//                                  _time.minute.toString(),
//                            });
//                          }
                          if (selectedValue != null) {
                            Map<String,dynamic>  mapData = Map();
                            mapData.putIfAbsent('did', () => '10');
                            mapData.putIfAbsent('time', () => _time.hour.toString() + ":" + _time.minute.toString());
                            mapData.putIfAbsent('request_reason', () => selectedValue.toString());
                            data = new FormData.fromMap(mapData);
                          } else {
                            Map<String,dynamic>  mapData = Map();
                            mapData.putIfAbsent('did', () => '10');
                            mapData.putIfAbsent('time', () => _time.hour.toString() + ":" + _time.minute.toString());
                            data = new FormData.fromMap(mapData);
                          }
                          Map<String, dynamic> successinformation;
                          if (flagType == 0) {
                            successinformation =
                                await ApiService.manualAttendanceRequestIn(
                                    data);
                          } else {
                            successinformation =
                                await ApiService.manualAttendanceRequestOut(
                                    data);
                          }
                          if (successinformation['message'] != null) {
                            Toast.show(successinformation['message'], context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardPage(
                                        currentUserRole:
                                            widget.currentUserRole,employeeMenu:widget.employeeMenu)));
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage(currentUserRole:
                                  widget.currentUserRole,employeeMenu:widget.employeeMenu)),
                            );
                            Toast.show('Please try again!!!', context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          }

                          if (successinformation == null) {
                            setState(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => DashboardPage(currentUserRole:
                                      widget.currentUserRole,employeeMenu:widget.employeeMenu)),
                                  (Route<dynamic> route) => false);
                              Toast.show('Please try again!!!', context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            });
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyForAttendance(BuildContext context, String currentUserRole) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;

    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                camera: firstCamera,
                userName: widget.userName,
                currentUserRole: currentUserRole,
                selectedFlag: flagType)));
  }

  @override
  Widget build(BuildContext context) {
    return _alertDialog(context);
  }

  void _manualAttendanceRequest(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;

    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                camera: firstCamera,
                userId: widget.userId,
                userName: widget.userName,
                currentUserRole: widget.currentUserRole,
                isManualRequest: true,
                selectedFlag: flagType,
                time: _time.hour.toString() + ":" + _time.minute.toString())));
  }

  Widget _confirmRequestDialog(BuildContext context, String leaveModeShift) {
    return isApplied
        ? AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            content: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            contentPadding: EdgeInsets.all(15.0),
            title: Center(child: Text('Confirm request')),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Do you want to request for attendance?'),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: 100.0,
                          height: 35.0,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colors.grey.shade500),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            'No',
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
                          width: 90.0,
                          height: 35.0,
                          decoration: ShapeDecoration(
                            color: !disableButton
                                ? Theme.of(context).buttonColor
                                : Colors.grey,
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
                            'YES',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        onTap: disableButton
                            ? null
                            : () async {
                                _manualAttendanceRequest(context);
                              },
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }
}
