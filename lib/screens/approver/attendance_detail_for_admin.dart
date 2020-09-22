//import 'package:flutter/material.dart';
//import 'package:baniadam/style/app_theme.dart';
//import 'package:intl/intl.dart';
//import 'package:baniadam/widgets/base_state.dart';
//
//
//
//class EmployeeAttendenceItemListWidget extends StatefulWidget {
//  final List attendanceItems;
//  final bool isPerformingRequest;
//
//  EmployeeAttendenceItemListWidget(
//      {this.attendanceItems, this.isPerformingRequest});
//
//  @override
//  _EmployeeAttendenceItemListWidgetState createState() =>
//      _EmployeeAttendenceItemListWidgetState();
//}
//
//class _EmployeeAttendenceItemListWidgetState
//    extends BaseState<EmployeeAttendenceItemListWidget> {
//  DateTime date;
//  List newAttendanceList;
//  bool refreshData = false;
//
//  @override
//  void initState() {
//    newAttendanceList = widget.attendanceItems;
//    super.initState();
//  }
//
//  Widget _listBody(BuildContext context) {
//    return SingleChildScrollView(
//        child: Column(
//      children: <Widget>[
//        widget.attendanceItems.isNotEmpty
//            ? Container(
//                child: !refreshData
//                    ? Container(
//                  height: MediaQuery.of(context).size.height,
//                        child: ListView.builder(
//                          itemCount: newAttendanceList.length + 1,
//                          itemBuilder: (BuildContext context, int index) {
//                            return _makeListItemUI(index, context);
//                          },
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/screens/map_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:toast/toast.dart';
import 'attendance_list_for_admin_new.dart';


class AttendanceDetail extends StatefulWidget {
  final List attendanceItems;
  final bool isPerformingRequest;

  AttendanceDetail({this.attendanceItems, this.isPerformingRequest});

  @override
  _AttendanceDetailState createState() =>
      _AttendanceDetailState();
}

class _AttendanceDetailState extends BaseState<AttendanceDetail> {
  DateTime date;
  List newAttendanceList;
  bool refreshData = false;
  String baseCdnUrl;

  @override
  void initState() {
    getCDN();
    newAttendanceList = widget.attendanceItems;
    super.initState();
  }

  getCDN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var portalID = prefs.getString('curr-cid');
    if (portalID != null) {
      setState(() {
        baseCdnUrl = ApiService.CDN_URl + "$portalID/";
      });
    }
  }

  String convert12(String str) {
    String finalTime;
    int h1 = int.parse(str.substring(0, 1)) - 0;
    int h2 = int.parse(str.substring(1, 2));
    int hh = h1 * 10 + h2;

    String Meridien;
    if (hh < 12) {
      Meridien = " AM";
    } else
      Meridien = " PM";
    hh %= 12;
    if (hh == 0 && Meridien == ' PM') {
      finalTime = '12' + str.substring(2);
    } else {
      finalTime = hh.toString() + str.substring(2);
    }
    finalTime = finalTime + Meridien;
//    print(finalTime);
    return finalTime;
  }

  Widget _listBody(BuildContext context) {
//    return Container(
//        child: Column(
//          children: <Widget>[
//            widget.attendanceItems.isNotEmpty
//                ? Container(
//                child: !refreshData
//                    ? Container(
//                  height: MediaQuery.of(context).size.height * 3/5,
//                  child: ListView.builder(
//                    itemCount: newAttendanceList.length,
//                    itemBuilder: (BuildContext context, int index) {
//                      return _makeListItemUI(index, context);
//                    },
////                    controller: widget.scrollController,
//                  ),
//                )
//                    : Center(
//                  child: CircularProgressIndicator(),
//                ))
//                : Text('No attendance data'),
//          ],
//        ));
    if (widget.attendanceItems.isNotEmpty)
      return Container(
          child: !refreshData
              ? Container(
            child: ListView.builder(
              physics: ScrollPhysics(),
              itemCount: newAttendanceList.length,
              itemBuilder: (BuildContext context, int index) {
                return _makeListItemUI(index, context);
              },
//                    controller: widget.scrollController,
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          ));

    return Center(
      child: Text('no attendance data'),
    );
  }

  _makeListItemUI(int index, BuildContext context) {
    if (index >= newAttendanceList.length) {
      return null;
    }
    return _listItemUI(
        listData: newAttendanceList.elementAt(index),
        context: context,
        index: index);
  }

  Widget _listItemUI(
      {Map<String, dynamic> listData, BuildContext context, index}) {
    return Card(
      color: (index % 2 == 0) ? Colors.white : Color(0xFFE7F2FB),
//      elevation: 8.0,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
            child: Container(
              color: Theme
                  .of(context)
                  .primaryColorDark,
            ),
          ),
          ListTile(
            title: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text('Time: ' + convert12(listData['time'])),
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_album, color: Colors.red,),
                      onPressed: () async {
                        if (listData['selfie'] != null) {
                          await employeeInfoDialog(
                              context, baseCdnUrl + listData['selfie']);
                        } else {
                          Toast.show('No selfie taken', context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      },
                    )
                  ],
                ),

              ],
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            Text('Attendance: ' ),
                            Container(
//                      decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0)),
                                height: 25.0,
                                width: 35.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: listData['flag'] == 'in'
                                      ? Color(0xFFAFF0B2)
                                      : Color(0xFFFFCB96),
                                  child: Center(
                                    child: Text(
                                      listData['flag'],
                                      style: TextStyle(
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            Text('From: ' + listData['device_type']),
                          ],
                        )
                    ),
                    IconButton(
                      icon: Icon(Icons.my_location, color: Color(0xff2390D0),),
                      onPressed: () {
                        if (listData['lat'] != null &&
                            listData['lng'] != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MapLocation(
                                          lat: listData['lat'],
                                          lng: listData['lng'])));
                        } else {
                          Toast.show('Location data not found', context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      },
                    )

//                      Container(
//                        margin: EdgeInsets.only(top: 15.0),
//                        padding: EdgeInsets.only(
//                            left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
//                        decoration: ShapeDecoration(
//                            shape: AppTheme.roundedBorderDecoration(),
//                            color: listData['status'] == "PENDING"
//                                ? Color(0xFF5BC0DE)
//                                : listData['status'] == "APPROVED"
//                                    ? Color(0xFF5CB85C)
//                                    : Color(0xFFD9534F)
////                                  ? Colors.blue
////                                  : Colors.red,
////                      color:Color(0xFF999999),
//                            ),
//                        child: Row(
//                          mainAxisSize: MainAxisSize.min,
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              listData['status'],
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 15.0,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          ],
//                        ),
//                      ),
                  ],
                ),
              ],
            ),

