import 'package:baniadam/screens/dashboard.dart';
import 'package:baniadam/widgets/attendance_request_approval_dialog.dart';
import 'package:baniadam/widgets/attendance_request_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/widgets/leave_filter_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../style/app_theme.dart';
import '../../data_provider/api_service.dart';
import '../../models/leaveList.dart';
import 'package:intl/intl.dart';
import 'leave_request_detail.dart';
import '../../widgets/leave_approval_dialog.dart';
import 'package:baniadam/widgets/base_state.dart';


class AttendanceRequestListPageForAdmin extends StatefulWidget {

  AttendanceRequestListPageForAdmin({
    Key key,
  }) : super(key: key);

  @override
  _AttendanceRequestListPageForAdminState createState() => _AttendanceRequestListPageForAdminState();
}

class _AttendanceRequestListPageForAdminState extends BaseState<AttendanceRequestListPageForAdmin> {
  LeavesList leaveList;
  List leaveListItem = [];
  List newLeaveListItem;
  String leave;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  int currChunk = 1;
  int lastItemId = 0;

  int currentPage;
  int lastPage;
  int nextPage;
  String title;
  Map<String, dynamic> filters;

  @override
  void initState() {
    super.initState();
    filters = new Map();
    newLeaveListItem = [];
    _getListItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getNewListItems();
      }
    });
  }

  void _getListItems() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
    }
    leaveListItem.clear();
    final Map<String, dynamic> data = await ApiService.getAttendanceRequestListForAdmin(filters);
    isPerformingRequest = false;
    if (data == null) {
//      if (leaveList == null) animateScrollBump();
      if (leaveList != null) {
        setState(() {});
      }
    } else {
      setState(() {
        currentPage = data['current_page'];
        lastPage = data['last_page'];
        leaveListItem.addAll(data['data']);
        print("leave list count - " + leaveListItem.length.toString());
      });
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
          leaveListItem.addAll(newLeaveListItem);
          print(leaveListItem.length.toString());
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

  Future<Map<String, dynamic>> _attendanceFlterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AttendanceRequestFilterDialog(),
    );
  }

  Future<bool> _onBackPressed() async{
    Navigator.of(context).pop();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('statusList');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
            appBar: AppBar(
              title: Text('Attendance requests'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _getListItems();
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
                            title = '';
                          });
                          if (filters['status'] != null) {
                            List allStatus = [];
                            for(int i = 0;i <filters['status'].length; i++)
                            {
                              allStatus.add(filters['status'][i]);
                            }
                            setState(() {
                              title += 'Status : ' + allStatus.toString();
                            });
                          }
                        }
                        _getListItems();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
//                  Container(
//                    child: Center(
//                        child: Column(
//                          children: <Widget>[
//                            title != '' && title != null
//                                ? Text(
//                              'Filtered by',
//                              style: TextStyle(
//                                  color: Theme.of(context).primaryColor,
//                                  fontSize: 20.0,
//                                  fontWeight: FontWeight.bold),
//                            )
//                                : SizedBox(
//                              width: 0.0,
//                              height: 0.0,
//                            ),
//                            title != '' && title != null
//                                ? Text(
//                              title,
//                              style: TextStyle(
//                                  color: Theme.of(context).primaryColorDark,
//                                  fontSize: 15.0),
////                            style: Theme.of(context).textTheme.title,
//                            )
//                                : SizedBox(
//                              width: 0.0,
//                              height: 0.0,
//                            ),
//                          ],
//                        )),
//                  ),
                  Container(
                    child: leaveListDataWidget(),
                  ),
                ],
              ),
            )));
  }

  Widget leaveListDataWidget() {
    if (leaveListItem.isNotEmpty) //has data & performing/not performing
      return LeaveItemListWidget(
          leaveItems: leaveListItem,
          scrollController: _scrollController,
          isPerformingRequest: isPerformingRequest,
          filters: filters,
          title: title);
    if (isPerformingRequest)
      return Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1/2),
          child:Center(
            child: CircularProgressIndicator(),)
      );

    return
      Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1/2),
          child:Center(
            child: Text('no list item'),)
      );
  }
}

class LeaveItemListWidget extends StatefulWidget {
  final List leaveItems;
  final ScrollController scrollController;
  final bool isPerformingRequest;
  final Map<String, dynamic> filters;
  final title;

  LeaveItemListWidget(
      {this.leaveItems,
        this.scrollController,
        this.isPerformingRequest,
        this.filters,
        this.title});

  @override
  _LeaveItemListWidgetState createState() => _LeaveItemListWidgetState();
}

class _LeaveItemListWidgetState extends State<LeaveItemListWidget> {
  List newLeaveItems;
  String baseCdnUrl;

