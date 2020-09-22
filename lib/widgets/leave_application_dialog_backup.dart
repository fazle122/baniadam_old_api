//import 'package:baniadam/screens/employee/leave_requests_for_employee.dart';
//import 'package:flutter/material.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:baniadam/screens/dashboard.dart';
//import 'package:intl/intl.dart';
//import '../data_provider/api_service.dart';
//import 'package:toast/toast.dart';
//import 'package:baniadam/widgets/base_state.dart';
//
//class LeaveApplicationDialogPage extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _LeaveApplicationDialogPageState();
//  }
//}
//
//class _LeaveApplicationDialogPageState
//    extends BaseState<LeaveApplicationDialogPage> {
//  static const leaveMode = <String>['Full Day', 'Half Day'];
//  static const leaveModeShift = <String>['First Half', 'Second Half'];
//  TextEditingController reasonController;
//  int selectedLeaveType;
//  Map<int, dynamic> _leaveTypes;
//  bool editable = false;
//  DateTime _from;
//  DateTime _to;
//  bool disableButton = false;
//  String selectedLeaveMode;
//  String selectedLeaveModeShift;
//  bool modeShift = false;
//  bool isApplied = false;
//
////  InputType inputType = InputType.date;
////  final formats = {
////    InputType.date: DateFormat('yyyy-MM-dd'),
////  };
//
//  final format = DateFormat('yyyy-MM-dd');
//
//  @override
//  void initState() {
//    reasonController = TextEditingController();
//    _leaveTypes = new Map();
//    _getLeaveTypes();
//    super.initState();
//  }
//
//  void _getLeaveTypes() async {
//    List<dynamic> data = await ApiService.getLeaveTypesForLeaveApply();
////    debugPrint(data['attributes'].toString());
//    if (data != null) {
//      setState(() {
//        for (int i = 0; i < data.length; i++) {
//          _leaveTypes[data[i]['leave_type']['id']] =
//          data[i]['leave_type']['value'];
//        }
//      });
//    }
//  }
//
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
//  Widget _alertDialog(BuildContext context) {
//    return AlertDialog(
//      shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.all(Radius.circular(5.0))),
//      title: Container(
//        child: Center(
//          child: Text(
//            'Leave application',
//            style: TextStyle(fontSize: 20.0),
//          ),
//        ),
//      ),
//      content: SingleChildScrollView(
//        padding: EdgeInsets.all(0.0),
//        child: Column(
////          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.min,
////          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'Leave type *',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
////                      width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                  margin: EdgeInsets.all(3.0),
//                  decoration: ShapeDecoration(
//                    shape: RoundedRectangleBorder(
//                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
//                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    ),
//                  ),
//                  child: DropdownButton(
//                    isExpanded: true,
//                    hint: Text('Select leave type'),
//                    value: selectedLeaveType,
//                    onChanged: (newValue) {
//                      setState(() {
//                        selectedLeaveType = newValue;
////                        selectedLeaveModeShift = '';
//                        print(selectedLeaveType);
////                          print(selectedLeaveId.toString());
//                      });
//                    },
//                    items: _menuItems(_leaveTypes),
//                  ),
//                ),
//              ],
//            ),
//            Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'Leave mode *',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
////                          width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                  margin: EdgeInsets.all(3.0),
//                  decoration: ShapeDecoration(
//                    shape: RoundedRectangleBorder(
//                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
//                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    ),
//                  ),
//                  child: DropdownButton<String>(
//                      isExpanded: true,
//                      hint: Text('Select leave mode'),
//                      value: selectedLeaveMode,
//                      onChanged: (String newValue) {
//                        setState(() {
//                          selectedLeaveMode = newValue;
//                          print(selectedLeaveMode);
//                          if (selectedLeaveMode == 'Half Day') {
//                            modeShift = true;
//                          } else {
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
//            modeShift == true
//                ? Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'Leave mode shift',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
////                          width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                  margin: EdgeInsets.all(3.0),
//                  decoration: ShapeDecoration(
//                    shape: RoundedRectangleBorder(
//                      side: BorderSide(
//                          width: 1.0, style: BorderStyle.solid),
//                      borderRadius:
//                      BorderRadius.all(Radius.circular(5.0)),
//                    ),
//                  ),
//                  child: DropdownButton<String>(
//                      isExpanded: true,
//                      hint: Text('Select leave mode shift'),
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
//            )
//                : SizedBox(
//              width: 0.0,
//              height: 0.0,
//            ),
//            modeShift == true
//                ? Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'Select date',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
//                  child: DateTimeField(
//                    textAlign: TextAlign.center,
//                    format: format,
//                    onChanged: (dt) {
//                      setState(() {
//                        _from = dt;
//                        _to = dt;
//                      });
//                    },
//                    decoration: InputDecoration(
//                        labelText: 'Select date',
//                        prefixIcon: Icon(
//                          Icons.date_range,
//                          color: Theme.of(context).primaryColor,
//                        ),
//                        contentPadding:
//                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                        border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(5.0))),
//                    onShowPicker: (context, currentValue) {
//                      return showDatePicker(
//                          context: context,
//                          firstDate: DateTime(1900),
//                          initialDate: currentValue ?? DateTime.now(),
//                          lastDate: DateTime(2100));
//                    },
//                  ),
//                ),
//              ],
//            )
//                : SizedBox(
//              width: 0.0,
//              height: 0.0,
//            ),
//            modeShift == false
//                ? Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'From date',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
//                  child: DateTimeField(
//                    textAlign: TextAlign.center,
//                    format: format,
//                    onChanged: (dt) {
//                      setState(() {
//                        _from = dt;
////                              _to = dt;
//                        print(_from.toString());
//                      });
//                    },
//                    decoration: InputDecoration(
//                        labelText: 'From date',
//                        prefixIcon: Icon(
//                          Icons.date_range,
//                          color: Theme.of(context).primaryColor,
//                        ),
//                        contentPadding:
//                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                        border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(5.0))),
//                    onShowPicker: (context, currentValue) {
//                      return showDatePicker(
//                          context: context,
//                          firstDate: DateTime(1900),
//                          initialDate: currentValue ?? DateTime.now(),
//                          lastDate: DateTime(2100));
//                    },
//                  ),
//                ),
//              ],
//            )
//                : SizedBox(
//              width: 0.0,
//              height: 0.0,
//            ),
//
//            modeShift == false
//                ? Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'To date',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
//                  child: DateTimeField(
//                    enabled: _from == null ? false:true,
//                    textAlign: TextAlign.center,
//                    format: format,
//                    onChanged: (dt) {
//                      setState(() {
//                        _to = dt;
//                        print(_to.toString());
//                      });
//                    },
//                    decoration: InputDecoration(
//                        labelText: 'To date',
//                        prefixIcon: Icon(
//                          Icons.date_range,
//                          color: Theme.of(context).primaryColor,
//                        ),
//                        contentPadding:
//                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                        border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(5.0))),
//                    onShowPicker: (context, currentValue) {
//                      return showDatePicker(
//                          context: context,
//                          firstDate: _from,
////                          initialDate: currentValue ?? DateTime.now(),
//                          initialDate: _from.compareTo(DateTime.now()) < 1 ? DateTime.now():_from,
//                          lastDate: DateTime(2100));
//                    },
//                  ),
//                ),
//              ],
//            )
//                : SizedBox(
//              width: 0.0,
//              height: 0.0,
//            ),
//
//
//
////            modeShift == false
////                ? Column(
////                    mainAxisSize: MainAxisSize.min,
////                    crossAxisAlignment: CrossAxisAlignment.start,
////                    children: <Widget>[
////                        Container(
////                            margin: EdgeInsets.all(3.0),
////                            child: Text(
////                              'To date',
////                              style: TextStyle(
////                                  fontWeight: FontWeight.bold, fontSize: 13.0),
////                            )),
////                        Container(
////                          child: DateTimeField(
////                            enabled: _from == null ? false:true,
////                            textAlign: TextAlign.center,
////                            format: format,
////                            onChanged: (dt) => setState(() => _to = dt),
////                            decoration: InputDecoration(
////                                labelText: 'To date',
////                                prefixIcon: Icon(
////                                  Icons.date_range,
////                                  color: Theme.of(context).primaryColor,
////                                ),
////                                contentPadding:
////                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
////                                border: OutlineInputBorder(
////                                    borderRadius: BorderRadius.circular(5.0))),
////                            onShowPicker: (context, currentValue) {
////                              return showDatePicker(
////                                  context: context,
////                                  firstDate: _from,
////                                  initialDate: currentValue ?? DateTime.now(),
////                                  lastDate: DateTime(2100));
////                            },
////                          ),
////                        ),
////                      ])
////                : SizedBox(
////                    width: 0.0,
////                    height: 0.0,
////                  ),
//            Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(3.0),
//                    child: Text(
//                      'Leave reason *',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 13.0),
//                    )),
//                Container(
//                  child: TextField(
//                    keyboardType: TextInputType.multiline,
//                    maxLines: 2,
//                    controller: reasonController,
//                    decoration: InputDecoration(
//                      prefixIcon: Icon(
//                        Icons.keyboard,
//                        color: Theme.of(context).primaryColor,
//                      ),
//                      labelText: 'Reason',
//                      border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(5.0)),
//                    ),
//                  ),
//                ),
//                SizedBox(
//                  height: 5.0,
//                ),
//                Container(
//                  child: Text(
//                    '* Required fields',
//                    style: TextStyle(fontSize: 12.0, color: Colors.red),
//                  ),
//                )
//              ],
//            ),
//            SizedBox(
//              height: 30.0,
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    InkWell(
//                      child: Container(
//                        width: 100.0,
//                        height: 30.0,
//                        color: Colors.white,
//                        child: Center(
//                            child: Text(
//                              'Cancel',
//                              style:
//                              TextStyle(color: Theme.of(context).primaryColor),
//                            )),
//                      ),
//                      onTap: () {
//                        Navigator.of(context).pop();
//                      },
//                    ),
//                    InkWell(
//                      child: Container(
//                        width: 100.0,
//                        height: 30.0,
//                        color: Theme.of(context).primaryColor,
//                        child: Center(
//                            child: Text(
//                              'Apply',
//                              style: TextStyle(color: Colors.white),
//                            )),
//                      ),
////                      onTap: (){
////                        var reg = reasonController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
////                        print('reg  -  ' + reg);
////                        print('reg  -  ' + reg.length.toString());
////                        var txt = reasonController.text.trim();
////                        print('txt  -  ' + txt);
////                        print('txt  -  ' + txt.length.toString());
////                      },
//
//                      onTap: () {
//                        if (selectedLeaveType == null ||
//                            selectedLeaveType == '') {
//                          Toast.show('Please select leave type', context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.BOTTOM);
//                        } else if (selectedLeaveMode == null ||
//                            selectedLeaveMode == '') {
//                          Toast.show('Please select leave mode', context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.BOTTOM);
//                        } else if (selectedLeaveMode == 'Half Day' &&
//                            (selectedLeaveModeShift == null ||
//                                selectedLeaveModeShift == '')) {
//                          Toast.show('Please select leave mode shift', context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.BOTTOM);
//                        }else if (selectedLeaveMode == 'Half Day' &&
//                            (_from == null || _from == '')) {
//                          Toast.show('Please choose date', context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.BOTTOM);
//                        } else if (_from == null || _from == '') {
//                          Toast.show('Please choose from date', context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.BOTTOM);
//                        } else if (_to == null || _to == '') {
//                          Toast.show('Please choose to date', context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.BOTTOM);
//                        } else if (reasonController.text == null ||
//                            reasonController.text == '') {
//                          Toast.show('Please write down the reason', context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.BOTTOM);
//                        }
////                        if (reasonController.text == null ||
////                            reasonController.text == "") {
////                          Toast.show('Please write down a reason !!!', context,
////                              duration: Toast.LENGTH_LONG,
////                              gravity: Toast.CENTER);
////                        }
//                        else {
//                          showDialog<Map<String, dynamic>>(
//                            barrierDismissible: false,
//                            context: context,
//                            builder: (BuildContext context) =>
//                                _confirmLeaveDialog(
//                                    context,
//                                    selectedLeaveType.toString(),
//                                    _from.toString(),
//                                    _to.toString(),
//                                    reasonController.text.trim(),
//                                    selectedLeaveMode,
//                                    selectedLeaveModeShift),
//                          );
//                        }
//                      },
//                    ),
//                  ],
//                )
//              ],
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return _alertDialog(context);
//  }
//
//  Widget _confirmLeaveDialog(
//      BuildContext context,
//      String leaveType,
//      String fromDate,
//      String toDate,
//      String reason,
//      String leaveMode,
//      String leaveModeShift) {
//    return isApplied ?
//    AlertDialog(
//      shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.all(Radius.circular(5.0))),
//      content: Center(child: CircularProgressIndicator(),),
//    )
//        :
//    AlertDialog(
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(5.0))),
//        contentPadding: EdgeInsets.all(15.0),
//        title: Center(child: Text('Confirm Request')),
//        content: SingleChildScrollView(
//          child: Column(
//            children: <Widget>[
//              Text('Please confirm your leave request'),
//              SizedBox(
//                height: 30.0,
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  InkWell(
//                    child: Container(
//                      width: 90.0,
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
//                      width: 90.0,
//                      height: 30.0,
//                      color: !disableButton
//                          ? Theme.of(context).primaryColor
//                          : Colors.grey,
//                      child: Center(
//                          child: Text(
//                            'YES',
//                            style: TextStyle(color: Colors.white),
//                          )),
//                    ),
//                    onTap: disableButton
//                        ? null
//                        : () async {
//                      setState(() {
//                        disableButton = true;
//                        isApplied = true;
//                      });
//                      final Map<String, dynamic> data =
//                      await ApiService.leaveRequest(
//                          leaveType,
//                          fromDate,
//                          toDate,
//                          reason,
//                          leaveMode,
//                          leaveModeShift);
//                      if (data.containsKey('success') &&
//                          data['success'] == false) {
//                        setState(() {
//                          disableButton = false;
//                          isApplied = false;
//                        });
//                        Toast.show(data['message'], context,
//                            duration: Toast.LENGTH_LONG,
//                            gravity: Toast.BOTTOM);
//                        Navigator.of(context).pop();
//
//                      }else{
//                        if (data.containsKey('message') &&
//                            data['message'] != null) {
//                          setState(() {
//                            disableButton = false;
//                            isApplied = false;
//                          });
//                          Toast.show(data['message'], context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.BOTTOM);
//                          setState(() {
//                            disableButton = false;
//                          });
//                          Navigator.pushReplacement(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) =>
//                                      PersonalLeaveRequestListPage()));
//                        }
//                      }
//
//
//
//
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
//}
