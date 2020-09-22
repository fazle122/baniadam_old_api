import 'package:flutter/material.dart';
import 'dart:async';
import '../data_provider/api_service.dart';
import 'package:baniadam/widgets/base_state.dart';



class AttendenceApprovalDialog extends StatefulWidget {
  final int id;
  final String type;
  final Map<String, dynamic> filters;
  AttendenceApprovalDialog({this.id,this.type,Key key,this.filters}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AttendenceApprovalDialogState();
  }
}

class _AttendenceApprovalDialogState extends BaseState<AttendenceApprovalDialog> {
  Map<String, dynamic> data;
  TextEditingController commetnController;
  int selectedDeclineValue;
  Map<int, dynamic> _declineReasons;
  String approvalType;
  String type;


  Map<String, dynamic> filters;
  String _pickedDuration = "today";
  String _pickedStatus = "pending";
  List newAttendenceList;
  bool isConfirmed = false;

  @override
  void initState() {
    filters = new Map();
    filters['duration'] = _pickedDuration;
    filters['status'] = _pickedStatus;
    newAttendenceList = [];
    approvalType = widget.type;
    type =approvalType == "APPROVED"? 'approve':'decline';
    _declineReasons = new Map();
    commetnController = TextEditingController();
    print(widget.id);
    data = Map();
    _getDeclineReasons();
    super.initState();
  }

  void _getDeclineReasons() async {
    data = await ApiService.getLOVDeclineReasons();
    debugPrint(data['attributes'].toString());
    if (data != null) {
      setState(() {
        for (int i = 0; i < data['attributes'].length; i++) {
          _declineReasons[data['attributes'][i]['id']] =
          data['attributes'][i]['value'];
        }
      });
    }
  }

  Future<List> _attendanceApproval(int id,String status,String note,String declinedReason) async {
    final String loginResponse = await ApiService.attendanceApproval(id,status,note,declinedReason);

    if (loginResponse != null) {
//      setState(() {
//        isConfirmed = false;
//      });
      final Map<String, dynamic> attendenceData =
      await ApiService.getAttendanceList(widget.filters);
      if (attendenceData != null) {
        setState(() {
          newAttendenceList.addAll(attendenceData['data']);
        });
      }
    }
    return newAttendenceList;
  }

  List<DropdownMenuItem> _menuItems(Map<dynamic, dynamic> items){
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((k,v){
      itemWidgets.add(DropdownMenuItem(
        value: k,
        child: Text(v.toString()),
      ));
    });
    return itemWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(5.0),
        title: Center(child: Text('Confirmation Required',style: TextStyle(fontSize: 20.0),)),
        content:
        SingleChildScrollView(
          child:isConfirmed ? Container(height: 200.0,child: Center(child:CircularProgressIndicator(),)): Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              Text('Are you sure, you want to $type this request?'),
              SizedBox(height: 10.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  approvalType == 'DECLINED' ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Reason: '),
                      DropdownButton(
                        hint: Text('Please choose a reason'),
                        // Not necessary for Option 1
                        value: selectedDeclineValue,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDeclineValue = newValue;
                            print('selected declined reason : '+ selectedDeclineValue.toString());
                          });
                        },
                        items: _menuItems(_declineReasons),
                      ),
                    ],
                  ):SizedBox(width: 0.0,height: 0.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Comment: '),
                      Container(
                        width: 160.0,
                        child: TextFormField(
                            controller: commetnController,
                            decoration: InputDecoration(
                              hintText: 'Write a comment',
                              contentPadding:
                              EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: 100.0,
                          height: 30.0,
                          color: Colors.white,
                          child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: 100.0,
                          height: 30.0,
                          color: Theme.of(context).buttonColor,
                          child: Center(
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        onTap: () async{
                          setState(() {
                            isConfirmed = true;
                          });

                          print(commetnController.text);
                          print(widget.id.toString());
                          List list;
                          if(selectedDeclineValue == null){
                            list = await _attendanceApproval(widget.id,approvalType,commetnController.text.trim(),"");
                          }else
                          {
                            list = await _attendanceApproval(widget.id,approvalType,commetnController.text.trim(),selectedDeclineValue.toString());
                          }

                          Navigator.of(context).pop(list);

                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      // _filterOptions(context),
    );
  }
}