  @override
  void initState() {
    getCDN();
    newLeaveItems = widget.leaveItems;
    super.initState();
  }

  getCDN()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var portalID = prefs.getString('curr-cid');
    if(portalID != null){
      setState(() {
        baseCdnUrl = ApiService.CDN_URl+"$portalID/";
      });

    }
  }

  Future<List> _approveAttendance(BuildContext context, id, approveType) async {
    return await showDialog<List>(
      context: context,
      builder: (BuildContext context) => AttendanceRequestApprovalDialog(
        id: id,
        type: approveType,
        filters: widget.filters,
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
//            Center(child: Text('Today\'s Pending Request',style: Theme.of(context).textTheme.title,),),
                Center(child:Container(
                  color: Color(0xFFF7F7F7),

                  padding: widget.title == null
                      ? EdgeInsets.only(top: 5.0, bottom: 40.0)
                      : EdgeInsets.only(top: 5.0, bottom: 140.0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 4.5/5,
                  child: ListView.builder(
                    itemCount: newLeaveItems.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == newLeaveItems.length) {
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
                      }
                    },
                    controller: widget.scrollController,
                  ),
                ))
              ],
            )));
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: widget.isPerformingRequest ? 1.0 : 0.0,
          child: Center(child:CircularProgressIndicator()),
        ),
      ),
    );
  }

  _makeListItemUI(int index, BuildContext context) {
    if (index >= newLeaveItems.length) {
      return null;
    }
    return _listItemUI(
        leaves: newLeaveItems.elementAt(index), context: context, index: index);
  }

  String convert12(String s) {
    String finalTime;
    String str = s.substring(0,5);
    int h1 = int.parse(str.substring(0,1)) - 0;
    int h2 = int.parse(str.substring(1,2));
    int hh = h1 * 10 + h2;

    String Meridien;
    if (hh < 12) {
      Meridien = " AM";
    } else
      Meridien = " PM";
    hh %= 12;
    if (hh == 0 && Meridien == ' PM') {
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
      {Map<String, dynamic> leaves, BuildContext context, index}) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
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
                          width:MediaQuery.of(context).size.width * 3.5/5,
                          child: Text(
                            leaves['employee']['fullName'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
//                      width:MediaQuery.of(context).size.width * 2/5,
                          padding: EdgeInsets.all(5.0),
//                      padding: EdgeInsets.only(
//                          left: 15.0, right: 0.0, top: 5.0, bottom: 5.0),
                          decoration: ShapeDecoration(
                            shape: AppTheme.roundedBorderDecoration(),
                            color: Color(0xFF999999),
//                      color:Color(0xFF999999),
                          ),
                          child:Center(child:Text(
                            leaves['status'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
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
                              color: leaves['flag'] == 'in'
                                  ? Color(0xFFAFF0B2)
                                  : Color(0xFFFFCB96),
                              child: Center(
                                child: Text(
                                  leaves['flag'],
                                  style: TextStyle(
                                      color:Colors.black),
                                ),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Text('request for ' +
                            convert12(leaves['time']) + '  ' +
                            DateFormat('d-MMM-yy').format(DateTime.parse(leaves['date']))
                          ,style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Text(
                                  'Applied on: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 2 / 5,
                                child: leaves['created_at'] != null
                                    ? Text(DateFormat.yMMMd().format(
                                    DateTime.parse(leaves['created_at'])))
                                    : Text('No data')),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    leaves['status'] =="Requested for Cancellation"?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                child: Text(
                                  'Request type: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 3 / 5,
                              child:Text('Leave cancelation request',style: TextStyle(color: Colors.red),),
                            )
                          ],
                        ),
                      ],
                    ):SizedBox(width: 0.0,height: 0.0,),
                    SizedBox(
                      height: 10.0,
                    ),
                    leaves['status'] == "PENDING"
                        ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: 100.0,
                              height: 30.0,
                              color: Theme.of(context).buttonColor,
                              child: Center(
                                  child: Text(
                                    'Decline',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            onTap: () async {
                              List data = await _approveAttendance(
                                  context, leaves['id'], 'DECLINED');
                              if (data != null) {
                                newLeaveItems = [];
                                setState(() {
                                  newLeaveItems.addAll(data);
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
                                    'Approve',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            onTap: () async {
                              List data = await _approveAttendance(
                                  context, leaves['id'], 'APPROVED');
                              if (data != null) {
                                newLeaveItems = [];
                                setState(() {
                                  newLeaveItems.addAll(data);
                                });
                              }
                            },
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
                  ],
                ),

//                onTap: () {
//                  print(leaves['reason']);
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) =>
//                              LeaveRequestDetailPage(id: leaves['id'])));
//                },
              ),
            ],
          )),
    );
  }
}
