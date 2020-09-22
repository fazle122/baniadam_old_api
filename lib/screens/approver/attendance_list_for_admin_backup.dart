//import 'package:baniadam/screens/approver/attendance_detail_for_admin.dart';
//import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:baniadam/widgets/base_state.dart';
//import 'package:intl/intl.dart';
//import 'package:baniadam/data_provider/api_service.dart';
//import 'package:baniadam/widgets/attendance_filter_dialog.dart';
//import 'package:baniadam/screens/dashboard.dart';
//import 'package:baniadam/style/app_theme.dart';
//import '../../data_provider/api_service.dart';
//import 'package:baniadam/widgets/attendence_approval_dialog.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//
//
//class AttendanceListPageForAdmin extends StatefulWidget {
//  AttendanceListPageForAdmin({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  _AttendanceListPageForAdminState createState() =>
//      _AttendanceListPageForAdminState();
//}
//
//class _AttendanceListPageForAdminState
//    extends BaseState<AttendanceListPageForAdmin> {
//  ScrollController _scrollController = new ScrollController();
//  bool isPerformingRequest = false;
//  Map<String, dynamic> personalDetail;
//  List attendanceList;
//  List newAttendanceList;
//  Map<String, dynamic> filters;
//  String titleDurationHeader = 'Today\'s';
//  String titleStatusHeader = 'pending';
//
//  String _pickedDuration = "today";
//  String _pickedStatus = "pending";
//  int currentPage;
//  int lastPage;
//  int nextPage;
//  bool _refreshList = false;
//
//  @override
//  void initState() {
//    filters = new Map();
//    filters['duration'] = _pickedDuration;
//    filters['status'] = _pickedStatus;
//    attendanceList = [];
//    newAttendanceList = [];
//    _getAttendanceList();
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _getMoreAttendanceList();
//      }
//    });
//    super.initState();
//  }
//
//  _refreshData() {
//    filters['duration'] = _pickedDuration;
//    filters['status'] = _pickedStatus;
//    attendanceList = [];
//    newAttendanceList = [];
//    _getAttendanceList();
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _getMoreAttendanceList();
//      }
//    });
//  }
//
//  void _getAttendanceList() async {
//    setState(() {
//      _refreshList = true;
//    });
//    if (!isPerformingRequest) {
//      setState(() => isPerformingRequest = true);
//    }
//
//    Map<String, dynamic> attendenceData =
//        await ApiService.getAttendanceList(filters);
//    if (attendenceData != null) {
//      _refreshList = false;
//      print(attendenceData['data']);
//      setState(() {
//        currentPage = attendenceData['current_page'];
//        lastPage = attendenceData['last_page'];
//        attendanceList.addAll(attendenceData['data']);
//        print(attendanceList.length.toString());
//      });
//    }
//  }
//
//  void _getMoreAttendanceList() async {
//    if (!isPerformingRequest) {
//      setState(() => isPerformingRequest = true);
//    }
//
//    newAttendanceList.clear();
//
//    if (currentPage < lastPage) {
//      setState(() {
//        currentPage += 1;
//        filters['page'] = currentPage;
//      });
//      final Map<String, dynamic> attendenceData =
//          await ApiService.getAttendanceList(filters);
//      if (attendenceData != null) {
//        print(attendenceData['data']);
//        setState(() {
//          newAttendanceList.addAll(attendenceData['data']);
//          attendanceList.addAll(newAttendanceList);
//          print(attendanceList.length.toString());
//          print(newAttendanceList);
//        });
//      }
//    } else if (currentPage == lastPage) {}
//  }
//
//  _attendancListItemUI() {
//    if (attendanceList.isNotEmpty) //has data & performing/not performing
//      return AdminAttendenceListItemWidget(
//        attendanceItems: attendanceList,
//        scrollController: _scrollController,
//        isPerformingRequest: isPerformingRequest,
//        filters: filters,
//      );
//  }
//
//  Future<Map<String, dynamic>> _flterDialog(BuildContext context) async {
//    return showDialog<Map<String, dynamic>>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) => AttendanceFilterDialog(),
//    );
//  }
//
//  Widget attendanceListWidget() {
//    return !_refreshList
//        ? Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              SizedBox(
//                height: 10.0,
//              ),
////              Container(
////                child: Center(
////                  child: filters['from'] != null && filters['from'] != null
////                      ? Column(
////                          children: <Widget>[
////                            Text(
////                              titleStatusHeader.substring(0, 1).toUpperCase() +
////                                  titleStatusHeader.substring(1) +
////                                  ' ' +
////                                  ' requests within ',
////                              style: Theme.of(context).textTheme.title,
////                            ),
////                            SizedBox(
////                              height: 5.0,
////                            ),
////                            Text(
////                              titleDurationHeader,
////                              style: TextStyle(
////                                  color: Theme.of(context).primaryColorDark,
////                                  fontWeight: FontWeight.bold),
////                            )
////                          ],
////                        )
////                      : Text(
////                          titleDurationHeader +
////                              ' ' +
////                              titleStatusHeader +
////                              ' requests',
////                          style: Theme.of(context).textTheme.title,
////                        ),
////                ),
////              ),
////              SizedBox(
////                height: 10.0,
////              ),
//              Container(
//                child: _attendancListItemUI(),
//              )
//            ],
//          )
//        : Container(
//            height: MediaQuery.of(context).size.width,
//            child: Center(
//              child: CircularProgressIndicator(),
//            ));
//  }
//
//  Future<bool> _onBackPressed() {
//    Navigator.pushReplacement(
//        context, MaterialPageRoute(builder: (context) => DashboardPage()));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//        onWillPop: _onBackPressed,
//        child: Scaffold(
//            appBar: AppBar(
//              title: Text('Attendance List'),
//              actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.refresh),
//                  onPressed: () {
//                    _refreshData();
//                  },
//                ),
//
//              ],
//            ),
//            body: SingleChildScrollView(
//                child: Container(
//                  color: Color(0xFFF7F7F7),
//                  child: attendanceList.length > 0
//                  ? Center(child:attendanceListWidget())
//                  : Container(
//                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1/2),
//                      alignment: Alignment.center,
////                      child: Align(
////                        alignment: Alignment.center,
////                        child: CircularProgressIndicator(),
////                      )
//                      child: Center(child:Text(
//                        'No attendance data',
//                        style: TextStyle(fontSize: 20.0),
//                      ),)
//                  ),
//            ))));
//  }
//}
//
//class AdminAttendenceListItemWidget extends StatefulWidget {
//  final List attendanceItems;
//  final ScrollController scrollController;
//  final bool isPerformingRequest;
//  final Map<String, dynamic> filters;
//
//  AdminAttendenceListItemWidget(
//      {this.attendanceItems,
//      this.scrollController,
//      this.isPerformingRequest,
//      this.filters});
//
//  @override
//  _AdminAttendenceListItemWidgetState createState() =>
//      _AdminAttendenceListItemWidgetState();
//}
//
//class _AdminAttendenceListItemWidgetState
//    extends BaseState<AdminAttendenceListItemWidget> {
//  bool refreshData = false;
//  List newAttendanceList;
//  int currentPage;
//  int lastPage;
//  Map attendanceDetail;
//  String baseCdnUrl;
//
//
//  @override
//  void initState() {
//    getCDN();
//    attendanceDetail = Map();
////    if (widget.attendenceItems.isNotEmpty) {
//    currentPage = widget.attendanceItems[0]['current_page'];
//    lastPage = widget.attendanceItems[0]['last_page'];
//    newAttendanceList = widget.attendanceItems;
////    }
//
////    widget.scrollController.addListener(() {
////      if (widget.scrollController.position.pixels ==
////          widget.scrollController.position.minScrollExtent) {
////        _getRefreshData();
////      }
////    });
//    super.initState();
//  }
//
//  getCDN()async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var portalID = prefs.getString('curr-cid');
//    if(portalID != null){
//      setState(() {
//        baseCdnUrl = "https://cdn.baniadam.app/$portalID/";
//      });
//
//    }
//  }
//
//  Future<Map<String, dynamic>> _flterDialog(BuildContext context) async {
//    return showDialog<Map<String, dynamic>>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) => AttendanceFilterDialog(),
//    );
//  }
//
//  Future<List> _approveAttendance(BuildContext context, id, type) async {
//    return await showDialog<List>(
//      context: context,
//      builder: (BuildContext context) =>
//          AttendenceApprovalDialog(id: id, type: type, filters: widget.filters),
//    );
////    if (data != null) {
////      newAttendenceList = [];
////        setState(() {
////          newAttendenceList.addAll(data);
////          print(newAttendenceList.length.toString());
////        });
////    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//        child: Column(
//      children: <Widget>[
//        widget.attendanceItems.isNotEmpty
//            ? Container(
//                child: !refreshData
//                    ? Container(
//                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//                  height: MediaQuery.of(context).size.height - 100.0,
//                  width: MediaQuery.of(context).size.width * 4.5/5,
//                        child: ListView.builder(
////                          shrinkWrap: true,
////                          physics: ScrollPhysics(),
//                          itemCount: newAttendanceList.length,
//                          itemBuilder: (BuildContext context, int index) {
//                            return Container(
//                                child: Column(
//                                  children: <Widget>[
//                                    _makeListItemUI(index, context),
//                                    SizedBox(
//                                      height: 10.0,
//                                    )
//                                  ],
//                                ));
//                          },
//                          controller: widget.scrollController,
//                        ),
//                      )
//                    : Center(
//                        child: CircularProgressIndicator(),
//                      ))
//            : Container(
//                height: MediaQuery.of(context).size.width,
//                child: Center(
////                  child: Text('No attendance data'),
//                  child: CircularProgressIndicator(),
//                )),
//      ],
//    ));
//  }
//
//  _makeListItemUI(int index, BuildContext context){
//    if (index >= newAttendanceList.length) {
//      return null;
//    }
//    return _listItemUI(
//        listData: newAttendanceList.elementAt(index),
//        context: context,
//        index: index);
//  }
//
//
//
//  Widget _listItemUI(
//      {Map<String, dynamic> listData, BuildContext context, index}) {
//    return  Card(
//      color:Colors.white,
//      elevation: 4.0,
//      child: Column(
//        children: <Widget>[
//          ListTile(
//            title: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Container(
//                        decoration: BoxDecoration(
//                          border: Border.all(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
//                        ),
//                        padding: const EdgeInsets.only(left: 0.0),
//                        height: 60.0,
//                        width: 50.0,
//                        child: baseCdnUrl == null?
//                        Material(
//                            borderRadius: BorderRadius.circular(5.0),
//                            child:Center(
//                                child: Icon(
//                                  Icons.person,
//                                  size: 40.0,
//                                )))
//                        :
//                        Material(
//                            borderRadius: BorderRadius.circular(5.0),
//                            child: listData['photoAttachment'] == null ||
//                                listData['photoAttachment'] == ""
//                                ? Center(
//                                child: Icon(
//                                  Icons.person,
//                                  size: 40.0,
//                                ))
////                                : Image.network('http://testcdn.ideaxen.net/test/' + listData['photoAttachment']))),
//                                : Image.network(baseCdnUrl + listData['photoAttachment']))
////                                  : Image.network(imageUrl))
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Container(
////                      padding: EdgeInsets.all(18.0),
//                        margin: EdgeInsets.only(top: 5.0),
//                        child: Column(
////                        mainAxisAlignment: MainAxisAlignment.start,
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Container(
//                              width: MediaQuery.of(context).size.width *2.5/5,
//                              child: Text(
//                                listData['fullName'],
//                                style: TextStyle(fontSize: 15.0),
//                              ),
//                            ),
//                            Container(
//                              width: MediaQuery.of(context).size.width *2.5/5,
//                              child: Text(
//                                listData['department']['value'],
//                                style: TextStyle(fontSize: 12.0),
//                              ),
//                            ),
//                            Container(
//                              width: MediaQuery.of(context).size.width *2.5/5,
//                              child: Text(
//                                listData['designation']['value'],
//                                style: TextStyle(fontSize: 12.0),
//                              ),
//                            ),
////                            Wrap(
////                              direction: Axis.vertical,
////                              spacing: 0.0,
////                              runSpacing: 5.0,
////                              children: <Widget>[
////                                Text(
////                                  index.toString() + listData['fullName'],
////                                  style: TextStyle(fontSize: 15.0),
////                                ),
////                              ],
////                            ),
////                            Wrap(
////                              direction: Axis.vertical,
////                              spacing: 0.0,
////                              runSpacing: 5.0,
////                              children: <Widget>[
////                                Text(
////                                  listData['department']['value'],
////                                  style: TextStyle(fontSize: 12.0),
////                                ),
////                                Text(
////                                  listData['designation']['value'],
////                                  style: TextStyle(fontSize: 12.0),
////                                ),
////                              ],
////                            )
//                          ],
//                        )),
//                  ],
//                ),
//              ],
//            ),
//            trailing: Icon(Icons.alarm_on),
//            onTap: () async {
//              final Map<String, dynamic> attendenceData =
//              await ApiService.getCurrentDateAttendanceDetail(listData['id'],DateFormat('yyyy-MM-dd').format(DateTime.now()));
//              if (attendenceData != null) {
//                setState(() {
//                  attendanceDetail.addAll(attendenceData);
//                });
//              }
//              Navigator.pushReplacement(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) =>
//                          AttendanceDetail(attendanceItems: attendanceDetail['attendance'])));
//            },
//          ),
//        ],
//      ),
//    );
//  }
//}
