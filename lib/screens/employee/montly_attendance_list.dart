import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/screens/employee/monthly_attendance_detail.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/leaveList.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:intl/intl.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:baniadam/widgets/personal_attendance_filter_dialog.dart';

class MonthlyAttendanceListPage extends StatefulWidget {
  final int id;

  MonthlyAttendanceListPage({
    this.id,
    Key key,
  }) : super(key: key);

  @override
  _MonthlyAttendanceListPageState createState() =>
      _MonthlyAttendanceListPageState();
}

class _MonthlyAttendanceListPageState
    extends BaseState<MonthlyAttendanceListPage> {
  LeavesList leaveList;
  List attendanceListItem = [];
  List leaveListItem = [];
  Map<String, dynamic> _leaveTypes;
  List newLeaveListItem;
  String leave;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  int currChunk = 1;
  int lastItemId = 0;

  int currentPage;
  int lastPage;
  int nextPage;

  Map<String, dynamic> filters;
  var now = DateTime.now();

  @override
  void initState() {
    super.initState();
//    getNotification(this);
    _getListItems();
    filters = new Map();
    _leaveTypes = Map();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getNewListItems();
      }
    });
  }

//  void notificationReceived(Map<String, dynamic> notificationData){
//    String userIdFromServer = notificationData['data_payload']['showTo'].toString();
////    print("Notification Received");
//    Logger.debug("Notification Received");
//  }

  void _getListItems() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
    }
    attendanceListItem.clear();
    leaveListItem.clear();

    final Map<String, dynamic> data =
        await ApiService.getMonthlyAttendanceData(widget.id, filters);
    isPerformingRequest = false;
    List<dynamic> attendanceData = data['attendances'];
    if (attendanceData.isEmpty) {
      attendanceListItem.isEmpty;
      leaveListItem.isEmpty;
    } else {
      setState(() {
        currentPage = data['current_page'];
        lastPage = data['last_page'];
        attendanceListItem.addAll(data['attendances'][0]['data']);
        leaveListItem.addAll(data['attendances'][0]['offdays']);
      });
    }
    for (int i = 0; i < leaveListItem.length; i++) {
      Map<String, dynamic> tmp = Map();
      tmp['type'] = leaveListItem[i]['type'];
      tmp['status'] = leaveListItem[i]['status'];
      _leaveTypes[leaveListItem[i]['date']] = tmp;
    }
  }

  void _getNewListItems() async {
//    if (!isPerformingRequest) {
//      setState(() => isPerformingRequest = true);
//    }

    newLeaveListItem.clear();

    if (currentPage < lastPage) {
      setState(() {
        currentPage += 1;
        filters['page'] = currentPage;
      });
      final Map<String, dynamic> newLeaveData =
          await ApiService.getAttendanceList(filters);
      if (newLeaveData != null) {
        print(newLeaveData['data']);
        setState(() {
          newLeaveListItem.addAll(newLeaveData['data']);
          attendanceListItem.addAll(newLeaveListItem);
          print(attendanceListItem.length.toString());
        });
      }
    } else if (currentPage == lastPage) {}
  }

  void animateScrollBump() {
    double edge = 50.0;
    double offsetFromBottom = _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;
    if (offsetFromBottom < edge) {
      _scrollController.animateTo(
          _scrollController.offset - (edge - offsetFromBottom),
          duration: new Duration(milliseconds: 500),
          curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My attendance of this month'),
        ),
//      body: leaveListDataWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  color: Color(0xFFF7F7F7),
                  child: Center(
                    child: leaveListDataWidget(),
                  ))
//            leaveListDataWidget()
            ],
          ),
        ));
  }

  Widget leaveListDataWidget() {
    if (attendanceListItem.isNotEmpty)
      return LeaveItemListWidget(
        attendanceItems: attendanceListItem,
        leaveItems: _leaveTypes,
        scrollController: _scrollController,
        isPerformingRequest: isPerformingRequest,
      );
    else if (attendanceListItem.isEmpty) {
      return Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1/2),
          child: Center(
            child: Text('no list item'),
          ));
    }
    if (isPerformingRequest)
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}

class LeaveItemListWidget extends StatelessWidget {
  final List attendanceItems;
  final Map<String, dynamic> leaveItems;
  final ScrollController scrollController;
  final bool isPerformingRequest;

