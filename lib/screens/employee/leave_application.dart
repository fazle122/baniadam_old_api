//import 'package:flutter/material.dart';
//import 'package:baniadam/screens/dashboard.dart';
//import 'package:intl/intl.dart';
//import 'package:toast/toast.dart';
//import '../../data_provider/api_service.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:baniadam/widgets/base_state.dart';
//
//class LeaveApplicationPage extends StatefulWidget {
//  var userType;
//
//  LeaveApplicationPage({
//    this.userType,
//    Key key,
//  }) : super(key: key);
//
//  @override
//  _LeaveApplicationPageState createState() => _LeaveApplicationPageState();
//}
//
//class _LeaveApplicationPageState extends BaseState<LeaveApplicationPage> {
//  static const leaveMode = <String>[ 'Full Day','Half Day'];
//  static const leaveModeShift = <String>['First Half', 'Second Half'];
//
//  TextEditingController reasonController;
//  int selectedLeaveType;
//  Map<int, dynamic> _leaveTypes;
//  InputType inputType = InputType.date;
//  bool editable = false;
//  DateTime _from;
//  DateTime _to;
//  final formats = {
//    // InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
//    InputType.date: DateFormat('yyyy-MM-dd'),
//    // InputType.time: DateFormat("HH:mm"),
//  };
//
//  String selectedLeaveMode;
//  String selectedLeaveModeShift;
//  bool modeShift = false;
//
//  @override
//  void initState() {
//    super.initState();
//    reasonController = TextEditingController();
//    _leaveTypes = new Map();
////    _getLeaveTypes();
//  }
//
////  void _getLeaveTypes() async {
////    Map<String, dynamic> data = await ApiService.getLeaveTypesForLeaveApply();
////    debugPrint(data['attributes'].toString());
////    if (data != null) {
////      setState(() {
//////        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
////        for (int i = 0; i < data['attributes'].length; i++) {
////          _leaveTypes[data['attributes'][i]['id']] =
////          data['attributes'][i]['value'];
////        }
////      });
////    }
////  }
//
////  void _getLeaveTypes() async {
////    List<dynamic> data = await ApiService.getLeaveTypes();
//////    debugPrint(data['attributes'].toString());
////    if (data != null) {
////      setState(() {
//////        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
////        for (int i = 0; i < data.length; i++) {
////          _leaveTypes[data[i]['id']] =
////          data[i]['value'];
////        }
////      });
////    }
////  }
//
//  List<DropdownMenuItem> _menuItems(Map<dynamic, dynamic> items) {
//    List<DropdownMenuItem> itemWidgets = List();
//    items.forEach((key, value) {
//      itemWidgets.add(DropdownMenuItem(
////        key: key,
//        value: key,
//        child: Text(value),
//      ));
//    });
//    return itemWidgets;
//  }
//
//  Widget _applyLeaveDialog(BuildContext context, String leaveType,
//      String fromDate, String toDate, String reason,String leaveMode, String leaveModeShift) {
//    return AlertDialog(
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(5.0))),
//        contentPadding: EdgeInsets.all(45.0),
//        title: Center(child: Text('Confirm Request!')),
//        content: SingleChildScrollView(
//          child: Column(
//            children: <Widget>[
//              Text('Please confirm your leave request'),
//              SizedBox(height: 30.0,),
//
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  InkWell(
//                    child: Container(
//                      width: 100.0,
//                      height: 30.0,
//                      color: Colors.white,
//                      child: Center(
//                          child: Text(
//                            'NO',
//                            style: TextStyle(color: Theme.of(context).primaryColor),
//                          )),
//                    ),
//                    onTap: () {
//                      Navigator.of(context).pop();
//                    },
//                  ),
//                  InkWell(
//                    child: Container(
//                      width: 100.0,
//                      height: 30.0,
//                      color: Theme.of(context).primaryColor,
//                      child: Center(
//                          child: Text(
//                            'YES',
//                            style: TextStyle(color: Colors.white),
//                          )),
//                    ),
//                    onTap: () async {
//
////                      Toast.show(loginResponse['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
//
//                      final Map<String, dynamic> data =
//                      await ApiService.leaveRequest(
//                          leaveType, fromDate, toDate, reason,leaveMode,leaveModeShift);
//                      if (data.containsKey('message') && data['message'] != null) {
//                        Toast.show(data['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => DashboardPage()));
//                      }
//
////                      if (data != null) {
////                        Navigator.push(
////                            context,
////                            MaterialPageRoute(
////                                builder: (context) => DashboardPage()));
////                      }
//                    },
//                  ),
//                ],
//              )
//            ],
//          ),
//        ));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('BaniAdam HR'),
//      ),
//      body: SingleChildScrollView(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            Container(
//              padding: const EdgeInsets.only(top: 20.0),
//              child: Center(
//                  child: Text(
//                    'Leave Application',
//                    style: Theme.of(context).textTheme.title,
//                  )),
//            ),
//            SizedBox(
//              height: 10.0,
//            ),
//
//            Column(
//              mainAxisSize: MainAxisSize.max,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                  margin: EdgeInsets.all(3.0),
//                  child: Text('Leave Type',
//                    // 'Select Category',
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold, fontSize: 13.0),
//                  ),
//                ),
//                Container(
////                  width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                  margin: EdgeInsets.all(3.0),
//                  decoration: ShapeDecoration(
//                    shape: RoundedRectangleBorder(
//                      side:
//                      BorderSide(width: 1.0, style: BorderStyle.solid),
//                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    ),
//                  ),
//                  child: DropdownButton(
//                    isExpanded: true,
//                    hint: Text('Select Leave Type'),
//                    value: selectedLeaveType,
//                    onChanged: (newValue) {
//                      setState(() {
//                        selectedLeaveType = newValue;
//                        print(selectedLeaveType);
//                      });
//                    },
//                    items: _menuItems(_leaveTypes),
//                  ),
//                )
//              ],
//            ),
////            Container(
////              width: 350.0,
////              child: Row(
////                mainAxisAlignment: MainAxisAlignment.start,
////                children: <Widget>[
////                  Container(
////                    width: 80.0,
////                    child: Text('Leave Type: '),
////                  ),
////                  SizedBox(
////                    width: 30.0,
////                  ),
////                  DropdownButton(
////                    hint: Text('Select Leave Type'),
////
////                    // Not necessary for Option 1
////                    value: selectedLeaveType,
////                    onChanged: (newValue) {
////                      setState(() {
////                        selectedLeaveType = newValue;
////                        print(selectedLeaveType);
//////                          print(selectedLeaveId.toString());
////                      });
////                    },
////                    items: _menuItems(_leaveTypes),
////                  ),
////                ],
////              ),
////            ),
//            SizedBox(
//              height: 10.0,
//            ),
//            Column(
//              mainAxisSize: MainAxisSize.max,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'Leave Mode',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
////                  width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                  margin: EdgeInsets.all(3.0),
//                  decoration: ShapeDecoration(
//                    shape: RoundedRectangleBorder(
//                      side:
//                      BorderSide(width: 1.0, style: BorderStyle.solid),
//                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    ),
//                  ),
//                  child: DropdownButton<String>(
//                      isExpanded: true,
//                      hint: Text('Select Leave Mode'),
//                      value: selectedLeaveMode,
//                      onChanged: (String newValue) {
//                        setState(() {
//                          selectedLeaveMode = newValue;
//                          print(selectedLeaveMode);
//                          if(selectedLeaveMode == 'Half Day') {
//                            modeShift = true;
//                          }else{
//                            modeShift = false;
//                          }
//                        });
//                      },
//                      items: leaveMode
//                          .map((String value) => DropdownMenuItem<String>(
//                        value: value,
//                        child: Text(value),
//                      ))
//                          .toList()),
//                ),
//              ],
//            ),
//            modeShift == true ? Column(
//              mainAxisSize: MainAxisSize.max,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'Leave Mode Shift',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
////                  width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                  margin: EdgeInsets.all(3.0),
//                  decoration: ShapeDecoration(
//                    shape: RoundedRectangleBorder(
//                      side:
//                      BorderSide(width: 1.0, style: BorderStyle.solid),
//                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    ),
//                  ),
//                  child: DropdownButton<String>(
//                      isExpanded: true,
//                      hint: Text('Select Leave Mode shift'),
//                      value: selectedLeaveModeShift,
//                      onChanged: (String newValue) {
//                        setState(() {
//                          selectedLeaveModeShift = newValue;
//                          print(selectedLeaveModeShift);
//                        });
//                      },
//                      items: leaveModeShift
//                          .map((String value) => DropdownMenuItem<String>(
//                        value: value,
//                        child: Text(value),
//                      ))
//                          .toList()),
//                ),
//              ],
//            ):SizedBox(width: 0.0,height: 0.0,),
//            Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'From Date',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
//                  padding: EdgeInsets.only(left: 3.0, right: 3.0),
//                  child: DateTimePickerFormField(
//
//                    inputType: inputType,
//                    format: formats[inputType],
//                    editable: editable,
//                    decoration: InputDecoration(
//                        labelText: 'From Date',
//                        prefixIcon: Icon(
//                          Icons.date_range,
//                          color: Theme.of(context).primaryColor,
//                        ),
//                        contentPadding:
//                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                        border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(15.0))),
//                    // decoration: InputDecoration(
//                    //     // prefixIcon: Icon(Icons.date_range),
//                    //     labelText: 'From',
//                    //     hasFloatingPlaceholder: false),
//                    onChanged: (dt) {
//                      setState(() {
//                        _from = dt;
//                        print(_from.toString());
//                        _to = dt;
//                      });
//                    },
//                  ),
//                ),
//              ],
//            ),
//            Column(
//                mainAxisSize: MainAxisSize.min,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Container(
//                      margin: EdgeInsets.all(3.0),
//                      child: Text(
//                        'To Date',
//                        // 'Search To',
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, fontSize: 13.0),
//                      )),
//                  Container(
//                    padding: EdgeInsets.only(left: 3.0, right: 3.0),
//                    child: DateTimePickerFormField(
//                      firstDate: _from,
//                      inputType: inputType,
//                      format: formats[inputType],
//                      editable: editable,
//                      decoration: InputDecoration(
//                          labelText: _from != null ? DateFormat('yyyy-MM-dd').format(_from):'To Date',
//                          prefixIcon: Icon(
//                            Icons.date_range,
//                            color: Theme.of(context).primaryColor,
//                          ),
//                          contentPadding:
//                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                          border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(15.0))),
//                      // decoration: InputDecoration(
//                      //     // prefixIcon: Icon(Icons.date_range),
//                      //     labelText: 'From',
//                      //     hasFloatingPlaceholder: false),
//                      onChanged: (dt) => setState(() => _to = dt),
//                    ),
//                  ),
//                ]),
////            Container(
////              width: 350.0,
////              child: Row(
////                mainAxisAlignment: MainAxisAlignment.start,
////                children: <Widget>[
////                  Container(
////                    width: 80.0,
////                    child: Text('From: '),
////                  ),
////                  SizedBox(
////                    width: 30.0,
////                  ),
////                  Container(
////                    width: 150.0,
////                    child: DateTimePickerFormField(
////                      inputType: inputType,
////                      format: formats[inputType],
////                      editable: editable,
////                      decoration: InputDecoration(
////                        hintText: ('from date'),
//////                            prefixIcon: Icon(
//////                              Icons.date_range,color: Theme.of(context).primaryColor,
//////                            ),
//////                            contentPadding:
//////                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
////                      ),
////                      onChanged: (dt) => setState(() => _from = dt),
////                    ),
////                  ),
////                ],
////              ),
////            ),
////            SizedBox(
////              height: 10.0,
////            ),
//
////            Container(
////              width: 350.0,
////              child: Row(
////                mainAxisAlignment: MainAxisAlignment.start,
////                children: <Widget>[
////                  Container(
////                    width: 80.0,
////                    child: Text('To: '),
////                  ),
////                  SizedBox(
////                    width: 30.0,
////                  ),
////                  Container(
////                    width: 150.0,
////                    child: DateTimePickerFormField(
////                      inputType: inputType,
////                      format: formats[inputType],
////                      editable: editable,
////                      decoration: InputDecoration(
////                        hintText: ('to date'),
//////                            prefixIcon: Icon(
//////                              Icons.date_range,color: Theme.of(context).primaryColor,
//////                            ),
//////                            contentPadding:
//////                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
////                      ),
////                      onChanged: (dt) => setState(() => _to = dt),
////                    ),
////                  ),
////                ],
////              ),
////            ),
//
//            SizedBox(
//              height: 10.0,
//            ),
//
//
//            Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text('Leave Reason',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
//                  padding: EdgeInsets.only(left: 3.0, right: 3.0),
//                  child: TextField(
//                    keyboardType: TextInputType.multiline,
//                    maxLines: 2,
//                    controller: reasonController,
//                    decoration: InputDecoration(
//                      prefixIcon: Icon(Icons.keyboard,color: Theme.of(context).primaryColor,),
//                      labelText: 'write a reason',
//                      border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(5.0)),
//                    ),
//                  ),
//                )
//              ],
//            ),
////
////            Container(
////              width: 350.0,
////              child: Row(
////                mainAxisAlignment: MainAxisAlignment.start,
////                children: <Widget>[
////                  Container(
////                    width: 80.0,
////                    child: Text('Leave Mode: '),
////                  ),
////                  SizedBox(
////                    width: 30.0,
////                  ),
////                  DropdownButton<String>(
////                      hint: Text('Select Leave Mode'),
////                      value: selectedLeaveMode,
////                      onChanged: (String newValue) {
////                        setState(() {
////                          selectedLeaveMode = newValue;
////                          print(selectedLeaveMode);
////                          if(selectedLeaveMode == 'Half Day') {
////                            modeShift = true;
////                          }else{
////                            modeShift = false;
////                          }
////                        });
////                      },
////                      items: leaveMode
////                          .map((String value) => DropdownMenuItem<String>(
////                        value: value,
////                        child: Text(value),
////                      ))
////                          .toList()),
////                ],
////              ),
////            ),
////            SizedBox(
////              height: 10.0,
////            ),
////            modeShift == true ? Container(
////              width: 350.0,
////              child: Row(
////                mainAxisAlignment: MainAxisAlignment.start,
////                children: <Widget>[
////                  Container(
////                    width: 80.0,
////                    child: Text('Leave Mode Shift: '),
////                  ),
////                  SizedBox(
////                    width: 30.0,
////                  ),
////                  DropdownButton<String>(
//////                      style: Theme.of(context).textTheme.display1,
////                      hint: Text('Select Leave Mode shift'),
////                      value: selectedLeaveModeShift,
////                      onChanged: (String newValue) {
////                        setState(() {
////                          selectedLeaveModeShift = newValue;
////                          print(selectedLeaveModeShift);
////                        });
////                      },
////                      items: leaveModeShift
////                          .map((String value) => DropdownMenuItem<String>(
////                        value: value,
////                        child: Text(value),
////                      ))
////                          .toList()),
////                ],
////              ),
////            ):SizedBox(width: 0.0,height: 0.0,),
////            SizedBox(
////              height: 10.0,
////            ),
////            Container(
////              width: 350.0,
////              child: Row(
////                mainAxisAlignment: MainAxisAlignment.start,
////                children: <Widget>[
////                  Container(
////                    width: 80.0,
////                    child: Text('Reason: '),
////                  ),
////                  SizedBox(
////                    width: 30.0,
////                  ),
////                  Container(
////                    width: 200.0,
////                    child: TextFormField(
////                        keyboardType: TextInputType.multiline,
////                        maxLines: 5,
////                        minLines: 3,
////                        controller: reasonController,
////                        decoration: InputDecoration(
////                          labelText: 'Write leave reasen',
////                          contentPadding:
////                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
////                        )),
////                  ),
////                ],
////              ),
////            ),
//            SizedBox(
//              height: 20.0,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                InkWell(
//                  child: Container(
//                    width: 100.0,
//                    height: 30.0,
//                    color: Colors.white,
//                    child: Center(
//                        child: Text(
//                          'CANCEL',
//                          style: TextStyle(color: Theme.of(context).primaryColor),
//                        )),
//                  ),
//                  onTap: () {
//                    Navigator.of(context).pop();
//                  },
//                ),
//                InkWell(
//                  child: Container(
//                    width: 100.0,
//                    height: 30.0,
//                    color: Theme.of(context).primaryColor,
//                    child: Center(
//                        child: Text(
//                          'APPLY',
//                          style: TextStyle(color: Colors.white),
//                        )),
//                  ),
//                  onTap: () {
//                    if(reasonController.text == null){
//                      Toast.show('Please write down a reason !!!', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
//
//                    }else{
//                      showDialog<Map<String, dynamic>>(
//                        barrierDismissible: false,
//                        context: context,
//                        builder: (BuildContext context) => _applyLeaveDialog(
//                            context,
//                            selectedLeaveType.toString(),
//                            _from.toString(),
//                            _to.toString(),
//                            reasonController.text,
//                            selectedLeaveMode,
//                            selectedLeaveModeShift
//                        ),
//                      );
//                    }
//
//                  },
//                ),
//              ],
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
