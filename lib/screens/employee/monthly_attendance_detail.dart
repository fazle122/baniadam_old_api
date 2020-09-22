import 'package:baniadam/style/app_theme.dart';
import 'package:flutter/material.dart';
import '../../data_provider/api_service.dart';
import '../../models/leaveList.dart';
//import 'current_date_personal_attendance.dart';
import 'package:intl/intl.dart';
import 'package:baniadam/widgets/base_state.dart';

class AttendanceDetailPage extends StatefulWidget {
  final int empId;
  final String date;

  AttendanceDetailPage({
    this.empId,
    this.date,
    Key key,
  }) : super(key: key);

  @override
  _AttendanceDetailPageState createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends BaseState<AttendanceDetailPage> {
  LeavesList leaveList;
  List leaveListItem = [];
  String leave;
  bool isPerformingRequest = false;
  ScrollController _scrollController = new ScrollController();

  List personalAttendenceList;
  Map<String, dynamic> personalLeaveDetail;

  @override
  void initState() {
    super.initState();
    personalAttendenceList = [];
    _getAttendanceDetail();

//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _getMoreAttendanceList();
//      }
//    });
  }

  void _getMoreAttendanceList() async {
//    if (!isPerformingRequest) {
//      setState(() => isPerformingRequest = true);
//    }

//    newAttendenceList.clear();
//
//    if (currentPage < lastPage) {
//      setState(() {
//        currentPage += 1;
//        filters['page'] = currentPage;
//      });
//      final Map<String, dynamic> attendenceData =
//      await ApiService.getAttendanceList(filters);
//      if (attendenceData != null) {
//        print(attendenceData['data']);
//        setState(() {
//          newAttendenceList.addAll(attendenceData['data']);
//          attendenceList.addAll(newAttendenceList);
//          print(attendenceList.length.toString());
//          print(newAttendenceList);
//        });
//      }
//    } else if (currentPage == lastPage) {}
  }

  void _getAttendanceDetail() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
    }
    final List<dynamic> personalAttendenceData =
        await ApiService.getDateWisePersonalAttendanceList(widget.empId,
            DateFormat("yyyy.MM.dd").format(DateTime.parse(widget.date)));
    if (personalAttendenceData != null) {
      setState(() {
        personalAttendenceList.addAll(personalAttendenceData);
      });
    }
  }

//  _personalAttendancListItemUI() {
//    if (personalAttendenceList
//        .isNotEmpty) //has data & performing/not performing
//      return EmployeeAttendenceItemListWidget(
//        attendanceItems: personalAttendenceList,
////        scrollController: _scrollController,
//        isPerformingRequest: isPerformingRequest,
//        fullPage:true,
//      );
////    if (isPerformingRequest)
////      return Center(
////        child: CircularProgressIndicator(),
////      );
//
//    return Center(
//      child: Text('no attendance data'),
//    );
//  }

  _personalAttendancListItemUI() {
    if (personalAttendenceList.isNotEmpty)
      return AttendenceListItemWidget(
        attendanceItems: personalAttendenceList,
        scrollController: _scrollController,
        isPerformingRequest: isPerformingRequest,
      );
//    if (isPerformingRequest)
//      return Center(
//        child: CircularProgressIndicator(),
//      );

    return Center(
      child: Text('no attendance data'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Attendance on ' +
                DateFormat.yMMMEd().format(DateTime.parse(widget.date)),
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Center(child: _personalAttendancListItemUI(),)
        )));
  }
}

class AttendenceListItemWidget extends StatefulWidget {
  final List attendanceItems;
  final ScrollController scrollController;
  final bool isPerformingRequest;

  AttendenceListItemWidget(
      {this.attendanceItems, this.scrollController, this.isPerformingRequest});

  @override
  _AttendenceListItemWidgetState createState() =>
      _AttendenceListItemWidgetState();
}

class _AttendenceListItemWidgetState
    extends BaseState<AttendenceListItemWidget> {
  bool refreshData = false;
  List newAttendanceList;
  int currentPage;
  int lastPage;

  @override
  void initState() {
//    if (widget.attendenceItems.isNotEmpty) {
    currentPage = widget.attendanceItems[0]['current_page'];
    lastPage = widget.attendanceItems[0]['last_page'];
    newAttendanceList = widget.attendanceItems;
//    }

//    widget.scrollController.addListener(() {
//      if (widget.scrollController.position.pixels ==
//          widget.scrollController.position.minScrollExtent) {
//        _getRefreshData();
//      }
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        widget.attendanceItems.isNotEmpty
            ? Container(
                child: !refreshData
                    ? Container(
//                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  width: MediaQuery.of(context).size.width * 4.5/5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: newAttendanceList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                child: Column(
                                  children: <Widget>[
                                    _makeListItemUI(index, context),
                                    SizedBox(
                                      height: 10.0,
                                    )
                                  ],
                                ));
                          },
                          controller: widget.scrollController,
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ))
            : Text('No attendance data'),
      ],
    ));
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

  String convert12(String str) {
  String finalTime;

    int h1 = int.parse(str.substring(0,1)) - 0;
//    int h2 = int.parse(str.substring(1,1)) - 0;
    int h2 = int.parse(str.substring(1,2));
    int hh = h1 * 10 + h2;

    String Meridien;
    if (hh < 12) {
      Meridien = " AM";
    } else
      Meridien = " PM";

    hh %= 12;

//    if (hh == 0) {
      if (hh == 0 && Meridien == ' PM') {
      finalTime = '12' +str.substring(2);
//      print(hh.toString() +str.substring(2));

//      for (int i = 2; i < 8; ++i) {
//        print(hh.toString() + str.substring(i));
//        finalTime = hh.toString() + str.substring(i);
//      }
    } else {
      finalTime = hh.toString() +str.substring(2);
//      print(hh.toString() +str.substring(2));

//      for (int i = 2; i < 8;) {
//        print(hh.toString() + str.substring(i));
//        finalTime = hh.toString() + str.substring(i);
//
//      }
    }
    finalTime = finalTime + Meridien;
    print(finalTime);
    return finalTime;
  }

  Widget _listItemUI(
      {Map<String, dynamic> listData, BuildContext context, index}) {
    return Card(
      color:Colors.white,
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: (){
              convert12(listData['time']).toString();
            },
              title: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                        child: Text('Date :' +
                            DateFormat.yMMMEd()
                                .format(DateTime.parse(listData['date']))),
                      ),
//                      Container(
//                        margin: EdgeInsets.only(top: 15.0),
//                        padding: EdgeInsets.only(
//                            left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
//                        decoration: ShapeDecoration(
//                            shape: AppTheme.roundedBorderDecoration(),
//                            color: listData['status'] == "PENDING"
//                                ? Color(0xFF5BC0DE)
//                                : listData['status'] == "APPROVED"
//                                ? Color(0xFF5CB85C)
//                                : Color(0xFFD9534F)
////                                  ? Colors.blue
////                                  : Colors.red,
////                      color:Color(0xFF999999),
//                        ),
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
              subtitle: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
//                mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
//                      decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0)),
                            height: 25.0,
                            width: 35.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(18.0),
                              color: listData['flag'] == 'in'
                                  ? Color(0xFFD8EAFB)
                                  : Color(0xFFFBAC78),
                              child: Center(
                                child: Text(
                                  listData['flag'],
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Text('at ' + convert12(listData['time']),style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
//                        Text(convert12(listData['time'])),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
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
//
//                        SizedBox(width: 10.0),
//                      ],
//                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

