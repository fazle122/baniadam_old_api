import 'package:flutter/material.dart';
import 'package:baniadam/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baniadam/widgets/base_state.dart';




class UnRegisterConfirmationDialog extends StatefulWidget {
  final int id;
  final String type;
  final Map<String, dynamic> filters;
  UnRegisterConfirmationDialog({this.id,this.type,Key key,this.filters}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UnRegisterConfirmationDialogState();
  }
}

class _UnRegisterConfirmationDialogState extends BaseState<UnRegisterConfirmationDialog> {


  @override
  void initState() {
    super.initState();
  }


  void _unRegister() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('curr-user');
    prefs.remove('curr-cid');
    prefs.remove('user-type');
    prefs.remove('user-role');
    prefs.remove('logo-url');
//    prefs.remove('myInstanceId');

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        RegisterPage()), (Route<dynamic> route) => false);

//    Navigator.push(
//        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(25.0),
        title: Center(child: Text('Confirmation required')),
        content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Center(

                  child:Text('Are you sure, you want to cancel your registration ?')),
              SizedBox(height: 30.0,),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                        child:InkWell(
                          child: Container(
                            width: 100.0,
                            height: 35.0,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                            ),
                            child: Center(
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark),
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Material(
                        child: InkWell(
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
                                  'Yes',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          onTap: () async{
                            _unRegister();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),)
        )
      // _filterOptions(context),
    );
  }
}