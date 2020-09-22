import 'package:baniadam/screens/dashboard.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:baniadam/widgets/attendence_approval_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/widgets/attendance_filter_dialog.dart';

class AttendanceListPage extends StatefulWidget {
  AttendanceListPage({
    Key key,
  }) : super(key: key);

  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  Map<String, dynamic> personalDetail;
  List personalAttendenceList;
  List attendenceList;
  List newAttendenceList;
  Map<String, dynamic> filters;
  DateTime now;
  int userType;
  String titleDurationHeader = 'Today\'s';
  String titleStatusHeader = 'pending';
  String currentAttendanceFlag;

  bool _isInButtonDisabled = true;
  bool _isOutButtonDisabled = true;

  Color _buttonDisableColor;
  String getFlag;

  String empId;
  int id;
  String _pickedDuration = "today";
  String _pickedStatus = "pending";
  String userRole;
  int currentPage = 1;
  int lastPage;
  int nextPage;

  bool _refreshList = false;

  @override
  void initState() {
    filters = new Map();
    filters['duration'] = _pickedDuration;
    filters['status'] = _pickedStatus;
    personalAttendenceList = [];
    attendenceList = [];
    newAttendenceList = [];
    _getAttendanceList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreAttendanceList();
      }
    });

    super.initState();
  }

  _refreshData() {
    filters['duration'] = _pickedDuration;
    filters['status'] = _pickedStatus;
    personalAttendenceList = [];
    attendenceList = [];
    newAttendenceList = [];
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

    Map<String, dynamic> attendenceData =
    await ApiService.getAttendanceList(filters);
    if (attendenceData != null) {
      _refreshList = false;
      print(attendenceData['data']);
      setState(() {
        currentPage = attendenceData['current_page'];
        lastPage = attendenceData['last_page'];
        attendenceList.addAll(attendenceData['data']);
        print(attendenceList.length.toString());
      });
    }
  }

  void _getMoreAttendanceList() async {
//    if (!isPerformingRequest) {
//      setState(() => isPerformingRequest = true);
//    }

    newAttendenceList.clear();

    if (currentPage < lastPage) {
      setState(() {
        currentPage += 1;
        filters['page'] = currentPage;
      });
      final Map<String, dynamic> attendenceData =
      await ApiService.getAttendanceList(filters);
      if (attendenceData != null) {
        print(attendenceData['data']);
        setState(() {
          newAttendenceList.addAll(attendenceData['data']);
          attendenceList.addAll(newAttendenceList);
          print(attendenceList.length.toString());
          print(newAttendenceList);
        });
      }
    } else if (currentPage == lastPage) {}
  }

  _attendancListItemUI() {
    if (attendenceList.isNotEmpty)
      return AdminAttendenceItemListWidget(
        attendenceItems: attendenceList,
        scrollController: _scrollController,
        isPerformingRequest: isPerformingRequest,
        filters: filters,
      );
  }


  Future<Map<String, dynamic>> _flterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AttendanceFilterDialog(),
    );
  }

  Widget attendanceListWidget() {
    return !_refreshList
        ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Container(
          child: Center(
            child: filters['from'] != null && filters['from'] != null
                ? Column(
              children: <Widget>[
                Text(
                  titleStatusHeader.substring(0, 1).toUpperCase() +
                      titleStatusHeader.substring(1) +
                      ' ' +
                      ' requests within ',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  titleDurationHeader,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
                : Text(
              titleDurationHeader +
                  ' ' +
                  titleStatusHeader +
                  ' requests',
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          child: _attendancListItemUI(),
        )
      ],
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }


  Future<bool> _onBackPressed() {
    Navigator.push(
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
            title: Text('Attendance requests'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _refreshData();
                },
              ),
              PopupMenuButton<String>(
                  onSelected: (val) async {
                    switch (val) {
                      case 'FILTER':
                        debugPrint('filter');
//                  _getFilterData();
                        var newFilters = await _flterDialog(context);
                        if (newFilters != filters) {
                          setState(() {
                            filters = newFilters;
                          });
                        }
                        if (filters['duration'] == 'all' &&
                            filters['status'] != null &&
                            filters['status'] == 'all') {
                          setState(() {
                            titleStatusHeader = '';
                          });
                        } else if (filters['status'] != null) {
                          titleStatusHeader = filters['status'];
                        }

                        if (filters['duration'] != null &&
                            filters['duration'] != 'all') {
                          if (filters['duration'] == 'today') {
                            setState(() {
                              titleDurationHeader = 'Today\'s';
                            });
                          } else if (filters['duration'] == 'yesterday') {
                            titleDurationHeader = 'Yesterday\'s';
                          } else if (filters['duration'] == 'week') {
                            setState(() {
                              titleDurationHeader = 'Current week\'s';
                            });
                          }
                        } else if (filters['duration'] != null &&
                            filters['duration'] == 'all') {
                          titleDurationHeader = 'All';
                        } else {
                          titleDurationHeader = DateFormat.yMMMd()
                              .format(DateTime.parse(filters['from'])) +
                              '  to  ' +
                              DateFormat.yMMMd()
                                  .format(DateTime.parse(filters['to']));
                        }
                        attendenceList = [];
                        _getAttendanceList();
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      value: 'FILTER',
                      child: Text('Attendance filter'),
                    ),
                  ]),
            ],
          ),
          body: SingleChildScrollView(
              child: Container(
                child:
                attendenceList.length > 0
                    ?
                attendanceListWidget()
                    : Container(
                    alignment: Alignment.center,
                    child: Text(
                      'No attendance request',
                      style: TextStyle(fontSize: 20.0),
                    )),
              )),
//        )
    );
  }
}



