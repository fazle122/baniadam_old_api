import 'package:baniadam/screens/approver/attendance_detail_for_admin.dart';
import 'package:baniadam/screens/approver/track_map.dart';
import 'package:baniadam/widgets/attendance_request_filter_dialog_for_employee.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:baniadam/widgets/base_state.dart';
import 'package:intl/intl.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/screens/dashboard.dart';
import '../../data_provider/api_service.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceRequestListPageForEmployee extends StatefulWidget {
  AttendanceRequestListPageForEmployee({
    Key key,
  }) : super(key: key);

  @override
  _AttendanceRequestListPageForEmployeeState createState() =>
      _AttendanceRequestListPageForEmployeeState();
}

class _AttendanceRequestListPageForEmployeeState
    extends BaseState<AttendanceRequestListPageForEmployee> {
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  Map<String, dynamic> personalDetail;
  List attendanceList;

  List newAttendanceList;
  Map<String, dynamic> filters;

  int currentPage;
  int lastPage;
  int nextPage;
  bool _refreshList = false;
  DateTime selectedDate;
  DateTime date;
  String formatted;
  var format = DateFormat('yyyy-MM-dd');




  @override
  void initState() {
//    selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    filters = new Map();
    attendanceList = [];
    setDate();
    newAttendanceList = [];
    _getAttendanceList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreAttendanceList();
//        _getAttendanceList();
      }
    });
    super.initState();
  }

  setDate(){
    selectedDate = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formatted = formatter.format(selectedDate);
//    date = DateTime.parse(formatted);
  }

  _refreshData() {
    attendanceList = [];
    newAttendanceList = [];
    _getAttendanceList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreAttendanceList();
      }
    });
  }

  void _getAttendanceList() async {
    setState(() {
      _refreshList = true;
    });
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
    }
  attendanceList.clear();
    List<dynamic> attendenceData =
        await ApiService.getAttendanceRequestListForEmployee(filters);
    if (attendenceData != null) {
      _refreshList = false;
      print(attendenceData);
      setState(() {
        attendanceList.addAll(attendenceData);
        print(attendanceList.length.toString());
      });
    }
  }

  void _getMoreAttendanceList() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
    }

    newAttendanceList.clear();

    if (currentPage < lastPage) {
      setState(() {
        currentPage += 1;
        filters['page'] = currentPage;
      });
      final List<dynamic> attendenceData =
          await ApiService.getAttendanceRequestListForEmployee(filters);
      if (attendenceData != null) {
        print(attendenceData);
        setState(() {
//          newAttendanceList.addAll(attendenceData['data']);
//          attendanceList.addAll(newAttendanceList);
          attendanceList.addAll(attendenceData);
          print(attendanceList.length.toString());
          print(newAttendanceList);
        });
      }
    } else if (currentPage == lastPage) {}
  }

  _attendancListItemUI() {
    if (attendanceList.isNotEmpty) //has data & performing/not performing
      return AdminAttendenceListItemWidget(
        selectedDate:selectedDate,
        attendanceItems: attendanceList,
        scrollController: _scrollController,
        isPerformingRequest: isPerformingRequest,
//        filters: filters,
      );
//    if (isPerformingRequest)
//      return Container(
//          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1/2),
//          child:Center(
//            child: CircularProgressIndicator(),)
//      );

    return
      Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1/2),
          child:Center(
            child: Text('no list item'),)
      );
  }

  Widget listWidget() {
    return !_refreshList
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: _attendancListItemUI(),
              )
            ],
          )
        : Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 1 / 2),
            child: Center(
              child: CircularProgressIndicator(),
            ));
  }


  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  }

  Future<Map<String, dynamic>> _attendanceFlterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AttendanceRequestFilterForEmployeeDialog(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return
//      WillPopScope(
//        onWillPop: _onBackPressed,
//        child:
        Scaffold(
            appBar: AppBar(
              title: Text('My attendance requests'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _getAttendanceList();
                  },
                ),


                PopupMenuButton<String>(
                  onSelected: (val) async {
                    switch (val) {
                      case 'FILTER':
                        debugPrint('filter');
                        var newFilters = await _attendanceFlterDialog(context);
                        if (newFilters != filters) {
                          setState(() {
                            filters = newFilters;
//                            title = '';
                          });
                          if (filters['status'] != null) {
                            List allStatus = [];
                            for(int i = 0;i <filters['status'].length; i++)
                            {
                              allStatus.add(filters['status'][i]);
                            }
//                            setState(() {
//                              title += 'Status : ' + allStatus.toString();
//                            });
                          }
                        }
                        _getAttendanceList();
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      value: 'FILTER',
                      child: Text('Filter'),
                    ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: Container(
              child: Center(child: listWidget()),
            )))
//      )
        ;
  }
}

class AdminAttendenceListItemWidget extends StatefulWidget {
  final DateTime selectedDate;
  final List attendanceItems;
  final ScrollController scrollController;
  final bool isPerformingRequest;

  AdminAttendenceListItemWidget(
      {this.selectedDate,this.attendanceItems, this.scrollController, this.isPerformingRequest});

  @override
  _AdminAttendenceListItemWidgetState createState() =>
      _AdminAttendenceListItemWidgetState();
}

class _AdminAttendenceListItemWidgetState
    extends BaseState<AdminAttendenceListItemWidget> {
  bool refreshData = false;
  List newAttendanceList;
  int currentPage;
  int lastPage;
  Map attendanceDetail;
  String baseCdnUrl;
  var previousId;
  var currentId = 0;

  List trackDataList;


  @override
  void initState() {
    getCDN();
    trackDataList = [];
    attendanceDetail = Map();
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

  getCDN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var portalID = prefs.getString('curr-cid');
    if (portalID != null) {
      setState(() {
//        baseCdnUrl = "https://cdn.baniadam.app/$portalID/";
        baseCdnUrl = ApiService.CDN_URl + "$portalID/";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _listBody(context));
  }

  Widget _listBody(BuildContext context) {
    if (newAttendanceList.length > 0) {
      return Container(
          child: Container(
        height: MediaQuery.of(context).size.height * 4.3 / 5,
        width: MediaQuery.of(context).size.width * 4.5 / 5,
        child: ListView.builder(
          itemCount: newAttendanceList.length,
          itemBuilder: (BuildContext context, int index) {
              return _makeListItemUI(context, index);
          },
          controller: widget.scrollController,
        ),
      ));
    }
    if (refreshData)
      return Container(
          padding:EdgeInsets.only(top: MediaQuery.of(context).size.height * 1 / 2),
          child: Center(
            child: CircularProgressIndicator(),
          ));
    return
      Container(
          padding:EdgeInsets.only(top:MediaQuery.of(context).size.height * 1/2),
          child: Center(
            child: Text('No attendance data'),
    ));
  }

  _makeListItemUI(BuildContext context, int index) {
    previousId = newAttendanceList.elementAt(index)['id'];
    if (index >= newAttendanceList.length) {
      return null;
    }

    return _listItemUI(
        listData: newAttendanceList.elementAt(index),
        context: context,
        index: index);
  }

  String convert12(String s) {
    String finalTime;
    String str = s.substring(0,5);
    int h1 = int.parse(str.substring(0,1)) - 0;
    int h2 = int.parse(str.substring(1,2));
    int hh = h1 * 10 + h2;

    String Meridien;
    if (hh < 12) {
      Meridien = "AM";
    } else
      Meridien = "PM";
    hh %= 12;
    if (hh == 0 && Meridien == 'PM') {
//      finalTime = '12' +str.substring(2);
      finalTime = '12' +str.substring(2);
    } else {
//      finalTime = hh.toString() +str.substring(2);
      finalTime = hh.toString() +str.substring(2);
    }
    finalTime = finalTime + Meridien;
//    print(finalTime);
    return finalTime;
  }

  Widget _listItemUI(
      {Map<String, dynamic> listData, BuildContext context, index}) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          ListTile(
              title: Container(
                padding: EdgeInsets.only(top:10.0,bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
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
                                      color:Colors.black),
                                ),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Text('request for ' +
                            convert12(listData['time']) + '  ' +
//                            DateFormat.yMMMd().format(DateTime.parse(listData['date']))
                            DateFormat('d-MMM-yy').format(DateTime.parse(listData['date']))
                          ,style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            child: Text(
                              'Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                            child: listData['status'] != null
                                ? Text(
                              listData['status'],
                            )
                                : Text('')),
//                        Container(
//                          child: listData['note'] != null
//                              ? Text('Notes : ' + listData['note'])
//                              : Text('Notes : None'),
//                        ),
                        SizedBox(width: 10.0),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

}
