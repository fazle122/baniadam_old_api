

import 'package:flutter/material.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:baniadam/widgets/base_state.dart';

class EmployeeAttendenceItemListWidget extends StatefulWidget {
  final List attendanceItems;
  final bool isPerformingRequest;

  EmployeeAttendenceItemListWidget(
      {this.attendanceItems, this.isPerformingRequest});

  @override
  _EmployeeAttendenceItemListWidgetState createState() =>
      _EmployeeAttendenceItemListWidgetState();
}

class _EmployeeAttendenceItemListWidgetState
    extends BaseState<EmployeeAttendenceItemListWidget> {
  DateTime date;
  List newAttendanceList;
  bool refreshData = false;

  @override
  void initState() {
    newAttendanceList = widget.attendanceItems;
    super.initState();
  }

  String convert12(String str) {
    String finalTime;
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
      finalTime = '12' +str.substring(2);
    } else {
      finalTime = hh.toString() +str.substring(2);
    }
    finalTime = finalTime + Meridien;
//    print(finalTime);
    return finalTime;
  }

  Widget _listBody(BuildContext context) {
    if (widget.attendanceItems.isNotEmpty)
      return Container(
          child: !refreshData
              ? Container(
            width: MediaQuery.of(context).size.width * 4.5/5,
                  child: ListView.builder(
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
//      color: (index % 2 == 0) ? Colors.white : Color(0xFFE7F2FB),
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: <Widget>[
          ListTile(
//              title: Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Container(
//                        margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
//                        child: Text(
//                            DateFormat.yMMMEd()
//                                .format(DateTime.parse(listData['date'])),),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
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
                        Text('at ' + convert12(listData['time']),style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            child: Text(
                          'Reason: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Container(
                            child: listData['request_reason'] != null
                                ? Text(
                                    listData['request_reason']['value'],
                                  )
                                : Text('Not mentioned')),
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

  @override
  Widget build(BuildContext context) {
    return _listBody(context);
  }
}