class AdminAttendenceItemListWidget extends StatefulWidget {
  final List attendenceItems;
  final ScrollController scrollController;
  final bool isPerformingRequest;
  final Map<String, dynamic> filters;

  AdminAttendenceItemListWidget(
      {this.attendenceItems,
        this.scrollController,
        this.isPerformingRequest,
        this.filters});

  @override
  _AdminAttendenceItemListWidgetState createState() =>
      _AdminAttendenceItemListWidgetState();
}

class _AdminAttendenceItemListWidgetState extends State<AdminAttendenceItemListWidget> {
  Map<int, dynamic> _declineReasons;
  Map<String, dynamic> data;
  int selectedValue;
  TextEditingController commetnController;
  bool refreshData = false;
  List newAttendenceList;

  int currentPage;
  int lastPage;

  @override
  void initState() {
//    if (widget.attendenceItems.isNotEmpty) {
    currentPage = widget.attendenceItems[0]['current_page'];
    lastPage = widget.attendenceItems[0]['last_page'];
    newAttendenceList = widget.attendenceItems;
//    }
    _declineReasons = new Map();
    data = Map();
//    _getDeclineReasons();
    commetnController = TextEditingController();

//    widget.scrollController.addListener(() {
//      if (widget.scrollController.position.pixels ==
//          widget.scrollController.position.minScrollExtent) {
//        _getRefreshData();
//      }
//    });
    super.initState();
  }

  void _getRefreshData() async {
    setState(() {
      refreshData = true;
    });
    newAttendenceList = [];
    final Map<String, dynamic> attendenceData =
    await ApiService.getAttendanceList(widget.filters);
    if (attendenceData != null) {
      refreshData = false;
      newAttendenceList.addAll(attendenceData['data']);
      print(newAttendenceList);
//        setState(() {
//          newAttendenceList.addAll(attendenceData['data']);
//          print(newAttendenceList);
//        });
    }
  }