  LeaveItemListWidget(
      {this.attendanceItems,
      this.leaveItems,
      this.scrollController,
      this.isPerformingRequest});

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 4.5 / 5,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: attendanceItems.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == attendanceItems.length) {
                return _buildProgressIndicator();
              } else {
                return Container(
                    child: Column(
                  children: <Widget>[
                    _makeListItemUI(index, context),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ));
//                return Container(
//
//                  child: _makeListItemUI(index, context),
//                );
//                  _makeListItemUI(index, context);
              }
            },
            controller: scrollController,
          ),
        )
      ],
    ));
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  _makeListItemUI(int index, BuildContext context) {
    if (index >= attendanceItems.length) {
      return null;
    }
    var tmp = attendanceItems.elementAt(index);
    return _listItemUI(
        attendanceData: tmp,
        leaveData: leaveItems.containsKey(tmp['dates'])
            ? leaveItems[tmp['dates']]
            : null,
        context: context,
        index: index);
  }

  Widget _listItemUI(
      {Map<String, dynamic> attendanceData,
      Map<String, dynamic> leaveData,
      BuildContext context,
      index}) {
    int dayCount = DateTime.parse(attendanceData['dates']).day;
    int toDay = DateTime.parse(DateTime.now().toString()).day;
    var date = attendanceData['dates'];
    return dayCount <= toDay
        ? Container(
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                elevation: 4.0,
                color: Colors.white,
//            color: (index % 2 == 0) ? Colors.white : Color(0xFFE7F2FB),
                child: Container(

                  child: InkWell(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    margin: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    DateFormat.yMMMEd().format(DateTime.parse(
                                        attendanceData['dates'])),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      1.2 /
                                      5,
                                  child: (leaveData != null &&
                                          leaveData['status'] != 'Pending' &&
                                          attendanceData['status'] != 'Present')
                                      ? Container(
                                          margin: EdgeInsets.only(top: 15.0),
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          decoration: ShapeDecoration(
                                              shape: AppTheme
                                                  .roundedBorderDecoration(),
                                              color: leaveData != null && leaveData['type'] == 'leave'
                                                  ? Color(0xFF29ABE2)
                                                  : leaveData != null && leaveData['type'] == 'weekend'
                                                      ? Color(0xFF8B1843)
                                                      : Color(0xFF29ABE2)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                leaveData['type'].substring(0, 1).toUpperCase() +
                                                    leaveData['type'].substring(1),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ))
                                      : Container(
                                          margin: EdgeInsets.only(top: 15.0),
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          decoration: ShapeDecoration(
                                              shape: AppTheme
                                                  .roundedBorderDecoration(),
                                              color: attendanceData['status'] == 'Present'
                                                  ? Color(0xFF8B8B8B)
                                                  : attendanceData['status'] == 'Absent'
                                                      ? Color(0xFFED1C24)
                                                      : Color(0xFFF7931E)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                attendanceData['status'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                        child: Text(
                                      'In: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                        child: attendanceData['in_time'] !=
                                                    null &&
                                                attendanceData['in_time'] !=
                                                    'n/a'
                                            ? Text(
                                                convert12(
                                                    attendanceData['in_time']),
                                              )
                                            : Text('No data')),
                                  ],
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                        child: Text(
                                      'Out: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                        child: attendanceData['out_time'] !=
                                                    null &&
                                                attendanceData['out_time'] !=
                                                    'n/a'
                                            ? Text(
//                                    convert12(attendanceData['out_time'])
                                                attendanceData['out_time'],
                                              )
                                            : Text('No data')),
                                  ],
                                ),
//                  Container(
//                    margin: EdgeInsets.only(top: 5.0),
//                    child: attendanceData['out_time']!= null ?Text('Out time: '+attendanceData['out_time']):Text('Out time: '+'no data')
//                  ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
//                          trailing: Container(
//                            padding: EdgeInsets.only(
//                                left: 15.0,
//                                right: 15.0,
//                                top: 5.0,
//                                bottom: 5.0),
//                            decoration: ShapeDecoration(
//                              shape: AppTheme.roundedBorderDecoration(),
//                              color: leaveData != null
//                                  ? leaveData['type'] == 'leave'
//                                  ? Color(0xFF1EAEE4)
//                                  : Color(0xFF8B1843)
//                                  : attendanceData['status'] == 'Absent'
//                                  ? Color(0xFFE84033)
//                                  : Color(0xFFA9ABAE),
//                            ),
//                            child:
////                            (leaveData['date'] == attendanceData['dates'])
//                            (leaveData != null &&
//                                leaveData['status'] != 'Pending' &&
//                                attendanceData['status'] != 'Present')
//                                ? Container(width:MediaQuery.of(context).size.width * .75/5, child:Row(
//                              mainAxisSize: MainAxisSize.min,
//                              mainAxisAlignment:
//                              MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text(
//                                  leaveData['type'],
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontSize: 15.0,
//                                      fontWeight: FontWeight.bold),
//                                ),
//                              ],
//                            ))
//                                : Container(width:MediaQuery.of(context).size.width * .75/5, child:Row(
//                              mainAxisSize: MainAxisSize.min,
//                              mainAxisAlignment:
//                              MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text(
//                                  attendanceData['status'],
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontSize: 15.0,
//                                      fontWeight: FontWeight.bold),
//                                ),
//                              ],
//                            )),
//                          ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttendanceDetailPage(
                                        empId: attendanceData['employee'],
                                        date: attendanceData['dates'],
                                      )));
                        },
                      ),
                    ],
                  )),
                )),
          )
        : SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }
}
