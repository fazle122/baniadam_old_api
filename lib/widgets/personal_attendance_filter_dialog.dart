//import 'package:baniadam/widgets/base_state.dart';
//import 'package:flutter/material.dart';
//import 'package:grouped_buttons/grouped_buttons.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:intl/intl.dart';
//
//
//
//
//class PersonalAttendanceFilterDialog extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _PersonalAttendanceFilterDialogState();
//  }
//}
//
//class _PersonalAttendanceFilterDialogState extends BaseState<PersonalAttendanceFilterDialog> {
//  ScrollController _scrollController = new ScrollController();
//  String _pickedDuration = "all";
//  String _pickedStatus = "all";
//  bool isPerformingRequest = false;
//  List attendenceList;
//
//  bool showCustomFilterRow = false;
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
//  @override
//  void initState() {
//    attendenceList = [];
////    _scrollController.addListener(() {
////      if (_scrollController.position.pixels ==
////          _scrollController.position.maxScrollExtent) {
//////        _getAttendanceList();
////      }
////    });
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return AlertDialog(
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(5.0))),
//        contentPadding: EdgeInsets.all(5.0),
//
//        title: Center(
//            child:Text('Select Filter OPtions!')
//        ),
//        content:
//        SingleChildScrollView(
//          child:Column(children: <Widget>[
//            Text('Select the fields you want ot filter and press APPLY'),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              crossAxisAlignment: CrossAxisAlignment.start,
//
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//                Container(
//                  padding: const EdgeInsets.only(left: 14.0, top: 10.0),
//                  child: Text("Select Duration",
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        fontSize: 20.0
//                    ),
//                  ),
//                ),
//
//                RadioButtonGroup(
//                  picked: _pickedDuration,
//                  padding: const EdgeInsets.only(top:0.0),
//                  labels: [
//                    "all",
//                    "this Week",
//                    "this month",
//                    "custom",
//                  ],
//                  onChange: (String label, int index) => print("label: $label index: $index"),
//                  onSelected: (String label) {
//
//                    setState(() {
//                      _pickedDuration = label;
//                      if(_pickedDuration == 'custom'){
//                        setState(() {
//                          showCustomFilterRow = true;
//                        });
//                      }else{
//                        showCustomFilterRow = false;
//                      }
//                    });
//                    print(label);
//                  },
//                ),
//                showCustomFilterRow == true ? Container(
//                  width: MediaQuery.of(context).size.width,
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Container(
//                        width:150.0,
//                        child: DateTimePickerFormField(
//                          inputType: inputType,
//                          format: formats[inputType],
//                          editable: editable,
//                          decoration: InputDecoration(
//                            hintText: ('Date: from'),
////                            prefixIcon: Icon(
////                              Icons.date_range,color: Theme.of(context).primaryColor,
////                            ),
////                            contentPadding:
////                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                          ),
//                          onChanged: (dt) => setState(() => _from = dt),
//                        ),
//                      ),
//                      Container(
//                        width:150.0,
//                        child: DateTimePickerFormField(
//                          inputType: inputType,
//                          format: formats[inputType],
//                          editable: editable,
//                          decoration: InputDecoration(
//                            hintText:('Date: to'),
////                            prefixIcon: Icon(
////                              Icons.date_range,color: Theme.of(context).primaryColor,
////                            ),
////                            contentPadding:
////                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                          ),
//                          onChanged: (dt) => setState(() => _to = dt),
//                        ),
//                      ),
//                    ],
//                  ),
//                ):SizedBox(width: 0.0,height: 0.0,),
//
//                SizedBox(height: 20.0,),
////                Container(
////                  padding: const EdgeInsets.only(left: 14.0, top: 10.0),
////                  child: Text("Select Status",
////                    style: TextStyle(
////                        fontWeight: FontWeight.bold,
////                        fontSize: 20.0
////                    ),
////                  ),
////                ),
//
////                RadioButtonGroup(
////                  picked: _pickedStatus,
////                  labels: [
////                    "pending",
////                    "approved",
////                    "declined",
////                    "all",
////                  ],
//////                disabled: [
//////                  "Option 1"
//////                ],
////                  onChange: (String label, int index) => print("label: $label index: $index"),
////                  onSelected: (String label) {
////                    setState(() {
////                      _pickedStatus = label;
////                    });
////                    print(label);
////                  },
////                ),
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
//                              'CANCEL',
//                              style: TextStyle(
//                                  color: Theme.of(context).primaryColor),
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
//                              'APPLY',
//                              style: TextStyle(color: Colors.white),
//                            )),
//                      ),
//                      onTap: () {
////                      _getAttendanceList();
//                        Map<String, dynamic> filters = Map();
//
//                        if(showCustomFilterRow == true){
//                          filters['from'] = _from.toString();
//                          filters['to'] = _to.toString();
//                          filters['status'] = _pickedStatus;
//                        }else{
//                          filters['duration'] = _pickedDuration;
//                          filters['status'] = _pickedStatus;
//                        }
//
//                        Navigator.of(context).pop(filters);
//                      },
//                    ),
//                  ],
//                )
//              ],
//            ),
//          ],),
//        )
//      // _filterOptions(context),
//    );
//  }
//}