  Future<Map<String, dynamic>> _flterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AttendanceFilterDialog(),
    );
  }

  Future<List> _approveAttendance(BuildContext context, id, type) async {
    return await showDialog<List>(
      context: context,
      builder: (BuildContext context) =>
          AttendenceApprovalDialog(id: id, type: type, filters: widget.filters),
    );
//    if (data != null) {
//      newAttendenceList = [];
//        setState(() {
//          newAttendenceList.addAll(data);
//          print(newAttendenceList.length.toString());
//        });
//    }
  }

  Widget _listBody(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            widget.attendenceItems.isNotEmpty
                ? Container(
                child: !refreshData
                    ? Container(
                  padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: newAttendenceList.length ,
                    itemBuilder: (BuildContext context, int index) {
                      return _makeListItemUI(index, context);
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

//    return Container(
//        child: Column(
//          children: <Widget>[
//            widget.attendenceItems.isNotEmpty
//                ? Container(
//                child: !refreshData
//                    ? Container(
//                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//                  child: ListView.builder(
//                    shrinkWrap: true,
//                    physics: ScrollPhysics(),
//                    itemCount: newAttendenceList.length,
//                    itemBuilder: (BuildContext context, int index) {
//                      return _makeListItemUI(index, context);
//                    },
//                    controller: widget.scrollController,
//                  ),
//                )
//                    : Center(
//                  child: CircularProgressIndicator(),
//                ))
//                : Text('No attendance data'),
//          ],
//        ));
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//        width: MediaQuery.of(context).size.width,
//        height: MediaQuery.of(context).size.height,

    return _listBody(context);
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: widget.isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  _makeListItemUI(int index, BuildContext context) {
    if (index >= newAttendenceList.length) {
      return null;
    }
    return _listItemUI(
        listData: newAttendenceList.elementAt(index),
        context: context,
        index: index);
  }

  DateTime date;

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
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(
                        listData['employee']['fullName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      decoration: ShapeDecoration(
                          shape: AppTheme.roundedBorderDecoration(),
                          color: listData['status'] == "PENDING"
                              ? Color(0xFF5BC0DE)
                              : listData['status'] == "APPROVED"
                              ?Color(0xFF5CB85C):Color(0xFFD9534F)
//                                  ? Colors.blue
//                                  : Colors.red,
//                      color:Color(0xFF999999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            listData['status'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text('Date :' +
                          DateFormat.yMMMEd()
                              .format(DateTime.parse(listData['date']))),
                    ),

                  ],
                ),

              ],
            ),
            subtitle: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
//                          margin: EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Reason: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Container(
//                          margin: EdgeInsets.only(top: 5.0),
                            child: listData['request_reason'] != null
                                ? Text(
//                        'Request Reason: ' +
                                listData['request_reason']['value'])
                                : Text('Not mensioned'),
                          ),
                        ],
                      ),
//                      margin: EdgeInsets.only(top: 5.0),
//                      child: listData['request_reason'] != null ? Text(
////                        'Request Reason: ' +
//                          listData['request_reason']['value']
//                      ):Text('Not mensioned'),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFD8EAFB)),
                                borderRadius: BorderRadius.circular(10.0)),
                            height: 25.0,
                            width: 35.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(18.0),
//                        shadowColor: Colors.greenAccent,
//                              color: Theme.of(context).backgroundColor,
                              color: listData['flag'] == 'in' ? Color(0xFFD8EAFB):Color(0xFFFBAC78),
//                            elevation: 7.0,
                              child: Center(
                                child: Text(listData['flag']),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Text('at ' + listData['time']),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                listData['status'] != "PENDING"
                    ? SizedBox(
                  width: 0.0,
                  height: 0.0,
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: 100.0,
                        height: 30.0,
                        color: Theme.of(context).buttonColor,
                        child: Center(
                            child: Text(
                              'DECLINE',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      onTap: () async {
                        print('decline');
                        List data = await _approveAttendance(
                            context, listData['id'], 'DECLINED');
                        if (data != null) {
                          newAttendenceList = [];
                          setState(() {
                            newAttendenceList.addAll(data);
                            print('data length: ' +
                                newAttendenceList.length.toString());
                          });
                        }
                      },
                    ),
                    SizedBox(width: 10.0),
                    InkWell(
                      child: Container(
                        width: 100.0,
                        height: 30.0,
                        color: Theme.of(context).buttonColor,
                        child: Center(
                            child: Text(
                              'APPROVE',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      onTap: () async {
                        List data = await _approveAttendance(
                            context, listData['id'], 'APPROVED');
                        if (data != null) {
                          newAttendenceList = [];
                          setState(() {
                            newAttendenceList.addAll(data);
                            print('data length: ' +
                                newAttendenceList.length.toString());
                          });
                        }
//                      );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
//          leading: getIcon(leavesList.data),
      ),
    );
  }
}

