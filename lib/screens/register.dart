import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/screens/logIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/AuthHelper.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:random_string/random_string.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';




class RegisterPage extends StatefulWidget {
  RegisterPage({
    Key key,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage> {
  TextEditingController nameController;
  TextEditingController idController;
  bool showPass = false;
  Map<String, dynamic> personalDetail;
  int userType = 0;
  Color buttonColor;
  String myInstanceId;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String _deviceId;



  @override
  void initState() {
    super.initState();
    buttonColor = Colors.grey;
    initPlatformState();
    nameController = TextEditingController();
    idController = TextEditingController();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;
    try {
      if (Platform.isAndroid) {
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    setState(() {
      _deviceId = build.androidId;
    });
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    setState(() {
      _deviceId = data.model;
    });

  }



  generateInstanceId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myInstanceId = prefs.getString('myInstanceId');
    if(myInstanceId == null){
      String random = randomAlpha(10);
      setState(() {
//        myInstanceId = random.toString()+ DateTime.now().toString();
        myInstanceId = _deviceId+ DateTime.now().toString();
        prefs.setString('myInstanceId', myInstanceId);
        print('instance Id:' + myInstanceId);
      });
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.all(25.0),
              title: Center(child: Text('Exit app confirmation')),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('You are sure, you want to exit the application?'),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 100.0,
                                height: 35.0,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                        color: Colors.grey.shade500),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          color:
                                          Theme.of(context).primaryColorDark),
                                    )),
                              ),
                              onTap: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            InkWell(
                              child: Container(
                                width: 100.0,
                                height: 35.0,
                                decoration: ShapeDecoration(
                                  color: Theme.of(context).buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              onTap: () async {
                                await SystemChannels.platform
                                    .invokeMethod<void>('SystemNavigator.pop');
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
        });
  }

  Widget nameField() {
    return TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: 'Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//            border:
//                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ));
  }

  Widget idField() {
    return TextFormField(
        onChanged: (_) {
          setState(() {
            buttonColor = Theme.of(context).buttonColor;
          });
        },
        textAlign: TextAlign.center,
        controller: idController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 30.0, 15.0),
          hintText:'Portal name',
//          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),));
  }

  Widget idField1() {
    return TextFormField(
        onChanged: (_) {
          setState(() {
            buttonColor = Theme.of(context).buttonColor;
          });
        },
        textAlign: TextAlign.center,
        controller: idController,
        decoration: InputDecoration(
          hintText: 'Portal name',
//          labelText: 'Company ID',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//            border:
//                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ));
  }

  Widget _registerButon(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(12),
        height: 50.0,
        width: 100.0,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(3, 3))
        ],
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Material(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: idController.text.length <= 0
                ? Theme.of(context).disabledColor
                : Theme.of(context).buttonColor,
            child: InkWell(
                onTap: () {
                  setState(() {
                    _registerUser();
                    generateInstanceId();
                  });
                },
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: idController.text.length <= 0
                            ? Colors.black
                            : Colors.white),
                  ),
                ))));
  }

  void _registerUser() async {
    if (idController.text.length <= 0) {
      Toast.show(' Please provide portal Id', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      AuthHelper.setCompanyId(idController.text);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LogInPage(
                companyId: idController.text,
              )));
    }
  }

  void handleRadioValue(int value) {
    setState(() {
      userType = value;
    });
  }

  Widget _sizedContainer(Widget child) {
    return new SizedBox(
      width: 100.0,
      height: 50.0,
      child: new Center(
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
              title: Text('BaniAdam HR - register'),
              automaticallyImplyLeading: false),
          body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  _sizedContainer(
                      Image.asset('assets/icons/BaniAdam-Logo_Final.png')),
                  SizedBox(height: 30.0),
                  Center(
                      child: Text('Register',
                          style: Theme.of(context).textTheme.title)),
                  SizedBox(height: 50.0),
                  Center(child: Text('Register with your portal name')),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(width: 250.0, child: idField()),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(width: 150.0, child: _registerButon(context)),
                ],
              )),
        ));
  }
}
