import 'package:baniadam/screens/approver/attendance_detail_for_admin.dart';
import 'package:baniadam/screens/approver/track_map.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:baniadam/widgets/base_state.dart';
import 'package:intl/intl.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/screens/dashboard.dart';
import '../../data_provider/api_service.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnTimeEmployeeListPage extends StatefulWidget {
  OnTimeEmployeeListPage({
    Key key,
  }) : super(key: key);

  @override
  _OnTimeEmployeeListPageState createState() =>
      _OnTimeEmployeeListPageState();
}

class _OnTimeEmployeeListPageState
    extends BaseState<OnTimeEmployeeListPage> {
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
  final format = DateFormat('yyyy-MM-dd');


  @override
  void initState() {
    selectedDate = DateTime.now();
    filters = new Map();
    attendanceList = [];
    newAttendanceList = [];
    _getAttendanceList();
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _getMoreAttendanceList();
////        _getAttendanceList();
//      }
//    });
    super.initState();
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
      if (!isPerformingRequest) {
        isPerformingRequest = true;
      }
    });


    Map<String, dynamic> attendenceData =
    await ApiService.getOnTimeEmployee();
    if (attendenceData != null) {
      _refreshList = false;
      print(attendenceData['data']);
      setState(() {
        currentPage = attendenceData['current_page'];
        lastPage = attendenceData['last_page'];
        attendanceList.addAll(attendenceData['data']);
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

      final Map<String, dynamic> attendenceData =
      await ApiService.getOnTimeEmployee();
      if (attendenceData != null) {
        setState(() {
          attendanceList.addAll(attendenceData['data']);
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

  @override
  Widget build(BuildContext context) {
    return
//      WillPopScope(
//        onWillPop: _onBackPressed,
//        child:
      Scaffold(
          appBar: AppBar(
            title: Text('On time today'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _refreshData();
                },
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
//              return _makeListItemUI(context, index);
                currentId = newAttendanceList.elementAt(index)['id'];
                return previousId != currentId
                    ? _makeListItemUI(context, index)
                    : null;
              },

              controller: widget.scrollController,
            ),
          ));
    }
    if (refreshData)
      return Container(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height * 1 / 2),
          child: Center(
            child: CircularProgressIndicator(),
          ));
    return Container(
//                padding:EdgeInsets.only(top:MediaQuery.of(context).size.height * 1/2),
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

  Widget _listItemUI(
      {Map<String, dynamic> listData, BuildContext context, index}) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Colors.grey.shade500),
                        ),
                        padding: const EdgeInsets.only(left: 0.0),
                        height: 60.0,
                        width: 50.0,
                        child: baseCdnUrl == null
                            ? Material(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40.0,
                                )))
                            : Material(
                            borderRadius: BorderRadius.circular(5.0),
                            child: listData['photoAttachment'] == null ||
                                listData['photoAttachment'] == ""
                                ? Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40.0,
                                ))
//                                : Image.network('http://testcdn.ideaxen.net/test/' + listData['photoAttachment']))),
                                : Image.network(baseCdnUrl +
                                listData['photoAttachment']))
//                                  : Image.network(imageUrl))

                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
//                      padding: EdgeInsets.all(18.0),
                        margin: EdgeInsets.only(top: 5.0),
                        child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width:
                              MediaQuery.of(context).size.width * 2.5 / 5,
                              child: Text(
                                listData['fullName'],
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
//                            Wrap(
//                              direction: Axis.vertical,
//                              spacing: 0.0,
//                              runSpacing: 5.0,
//                              children: <Widget>[
//                                Text(
//                                  listData['fullName'],
//                                  style: TextStyle(fontSize: 15.0),
//                                ),
//                              ],
//                            ),
//                            Wrap(
//                              direction: Axis.vertical,
//                              spacing: 0.0,
//                              runSpacing: 5.0,
//                              children: <Widget>[
//                                Text(
//                                  listData['department']['value'],
//                                  style: TextStyle(fontSize: 12.0),
//                                ),
//                                Text(
//                                  listData['designation']['value'],
//                                  style: TextStyle(fontSize: 12.0),
//                                ),
//                              ],
//                            )
                          ],
                        )),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.alarm_on),
            onTap: () async {
              final Map<String, dynamic> attendenceData =
              await ApiService.getCurrentDateAttendanceDetail(
                  listData['id'],
                  DateFormat('yyyy-MM-dd').format(DateTime.now()));
              if (attendenceData != null) {
                setState(() {
                  attendanceDetail.addAll(attendenceData);
                });
              }
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AttendanceDetail(
                          attendanceItems: attendanceDetail['attendance'])));
            },
//            onTap: () async {
//              final List<dynamic> trackingData =
//              await ApiService.getCurrentDateTrackingDetail(
//                  listData['id'],
//                  DateFormat('yyyy-MM-dd').format(widget.selectedDate));
//              if (trackingData != null) {
//                setState(() {
//                  trackDataList.addAll(trackingData);
//                });
//              }
//              Navigator.pushReplacement(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => TrackMap(
//                          trackData: trackDataList,date:DateFormat('yyyy-MM-dd').format(widget.selectedDate))));
//            },
          ),
        ],
      ),
    );
  }

}
