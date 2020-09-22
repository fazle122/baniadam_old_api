import 'package:baniadam/screens/dashboard.dart';
import 'package:baniadam/widgets/leave_application_dialog.dart';
import 'package:baniadam/widgets/leave_cancellation_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/widgets/leave_filter_dialog.dart';
import '../../style/app_theme.dart';
import '../../data_provider/api_service.dart';
import '../../models/leaveList.dart';
import 'package:intl/intl.dart';
import 'package:baniadam/widgets/base_state.dart';

class PersonalLeaveRequestListPage extends StatefulWidget {
  PersonalLeaveRequestListPage({
    Key key,
  }) : super(key: key);

  @override
  _PersonalLeaveRequestListPageState createState() =>
      _PersonalLeaveRequestListPageState();
}

class _PersonalLeaveRequestListPageState
    extends BaseState<PersonalLeaveRequestListPage> {
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

  Map<String, dynamic> filters;

  @override
  void initState() {
    super.initState();
    newLeaveListItem = [];
    _getListItems();
    filters = new Map();
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _getNewListItems();
//      }
//    });
  }

  void _getListItems() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
    }
    leaveListItem.clear();

    final List<dynamic> data = await ApiService.getPersonalLeavesList();
//    LeavesList newLeaveList = await ApiService.getLeaves();
//    debugPrint(data['total'].toString());
//    debugPrint(data['data'].toString());
    isPerformingRequest = false;
    if (data == null) {
    } else {
      print(data);
      setState(() {
        leaveListItem.addAll(data);
        print("leave list count - " + data.length.toString());
//        lastItemId = newLeaveList.last.data.
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

  Future<Map<String, dynamic>> _leaveFlterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LeaveFilterDialog(),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  }

  @override
  Widget build(BuildContext context) {
//    return WillPopScope(
//        onWillPop: _onBackPressed,
//        child:
       return Scaffold(
            appBar: AppBar(
              title: Text('My leave requests'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _getListItems();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog<Map<String, dynamic>>(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          LeaveApplicationDialogPage(),
                    );
//                    _getListItems();
                  },
                )
              ],
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
            )

//      Column(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        mainAxisSize: MainAxisSize.max,
//        children: <Widget>[
//          Text('Leave List'),
//          leaveListDataWidget(),
//
//        ],
//      )
            );
//    );  //WillPopScope
  }

  Widget leaveListDataWidget() {
    if (leaveListItem.isNotEmpty) //has data & performing/not performing
      return LeaveItemListWidget(
        leaveItems: leaveListItem,
        scrollController: _scrollController,
        isPerformingRequest: isPerformingRequest,
      );
    if (isPerformingRequest)
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

    return Container(
//        padding: EdgeInsets.only(top: 250.0),
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text('no list item'),
        ));
  }
}

class LeaveItemListWidget extends StatefulWidget {
  List leaveItems;
  ScrollController scrollController;
  bool isPerformingRequest;

  LeaveItemListWidget(
      {this.leaveItems, this.scrollController, this.isPerformingRequest});

  @override
  _LeaveItemLIstWidgetState createState() => _LeaveItemLIstWidgetState();
}

class _LeaveItemLIstWidgetState extends State<LeaveItemListWidget> {
  List newLeaveItems;

  @override
  void initState() {
    newLeaveItems = widget.leaveItems;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 80.0),
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: newLeaveItems.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == newLeaveItems.length) {
                return _buildProgressIndicator();
              } else {
                return _makeListItemUI(index, context);
              }
            },
            controller: widget.scrollController,
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
          opacity: widget.isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<List> _cancelLeave(BuildContext context, id) async {
    return await showDialog<List>(
      context: context,
      builder: (BuildContext context) => LeaveCancellationDialog(
        id: id,
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

  Widget _listItemUI(
      {Map<String, dynamic> leaves, BuildContext context, index}) {
    return Card(
//      elevation: 8.0,
      color: (index % 2 == 0) ? Colors.white : Color(0xFFE7F2FB),

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
//                        margin: EdgeInsets.only(top: 5.0),
                      child: Text(
                        leaves['leave_type']['value'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
//                        height: 30.0,
                      width: 140.0,
                      margin: EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      decoration: ShapeDecoration(
                          shape: AppTheme.roundedBorderDecoration(),
                          color: leaves['status'] == "Pending"
                              ? Color(0xFF5BC0DE)
                              : leaves['status'] == "Approved"
                                  ? Color(0xFF5CB85C)
                                  : Color(0xFFD9534F)
//                      color:Color(0xFF999999),
                          ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Flexible(
                              child: Center(
                            child: Text(
                              leaves['status'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                        ],
                      ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
//                          margin: EdgeInsets.only(top: 15.0),
                            child: Text(
                          'From: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Container(
//                          margin: EdgeInsets.only(top: 5.0),
                            child: leaves['from'] != null
                                ? Text(DateFormat.yMMMd()
                                    .format(DateTime.parse(leaves['from'])))
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
                            child: leaves['to'] != null
                                ? Text(DateFormat.yMMMd()
                                    .format(DateTime.parse(leaves['to'])))
                                : Text('No data')),
                      ],
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
//                          margin: EdgeInsets.only(top: 5.0),
                            child: Text(
                          'Reason: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Container(
                          width: MediaQuery.of(context).size.width * 3.5/5,
//                          margin: EdgeInsets.only(top: 5.0),
                            child: leaves['reason'] != null
                                ? Text(leaves['reason'])
                                : Text('No data')),
                      ],
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
//                          margin: EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Applied on : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 3/5,
//                          margin: EdgeInsets.only(top: 5.0),
                            child: leaves['created_at'] != null
                                ? Text(DateFormat.yMMMd()
                                .format(DateTime.parse(leaves['created_at'])))
                                : Text('No data')),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                leaves['status'] == "Pending" || leaves['status'] == "Approved"
                    ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 100.0,
                                height: 35.0,
                                decoration: ShapeDecoration(
                                  color: Theme.of(context).buttonColor,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  'Cancel leave',
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                              onTap: () async {
                                print(leaves['id'].toString());
                                List data =
                                    await _cancelLeave(context, leaves['id']);
                                if (data != null) {
                                  newLeaveItems = [];
                                  setState(() {
                                    newLeaveItems.addAll(data);
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 10.0),
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
