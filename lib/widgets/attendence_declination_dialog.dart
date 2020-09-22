import 'package:flutter/material.dart';
import '../data_provider/api_service.dart';
import 'package:baniadam/widgets/base_state.dart';


class AttendenceDeclinationDialog extends StatefulWidget {
  final int id;
  AttendenceDeclinationDialog({this.id,Key key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AttendenceDeclinationDialogState();
  }
}

class _AttendenceDeclinationDialogState extends BaseState<AttendenceDeclinationDialog> {
  Map<String, dynamic> data;
  int selectedValue;
  Map<int, dynamic> _declineReasons;
  TextEditingController commetnController;

  @override
  void initState() {
    _declineReasons = new Map();
    commetnController = TextEditingController();
//    print(widget.uId);
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

  void _attendanceApproval(int id,String status,String note, String reason) async {
    final Map<String, dynamic> loginResponse =
    await ApiService.attendanceRerjection(id,status,note,reason);

//    if (loginResponse != null) {
//      print(loginResponse['access_token']);
//      AuthHelper.setLoginUser(loginResponse['access_token'],radioValue);
//      Navigator.pushReplacement(context,
//          MaterialPageRoute(builder: (context) => DashboardPage(userType: radioValue,)));
//    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(5.0),
        title: Center(child: Text('Confirmation Required!')),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('Are you sure, you want to perform this operation ?'),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Reason: '),
                      DropdownButton(
                        hint: Text('Please choose a reason'),
                        // Not necessary for Option 1
                        value: selectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue;
                            print('selected declined reason : '+selectedValue.toString());
                          });
                        },
                        items: _menuItems(_declineReasons),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Comment: '),
                      Container(
                        width: 200.0,
                        child: TextFormField(
                            controller: commetnController,
                            decoration: InputDecoration(
                              hintText: 'Write a comment',
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
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
                                'NO',
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
                                'YES',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        onTap: () {

                          _attendanceApproval(widget.id,"DECLINED",commetnController.text,selectedValue.toString());
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        )
      // _filterOptions(context),
    );
  }
}