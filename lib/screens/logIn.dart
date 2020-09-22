import 'package:flutter/material.dart';
import 'package:baniadam/widgets/unRegister_confirmation_dialog.dart';
import 'package:intl/intl.dart';
import '../data_provider/api_service.dart';
import '../screens/dashboard.dart';
import '../helper/AuthHelper.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:location/location.dart';
import 'package:date_format/date_format.dart';


class LogInPage extends StatefulWidget {
  String companyId;

  LogInPage({
    this.companyId,
    Key key,
  }) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends BaseState<LogInPage> {
  TextEditingController nameController;
  TextEditingController passwordController;
  bool showPass = false;
  Map<String, dynamic> personalDetail;
//  int userType = 0;
  String companyLogo;
  String cacheCompanyLogo;
  String baseCdnUrl;
  String userType;
  String currentUserRole;
  List userRoles;
  String instanceIdFromPrefs;
  String myInstanceId;


  @override
  void initState() {
    userRoles = [];
    initPlatformState();
    getCDN();
    _getLogo();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    getInstanceId();
    super.initState();

  }

  getInstanceId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instanceIdFromPrefs = prefs.getString('myInstanceId');
    if(instanceIdFromPrefs != null){
      setState(() {
        myInstanceId = instanceIdFromPrefs;
      });
    }
  }

