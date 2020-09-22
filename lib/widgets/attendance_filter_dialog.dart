import 'package:baniadam/widgets/base_state.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class AttendanceFilterDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AttendanceFilterDialogState();
  }
}

class _AttendanceFilterDialogState extends BaseState<AttendanceFilterDialog> {
  ScrollController _scrollController = new ScrollController();
  String _pickedDuration = "today";
  String _pickedStatus = "pending";
  bool isPerformingRequest = false;
  List attendenceList;

  bool showCustomFilterRow = false;
  bool editable = false;
  DateTime _from;
  DateTime _to;

  //  InputType inputType = InputType.date;
//  final formats = {
//    // InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
//    InputType.date: DateFormat('yyyy-MM-dd'),
//    // InputType.time: DateFormat("HH:mm"),
//  };
  final format = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    attendenceList = [];
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
////        _getAttendanceList();
//      }
//    });
    super.initState();
  }

//  void _getAttendanceList() async {
//    if (!isPerformingRequest) {
//      setState(() => isPerformingRequest = true);
//    }
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var token = prefs.getString('curr-user');
//    final Map<String, dynamic> attendenceData =
//    await ApiService.getAttendanceList(token,_pickedDuration,_pickedStatus);
//    if (attendenceData != null) {
//      print(attendenceData['data']);
//      setState(() {
//        attendenceList.addAll(attendenceData['data']);
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(5.0),
        title: Center(child: Text('Select filter options')),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                    'Select the fields you want to filter and press apply'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 14.0, top: 10.0),
                    child: Text(
                      "Attendance requests of",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  Container(
//                    height: 200.0,
                      child: RadioButtonGroup(
                    picked: _pickedDuration,
//                  padding: const EdgeInsets.only(top:30.0),
                    labels: [
                      "today",
                      "yesterday",
                      "this week",
                      "all days",
                      "other",
                    ],
                    onChange: (String label, int index) =>
                        print("label: $label index: $index"),
                    onSelected: (String label) {
                      setState(() {
                        _pickedDuration = label;
                        if (_pickedDuration == 'other') {
                          setState(() {
                            showCustomFilterRow = true;
                          });
                        } else {
                          showCustomFilterRow = false;
                        }
                      });
                      print(label);
                    },
                  )),
                  showCustomFilterRow == true
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 130.0,
                                child: DateTimeField(
                                  textAlign: TextAlign.center,
                                  format: format,
                                  onChanged: (dt) => setState(() => _from = dt),
                                  decoration: InputDecoration(
                                    hintText: ('From date'),
                                  ),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate: currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                  },
                                ),
//                        child: DateTimePickerFormField(
//                          textAlign: TextAlign.center,
//                          inputType: inputType,
//                          format: formats[inputType],
//                          editable: editable,
//                          decoration: InputDecoration(
//                            hintText: ('From date'),
////                            prefixIcon: Icon(
////                              Icons.date_range,color: Theme.of(context).primaryColor,
////                            ),
////                            contentPadding:
////                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                          ),
//                          onChanged: (dt) => setState(() => _from = dt),
//                        ),
                              ),

                              Container(
                                width: 130.0,
                                child:DateTimeField(
                                  textAlign: TextAlign.center,
                                  format: format,
                                  onChanged: (dt) => setState(() => _to = dt),
                                  decoration: InputDecoration(
                                    hintText: ('To date'),
                                  ),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                        context: context,
                                        firstDate: _from,
                                        initialDate: currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                  },
                                ),
//                                child: DateTimePickerFormField(
//                                  textAlign: TextAlign.center,
//                                  inputType: inputType,
//                                  format: formats[inputType],
//                                  editable: editable,
//                                  decoration: InputDecoration(
//                                    hintText: ('To date'),
////                            prefixIcon: Icon(
////                              Icons.date_range,color: Theme.of(context).primaryColor,
////                            ),
////                            contentPadding:
////                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                                  ),
//                                  onChanged: (dt) => setState(() => _to = dt),
//                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: 0.0,
                          height: 0.0,
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 14.0, top: 10.0),
                    child: Text(
                      "Select status",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  RadioButtonGroup(
                    picked: _pickedStatus,
                    labels: [
                      "pending",
                      "approved",
                      "declined",
                      "all",
                    ],
//                disabled: [
//                  "Option 1"
//                ],
                    onChange: (String label, int index) =>
                        print("label: $label index: $index"),
                    onSelected: (String label) {
                      setState(() {
                        _pickedStatus = label;
                      });
                      print(label);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: 100.0,
                          height: 30.0,
                          color: Colors.white,
                          child: Center(
                              child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: 100.0,
                          height: 30.0,
                          color: Theme.of(context).primaryColor,
                          child: Center(
                              child: Text(
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        onTap: () {
//                      _getAttendanceList();
                          Map<String, dynamic> filters = Map();

                          if (showCustomFilterRow == true) {
                            filters['from'] = _from.toString();
                            filters['to'] = _to.toString();
                            filters['status'] = _pickedStatus;
                          } else {
                            if (_pickedDuration == 'this week') {
                              filters['duration'] = 'week';
                            } else if (_pickedDuration == 'all days') {
                              filters['duration'] = 'all';
                            } else {
                              filters['duration'] = _pickedDuration;
                            }
                            filters['status'] = _pickedStatus;
                          }
                          Navigator.of(context).pop(filters);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        )
        // _filterOptions(context),
        );
  }
}
