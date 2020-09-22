import 'package:baniadam/widgets/base_state.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import '../data_provider/api_service.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;



class LeaveFilterDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeaveFilterDialogState();
  }
}

class _LeaveFilterDialogState extends BaseState<LeaveFilterDialog> {
  static const leaveStatus = <String>[
    'Approved',
    'Declined',
    'Pending',
    'Requested for Cancellation',
    'Cancelled'
  ];
  ScrollController _scrollController = new ScrollController();
  String _pickedDuration = "today";
  String _pickedStatus = "pending";
  bool isPerformingRequest = false;
  List attendenceList;

  int selectedLeaveType;
  String selectedLeaveName;
  int selectedDesignation;
  String selectedDesignationName;
  int selectedBranch;
  String selectedBranchName;
  int selectedDepartment;
  String selectedDepartmentName;
  String selectedLeaveStatus;

  Map<int, dynamic> _leaveTypes;
  Map<int, dynamic> _designations;
  Map<int, dynamic> _departments;
  Map<int, dynamic> _branch_types;

  bool showCustomFilterRow = false;
  bool editable = false;

  List _mySelectedStatus;
  List<Map> dataSource = [

    {
      "display": "Approved",
      "value": "Approved",
    },
    {
      "display": "Declined",
      "value": "Declined",
    },
    {
      "display": "Pending",
      "value": "Pending",
    },
    {
      "display": "Requested for Cancellation",
      "value": "Requested for Cancellation",
    },
    {
      "display": "Cancelled",
      "value": "Cancelled",
    },
  ];

  @override
  void initState() {
    _leaveTypes = new Map();
    _designations = new Map();
    _departments = new Map();
    _branch_types = new Map();
    _getBranchTypes();
    _getDepartments();
    _getDesignation();
    _getLeaveTypes();
    attendenceList = [];
    _mySelectedStatus = [];
    _getStatusList();
    super.initState();
  }

  _getStatusList()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
//    List _savedStatusList= pref.getStringList('statusList');
    var list = pref.getString('statusList');
//    print(list);
//    print(json.decode(list));
    if(list != null){
      setState(() {
        _mySelectedStatus = json.decode(list);
      });
    }
  }

  void _getBranchTypes() async {
    Map<String, dynamic> data = await ApiService.getBranchTypes();
    debugPrint(data['attributes'].toString());
    if (data != null) {
      setState(() {
//        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < data['attributes'].length; i++) {
          _branch_types[data['attributes'][i]['id']] =
              data['attributes'][i]['value'];
        }
      });
    }
  }

  void _getDepartments() async {
    Map<String, dynamic> data = await ApiService.getDepartments();
    debugPrint(data['attributes'].toString());
    if (data != null) {
      setState(() {
//        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < data['attributes'].length; i++) {
          _departments[data['attributes'][i]['id']] =
              data['attributes'][i]['value'];
        }
      });
    }
  }

  void _getDesignation() async {
    Map<String, dynamic> data = await ApiService.getDesignations();
    debugPrint(data['attributes'].toString());
    if (data != null) {
      setState(() {
//        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < data['attributes'].length; i++) {
          _designations[data['attributes'][i]['id']] =
              data['attributes'][i]['value'];
        }
      });
    }
  }

  void _getLeaveTypes() async {
    Map<String, dynamic> data = await ApiService.getAllLeaveTypes();
    debugPrint(data['attributes'].toString());
    if (data != null) {
      setState(() {
        for (int i = 0; i < data['attributes'].length; i++) {
          _leaveTypes[data['attributes'][i]['id']] =
              data['attributes'][i]['value'];
        }
      });
    }
  }

//  void _getLeaveTypes() async {
//    Map<String, dynamic> data = await ApiService.getAllLeaveTypes();
////    debugPrint(data['attributes'].toString());
//    if (data != null) {
//      setState(() {
////        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
//        for (int i = 0; i < data.length; i++) {
//          _leaveTypes[data[i]['id']] =
//              data[i]['value'];
//        }
//      });
//    }
//  }

  List<DropdownMenuItem> _menuItems(Map<dynamic, dynamic> items) {
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((key, value) {
      itemWidgets.add(DropdownMenuItem(
//        key: key,
        value: key,
        child: Text(value),
      ));
    });
    return itemWidgets;
  }

  List<DropdownMenuItem<String>> _statusMenuItems(Map<dynamic, dynamic> items) {
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((key, value) {
      itemWidgets.add(DropdownMenuItem(
//        key: key,
        value: key,
        child: Text(value),
      ));
    });
    return itemWidgets;
  }

  Widget _alertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