//              subtitle: Container(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Row(
////                mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Container(
////                      decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
//                            decoration: BoxDecoration(
//                                border: Border.all(color: Colors.white),
//                                borderRadius: BorderRadius.circular(10.0)),
//                            height: 25.0,
//                            width: 35.0,
//                            child: Material(
//                              borderRadius: BorderRadius.circular(18.0),
//                              color: listData['flag'] == 'in'
//                                  ? Color(0xFFD8EAFB)
//                                  : Color(0xFFFBAC78),
//                              child: Center(
//                                child: Text(
//                                  listData['flag'],
//                                  style: TextStyle(
//                                      color:
//                                      Theme.of(context).primaryColorDark),
//                                ),
//                              ),
//                            )),
//                        SizedBox(width: 10.0),
//                        Text('at ' + convert12(listData['time'])),
//                      ],
//                    ),
//                    SizedBox(
//                      height: 10.0,
//                    ),
//                    Row(
//                      children: <Widget>[
//                        Container(
//                            child: Text(
//                              'Reason: ',
//                              style: TextStyle(fontWeight: FontWeight.bold),
//                            )),
//                        Container(
//                            child: listData['request_reason'] != null
//                                ? Text(
//                              listData['request_reason']['value'],
//                            )
//                                : Text('Not mentioned')),
////                        Container(
////                          child: listData['note'] != null
////                              ? Text('Notes : ' + listData['note'])
////                              : Text('Notes : None'),
////                        ),
//                        SizedBox(width: 10.0),
//                      ],
//                    ),
//                  ],
//                ),
//              )

          ),
        ],
      ),
    );
  }

  static employeeInfoDialog(BuildContext context, var data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.all(25.0),
              title: Center(child: Text('Attendance selfie')),
              content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Center(
                            child: Container(
                                padding: const EdgeInsets.only(left: 0.0),
//                                height: 120.0,
//                                width: 130.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: data != null &&
                                      data != "''"
//                                ?Text(data['photoAttachment']):Text('null')
                                      ? Image.network(
                                    data, width: 280, height: 300,)
                                      : Image.asset('assets/profile.png'),
                                )),
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: 100.0,
                                  height: 30.0,
                                  color: Theme
                                      .of(context)
                                      .buttonColor,
                                  child: Center(
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                onTap: () async {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ))
            // _filterOptions(context),
          );
        });
  }

  Future<bool> _onBackPressed() {
//    Navigator.of(context).pop();

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => AttendanceListPageForAdmin()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(title: Text('Attendance detail'),),
          body: _listBody(context),
        ));
  }
}
