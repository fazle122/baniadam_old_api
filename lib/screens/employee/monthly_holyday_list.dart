import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/screens/employee/monthly_attendance_detail.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/leaveList.dart';
import 'package:intl/intl.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:baniadam/widgets/personal_attendance_filter_dialog.dart';

class MonthlyHolydayListPage extends StatefulWidget {
  final int id;

  MonthlyHolydayListPage({
    this.id,
    Key key,
  }) : super(key: key);

  @override
  _MonthlyHolydayListPageState createState() =>
      _MonthlyHolydayListPageState();
}

class _MonthlyHolydayListPageState
    extends BaseState<MonthlyHolydayListPage> {
  LeavesList leaveList;
  List attendanceListItem = [];
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

    _getListItems();
    filters = new Map();
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
    attendanceListItem.clear();

    final Map<String, dynamic> data =
    await ApiService.getMonthlyAttendanceData(widget.id, filters);
    isPerformingRequest = false;
    List<dynamic> abc = data['attendances'];
    if (abc.isEmpty) {
      attendanceListItem.isEmpty;
    } else {
      setState(() {
        currentPage = data['current_page'];
        lastPage = data['last_page'];
        attendanceListItem.addAll(data['attendances'][0]['offdays']);
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
          title: Text('My holydays of this month'),
        ),
//      body: leaveListDataWidget(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: leaveListDataWidget(),
              )
//            leaveListDataWidget()
            ],
          ),
        ));
  }

  Widget leaveListDataWidget() {
    if (attendanceListItem.isNotEmpty)
      return LeaveItemListWidget(
        attendanceItems: attendanceListItem,
        scrollController: _scrollController,
        isPerformingRequest: isPerformingRequest,
      );
    else if (attendanceListItem.isEmpty) {
      return Container(
          padding: EdgeInsets.only(top:250.0),
          child:Center(
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
  final ScrollController scrollController;
  final bool isPerformingRequest;

  LeaveItemListWidget(
      {this.attendanceItems, this.scrollController, this.isPerformingRequest});



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 30.0),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: attendanceItems.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == attendanceItems.length) {
                    return _buildProgressIndicator();
                  } else {
                    return _makeListItemUI(index, context);
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
    return _listItemUI(
        attendanceData: attendanceItems.elementAt(index),
        context: context,
        index: index);
  }

  Widget _listItemUI(
      {Map<String, dynamic> attendanceData, BuildContext context, index}) {
    int dayCount = DateTime.parse(attendanceData['date']).day;
    int toDay = DateTime.parse(DateTime.now().toString()).day;
    return attendanceData['status'] != 'Pending'
        ? Card(
      color: (index % 2 == 0) ? Colors.white : Color(0xFFE7F2FB),

//      color: DateFormat.yMd().format(DateTime.parse(attendanceData['dates'])) == DateFormat.yMd().format(DateTime.now()) ? Colors.greenAccent:Colors.white,
//      elevation: 8.0,
      child: InkWell(
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
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text('Date :' +
                              DateFormat.yMMMEd().format(
                                  DateTime.parse(attendanceData['date']))),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15.0),
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                          decoration: ShapeDecoration(
                            shape: AppTheme.roundedBorderDecoration(),
                            color: attendanceData['type'] == 'leave'
                                ? Color(0xFFE84033)
                                : attendanceData['type'] == 'weekend'
                                ? Color(0xFF48A64C)
                                : Color(0xFFF29000),
//                      color:Color(0xFF999999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                attendanceData['type'],
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
                  ],
                ),
//              title: Container(
//                padding: const EdgeInsets.only(bottom: 10.0),
//                margin: EdgeInsets.only(top: 5.0),
//                child: Text('Date : '+ attendanceData['dates']),
//              ),
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
                                  'From : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                child:  attendanceData['from'] != null
                                    && attendanceData['from'] != 'n/a'
                                    ? Text(
                                  attendanceData['from'],
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
                                  'To: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                child: attendanceData['to'] != null
                                    && attendanceData['to'] != 'n/a'
                                    ? Text(
//                                    convert12(attendanceData['out_time'])
                                  attendanceData['to'],
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
//                onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => AttendanceDetailPage(
//                            empId: attendanceData['employee'],
//                            date: attendanceData['dates'],
//                          )));
//                },
              ),
            ],
          )),
    )
        : SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }
}