//      contentPadding: EdgeInsets.all(15.0),

//      titlePadding: EdgeInsets.only(left:20.0,right: 20.0),
      title: Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        padding: EdgeInsets.all(0.0),
        child: Center(
          child: Text('Filter options'),
        ),
      ),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(0.0),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Branch',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButton(
                    hint: Text('Select branch'),
                    isExpanded: true,
                    value: selectedBranch,
                    onChanged: (newValue) {
                      setState(() {
                        selectedBranch = newValue;
                        selectedBranchName = _branch_types[newValue];
                        print(selectedBranch);
                        print(_branch_types[newValue]);
                      });
                    },
                    items: _menuItems(_branch_types),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Department',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButton(
                    hint: Text('Select department'),
                    isExpanded: true,
                    value: selectedDepartment,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDepartment = newValue;
                        selectedDepartmentName = _departments[newValue];
                        print(selectedDepartment);
                        print(_departments[newValue]);
                      });
                    },
                    items: _menuItems(_departments),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Designation',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButton(
                    hint: Text('Select designation'),
                    isExpanded: true,
                    value: selectedDesignation,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDesignation = newValue;
                        selectedDesignationName = _designations[newValue];
                        print(selectedDesignation);
                        print(_designations[newValue]);
                      });
                    },
                    items: _menuItems(_designations),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Leave type',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButton(
                    hint: Text('Select leave type'),
                    isExpanded: true,
                    value: selectedLeaveType,
                    onChanged: (newValue) {
                      setState(() {
                        selectedLeaveType = newValue;
                        selectedLeaveName = _leaveTypes[newValue];
                        print(selectedLeaveType);
                        print(_leaveTypes[newValue]);
                      });
                    },
                    items: _menuItems(_leaveTypes),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Leave status',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  child: MultiSelectFormField(
                    autovalidate: false,
                    titleText: 'Choose status',
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please select one or more status';
                      }
                    },
                    dataSource: dataSource,
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    // required: true,
                    hintText: 'Please choose one or more',
                    value: _mySelectedStatus,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        _mySelectedStatus = value;
                      });
                    },
                  ),
                ),
//                Container(
//                    width: MediaQuery.of(context).size.width,
//                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                    margin: EdgeInsets.all(3.0),
//                    decoration: ShapeDecoration(
//                      shape: RoundedRectangleBorder(
//                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
//                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                      ),
//                    ),
//                    child: DropdownButton<String>(
//
//                        hint: Text('Select leave status'),
//                        isExpanded: true,
//                        value: selectedLeaveStatus,
//                        onChanged: (String newValue) {
//                          setState(() {
//                            selectedLeaveStatus = newValue;
//                            print(selectedLeaveStatus);
//                          });
//                        },
//                        items: leaveStatus
//                            .map((String value) => DropdownMenuItem<String>(
//                                  value: value,
//                                  child: Text(value),
//                                ))
//                            .toList())),
              ],
            ),
            SizedBox(
              height: 20.0,
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
                  side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
              ),
                        child: Center(
                            child: Text(
                          'Cancel',
                          style:
                              TextStyle(color: Theme.of(context).primaryColorDark),
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
                            side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      onTap: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('statusList', json.encode(_mySelectedStatus));
//                      _getAttendanceList();
                        Map<String, dynamic> filters = Map();
                        filters['branch'] = selectedBranch.toString();
                        filters['branchName'] = selectedBranchName;
                        filters['department'] = selectedDepartment.toString();
                        filters['departmentName'] = selectedDepartmentName;
                        filters['designation'] = selectedDesignation.toString();
                        filters['designationName'] = selectedDesignationName;
                        filters['leave_type'] = selectedLeaveType.toString();
                        filters['leaveTypeName'] = selectedLeaveName;
//                        filters['status'] = selectedLeaveStatus;
                        filters['status'] = _mySelectedStatus;
//                          filters['status'] = selectedLeaveType.toString();
                        Navigator.of(context).pop(filters);
                      },
                    ),
                    SizedBox(height: 20.0)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _alertDialog(context);
  }
}