  getCDN()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var portalID = prefs.getString('curr-cid');
    if(portalID != null){
      setState(() {
//        baseCdnUrl = "https://cdn.baniadam.app/$portalID/";
        baseCdnUrl = ApiService.CDN_URl+"$portalID/";
      });

    }
  }

  void _getLogo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cid = prefs.getString('curr-cid');
    var cacheLogo = prefs.getString('logo-url');
    setState(() {
      cacheCompanyLogo = cacheLogo;
    });

    final Map<String, dynamic> data = await ApiService.getLogo(cid);
    if (data != null) {
      setState(() {
        companyLogo = baseCdnUrl + data['value'];
//        companyLogo = 'http://testcdn.ideaxen.net/test/' + data['value'];
      });
    }
  }


  Widget nameField() {
    return TextFormField(

        controller: nameController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 30.0, 15.0),
          hintText:'Username',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),));
  }

  Widget passField() {
    return TextFormField(
        obscureText: !showPass,
        controller: passwordController,
        decoration: InputDecoration(
            focusColor: Theme.of(context).primaryColorDark,
            labelStyle: TextStyle(color:Theme.of(context).primaryColorDark),
            hintText: 'Password',
            prefixIcon: Icon(Icons.confirmation_number),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))
        ));
  }

  Widget nameField1() {
    return TextFormField(
        controller: nameController,
        inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
//        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelStyle: TextStyle(color:Theme.of(context).primaryColorDark),
          labelText: 'Username',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//            border:
//                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ));
  }

  Widget passField1() {
    return TextFormField(
        obscureText: !showPass,
        controller: passwordController,
        decoration: InputDecoration(
          labelStyle: TextStyle(color:Theme.of(context).primaryColorDark),
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//            border:
//                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ));
  }

  Widget _loginButon(BuildContext context) {
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
            color:Theme.of(context).buttonColor,
            child: InkWell(
                onTap: () {
                  _loginUser();
                },
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color:Colors.white),
                  ),
                ))));

  }

  void _loginUser() async {
    int trackable;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cid = prefs.getString('curr-cid');
    final Map<String, dynamic> loginResponse = await ApiService.login(
        nameController.text, passwordController.text, cid,myInstanceId);

    if(loginResponse == null){
      Toast.show(' Invalid company  Id  !!!  \n Please unregister and try again with proper Id', context,
          duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
    }

    if (loginResponse.containsKey('access_token') &&
        loginResponse['access_token'] != null) {
      userRoles.addAll(loginResponse['user_roles']);

      setState(() {
        userType = loginResponse['user_type'];
        if(userRoles.contains('Admin') || userRoles.contains('Approver')){
          currentUserRole = 'Admin';
        }else{
          currentUserRole= '';
        }
      });

      AuthHelper.setLoginUser(loginResponse['access_token'], userType,currentUserRole);
      //      createActivityLog(loginResponse['access_token']);

      final Map<String, dynamic> detailData =
      await ApiService.getEmployeeDetail();
      if (detailData != null) {
        setState(() {
          id = detailData['id'];
        });
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardPage(token:loginResponse['access_token'],userType: userType,)));
    } else {
      Toast.show(loginResponse['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }

  }

//  void handleRadioValue(int value) {
//    setState(() {
//      userType = value;
//    });
//  }

  Widget _sizedContainer(Widget child) {
    return new SizedBox(
      width: 100.0,
      height: 50.0,
      child: new Center(
        child: child,
      ),
    );
  }

  Future<Map<String, dynamic>> _unRegisterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => UnRegisterConfirmationDialog(),
    );
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
                                await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text('BaniAdam HR - login'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              PopupMenuButton<String>(
                  onSelected: (val) async {
                    switch (val) {
                      case 'UNREGISTER':
                        debugPrint('UNREGISTER');
                        _unRegisterDialog(context);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>  <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      value: 'UNREGISTER',
                      child: Text('Unregister'),
                    ),
                  ]
              ),
            ],
          ),

          body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  companyLogo != null
                      ? Container(
                      height: MediaQuery.of(context).size.height * .9 / 10,
                      width: MediaQuery.of(context).size.width * .8 / 5,
                      child:  _sizedContainer(
                        CachedNetworkImage(
                          imageUrl:companyLogo,
                          placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              _sizedContainer(
                                  Image.asset(
                                      'assets/icons/BaniAdam-Logo_Final.png')),
                          fadeOutDuration: new Duration(seconds: 1),
                          fadeInDuration: new Duration(seconds: 3),
                        ),
                      )

                  ): SizedBox(
//                  height: MediaQuery.of(context).size.height * .5 / 10,
                    child: CircularProgressIndicator(),),
//              companyLogo != null
//                  ? _sizedContainer(
//                      new CachedNetworkImage(
//                        imageUrl: cacheCompanyLogo == null
//                            ? companyLogo
//                            : cacheCompanyLogo,
////              imageUrl: cacheCompanyLogo,
//                        placeholder: (context, url) =>
//                            new CircularProgressIndicator(),
//                        errorWidget: (context, url, error) =>
//                            _sizedContainer(
//                                Image.asset('assets/icons/BaniAdam-Logo_Final.png')),
//                        fadeOutDuration: new Duration(seconds: 1),
//                        fadeInDuration: new Duration(seconds: 3),
//                      ),
//                    )
//                  : _sizedContainer(
//                  Image.asset('assets/icons/BaniAdam-Logo_Final.png')),
                  SizedBox(height: 10.0),
                  Center(
                      child:
                      Text('Login', style:  Theme.of(context).textTheme.title)),
                  SizedBox(height: 100.0),
                  Container(
                    width: 250.0,
                    child: nameField(),
                  ),

                  SizedBox(
                    height: 20.0,
                  ),
                  Container(width: 250.0, child: passField()),
//          SizedBox(height: 10.0,),
                  Container(
                    width: 240.0,
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: Theme.of(context).primaryColorDark,
                          value: showPass,
                          onChanged: (bool value) {
                            setState(() {
                              showPass = value;
                            });
                          },
                        ),
                        Text("Show Password"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

//              Container(
//                width: 240.0,
//                child: Row(
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Radio<int>(
//                          activeColor: Theme.of(context).primaryColorDark,
//                          value: 0,
//                          groupValue: userType,
//                          onChanged: handleRadioValue,
//                        ),
//                        Text('Employee'),
//                      ],
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Row(
//                      children: <Widget>[
//                        Radio<int>(
//                          activeColor: Theme.of(context).primaryColorDark,
//                          value: 1,
//                          groupValue: userType,
//                          onChanged: handleRadioValue,
//                        ),
//                        Text('Approver'),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//
//              SizedBox(
//                height: 20.0,
//              ),

                  Container(width: 150.0, child: _loginButon(context)),
                ],
              )),
//      ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }


  Location _locationService = new Location();
  LocationData _currentLocation;
  String error;
  int id;

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 100);

    var location = new Location();
    try {
      setState(() async{
        _currentLocation = await location.getLocation();

      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      _currentLocation = null;
    }
  }


  void createActivityLog(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cid = prefs.getString('curr-cid');
    final Map<String, dynamic> detailData =
    await ApiService.getEmployeeDetail();
    if (detailData != null) {
      setState(() {
        id = detailData['data']['id'];
      });
    }

    final Map<String, dynamic> createLog =
    await ApiService.createActivityLog(
      cid,token,'app',myInstanceId,id.toString(),'logIn',
      _currentLocation.latitude.toString(),_currentLocation.longitude.toString(),DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),'',
    );

  }



}
