//import 'dart:async';
//import 'dart:io';
//import 'package:baniadam/screens/approver/attendance_request_list_for_admin.dart';
//import 'package:baniadam/screens/approver/leave_requests_list_for_admin.dart';
//import 'package:baniadam/screens/logIn.dart';
//import 'package:baniadam/screens/register.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:baniadam/screens/dashboard.dart';
//import 'package:connectivity/connectivity.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';
//import 'package:access_settings_menu/access_settings_menu.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//as bg;
//import 'package:baniadam/config/env.dart';
//import 'dart:convert';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:math' show Random;
//
///// a base class for any statful widget for checking internet connectivity
//
//JsonEncoder encoder = new JsonEncoder.withIndent("     ");
//
//abstract class BaseState<T extends StatefulWidget> extends State<T> {
//  final Connectivity _connectivity = Connectivity();
//
//  StreamSubscription<ConnectivityResult> _connectivitySubscription;
//
//  /// the internet connectivity status
//  bool isOnline = true;
//  var token;
//  var cID;
//
//  /// initialize connectivity checking
//  /// Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initConnectivity() async {
//    try {
//      await _connectivity.checkConnectivity();
//    } on PlatformException catch (e) {
//      print(e.toString());
//    }
//
//    /// If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) {
//      return;
//    }
//
//    await updateConnectionStatus().then((bool isConnected) => setState(() {
//      isOnline = isConnected;
//    }));
//  }
//
//  _getUserInfo() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    token = prefs.getString('curr-user');
//    cID = prefs.getString('curr-cid');
//  }
//
//  bool _isMoving;
//  bool _enabled;
//  String _motionActivity;
//  String _odometer;
//  String _content;
//  Map<String, dynamic> coordinates;
//  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//  final notifications = FlutterLocalNotificationsPlugin();
//
//  String notificationForSpecificUser = "ideaxen_34";
//  String notificationForAll = "ideaxen_all";
//  String currentUserId = '34';
//  String payloadData;
//  Map<String, dynamic> notificationData;
//  final List<Message> messages = [];
//
//  final Firestore _db = Firestore.instance;
//  final FirebaseMessaging _fcm = FirebaseMessaging();
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//  new FlutterLocalNotificationsPlugin();
//  var randomizer = new Random();
//  String notificationTitle;
//
//  @override
//  void initState() {
//    super.initState();
//    notificationData = Map();
//
//    final settingsAndroid = AndroidInitializationSettings('app_icon');
//    final settingsIOS = IOSInitializationSettings(
//        onDidReceiveLocalNotification: (id, title, body, payload) =>
//            onSelectNotification(payload));
//
//    notifications.initialize(
//        InitializationSettings(settingsAndroid, settingsIOS),
//        onSelectNotification: onSelectNotification);
//
////    getMessage();
//
//    var android = new AndroidInitializationSettings('app_icon');
//    var ios = new IOSInitializationSettings();
//    var platform = new InitializationSettings(android, ios);
//    flutterLocalNotificationsPlugin.initialize(platform);
//    getPushNotification();
//
//
//
//
//    _getUserInfo();
//    initConnectivity();
//    _connectivitySubscription = Connectivity()
//        .onConnectivityChanged
//        .listen((ConnectivityResult result) async {
//      await updateConnectionStatus().then((bool isConnected) => setState(() {
//        isOnline = isConnected;
//        print('Connected: ' + isOnline.toString());
//        if (!isOnline) {
//          showDialog(
//            context: context,
//            builder: (BuildContext context) => _connectionDialog(context),
//          );
//        } else {
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => cID != null
//                  ? token != null ? DashboardPage() : LogInPage()
//                  : RegisterPage(),
//            ),
//          );
//        }
//      }));
//    });
//
//    ////
//    //coder for background geolocation
//    ////
//    coordinates = Map();
//    _isMoving = false;
//    _enabled = false;
//    _content = '';
//    _motionActivity = 'UNKNOWN';
//    _odometer = '0';
////    _initPlatformState();
//    ////
//    //coder for background geolocation
//    ////
//  }
//
////  Future onSelectNotification(String payload) async => await Navigator.push(
////    context,
////    MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
////  );
//
//  Future onSelectNotification(String payload) async {
//    await notifications.cancel(0);
//  }
//
//  getPushNotification(){
//    _fcm.subscribeToTopic(notificationForSpecificUser);
//    _fcm.subscribeToTopic(notificationForAll);
//    _fcm.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//
//        payloadData = message['data'];
//        notificationData = jsonDecode(payloadData);
//        setState(() {
//          notificationTitle = message['data']['title'];
//        });
//        showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['data']['title']),
//              subtitle: Text(message['data']['body']),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Ok'),
//                onPressed: () => Navigator.of(context).pop(),
//              ),
//            ],
//          ),
//        );
////        if(notificationData['data_payload']['showTo'] == "") {
////          print("onMessage: $notificationData['data_payload']");
////        }else{
////          showNotification(randomizer.nextInt(100),notificationData['data_payload']);
////        }
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//        payloadData = message['data']['notification'];
//        notificationData = jsonDecode(payloadData);
//        onResume(notificationData['data_payload']);
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//        payloadData = message['data']['notification'];
//        notificationData = jsonDecode(payloadData);
//        onResume(notificationData['data_payload']);
//      },
//    );
//  }
//
//  showNotification(int id,Map<String, dynamic> msg) async {
//    var android = new AndroidNotificationDetails(
//      'sdffds dsffds',
//      "CHANNLE NAME",
//      "channelDescription",
//    );
//    var iOS = new IOSNotificationDetails();
//    var platform = new NotificationDetails(android, iOS);
//    await flutterLocalNotificationsPlugin.show(
////        0, "This is title", "this is demo", platform);
//        0, msg['title'], msg['body'], platform);
//  }
//
//  onResume(Map<String, dynamic> msg) {
//    print(msg);
////    var data = Data(
////      clickAction: msg['click_action'],
////      sound: msg['sound'],
////      status: msg['status'],
////      screen: msg['screen'],
////      extradata: msg['extradata'],
////    );
//    String module = msg['module'];
//    switch (module) {
//      case "Leave":
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => LeaveRequestListPage()
//          ),
//        );
//        break;
//      case "Attendance":
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => AttendanceRequestListPageForAdmin()
//          ),
//        );
//        break;
//      default:
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => DashboardPage()
//          ),
//        );
//        break;
//    }
//  }
//
//
//
//
//  void getMessage() {
//    _firebaseMessaging.subscribeToTopic(notificationForSpecificUser);
//    _firebaseMessaging.subscribeToTopic(notificationForAll);
//    _firebaseMessaging.configure(
//        onMessage: (Map<String, dynamic> message) async {
//          print("onMessage:$message");
//          payloadData = message['data']['notification'];
//          notificationData = jsonDecode(payloadData);
//          String userIdFromServer =
//          notificationData['data_payload']['showTo'].toString();
//          if (userIdFromServer == currentUserId) {
//            showOngoingNotification1(notifications,
//                title: notificationData['data_payload']['title'],
//                body: notificationData['data_payload']['body']);
//          }
////          setState(() => _message = notificationData['data_payload']['title']);
//        }, onResume: (Map<String, dynamic> message) async {
//      print('on resume $message');
////      setState(() => _message = notificationData['data_payload']['title']);
//    }, onLaunch: (Map<String, dynamic> message) async {
//      print('on launch $message');
//      payloadData = message['data']['notification'];
//      notificationData = jsonDecode(payloadData);
////      setState(() => _message = notificationData['data_payload']['title']);
//    });
//  }
//
//  NotificationDetails get _ongoing {
//    final androidChannelSpecifics = AndroidNotificationDetails(
////    'your channel id',
////    'your channel name',
////    'your channel description',
//      'a', 'b', 'c',
//      importance: Importance.Max,
//      priority: Priority.High,
//      ongoing: true,
//      autoCancel: false,
//    );
//    final iOSChannelSpecifics = IOSNotificationDetails();
//    return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
//  }
//
//  Future showOngoingNotification1(
//      FlutterLocalNotificationsPlugin notifications, {
//        @required String title,
//        @required String body,
//        int id = 0,
//      }) =>
//      _showNotification1(notifications,
//          title: title, body: body, id: id, type: _ongoing);
//
//  Future _showNotification1(
//      FlutterLocalNotificationsPlugin notifications, {
//        @required String title,
//        @required String body,
//        @required NotificationDetails type,
//        int id = 0,
//      }) =>
//      notifications.show(id, title, body, type);
//
//  _connectionDialog(context) {
//    return AlertDialog(
//      title: Center(
//        child: Text('Internet interruption'),
//      ),
//      content: Text('No internet. Please check your internet connection.'),
//      actions: <Widget>[
//        FlatButton(
//          child: Text('Ok'),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//        FlatButton(
//          child: Text('Network setting'),
//          onPressed: () {
//            openSettingsMenu('ACTION_WIFI_SETTINGS');
//            Navigator.pop(context, true);
//          },
//        )
//      ],
//    );
//  }
//
//  openSettingsMenu(settingsName) async {
//    var resultSettingsOpening = false;
//
//    try {
//      resultSettingsOpening =
//      await AccessSettingsMenu.openSettings(settingsType: settingsName);
//    } catch (e) {
//      resultSettingsOpening = false;
//    }
//  }
//
//  @override
//  void dispose() {
//    _connectivitySubscription.cancel();
//    super.dispose();
//  }
//
//  @override
//  void deactivate() {
//    _connectivitySubscription.pause();
//    super.deactivate();
//  }
//
//  Future<bool> updateConnectionStatus() async {
//    bool isConnected;
//    try {
//      final List<InternetAddress> result =
//      await InternetAddress.lookup('google.com');
//      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//        isConnected = true;
//      }
//    } on SocketException catch (_) {
//      isConnected = false;
//      return false;
//    }
//    return isConnected;
//  }
//
//  ////
//  //coder for background geolocation
//  ////
//
////  Future<Null> _initPlatformState() async {
////    SharedPreferences prefs = await SharedPreferences.getInstance();
////    var currentUserToken = prefs.getString('curr-user');
////
////    // 1.  Listen to events (See docs for all 12 available events).
////    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
////    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
////    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
////    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
////    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
////    bg.BackgroundGeolocation.onHttp(_onHttp);
////    bg.BackgroundGeolocation.onAuthorization(_onAuthorization);
////
////    // 2.  Configure the plugin
////
////    bg.BackgroundGeolocation.ready(bg.Config(
////        reset: true,
////        debug: true,
////        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
////        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
////        distanceFilter: 10.0,
////        url:
////        "http://devapi.baniadam.info/ideaxen/api/in/v1/employees/employee/my/track/save",
////        authorization: bg.Authorization(
////          // <-- demo server authenticates with JWT
//////              strategy: bg.Authorization.STRATEGY_JWT,
////          accessToken:
////          "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjNiM2JiMDIyZTk3M2U4MTQwY2IxNGYxMjFmYzI5MTI3Nzg1NWVmYjkyMTE0NDM3NjU1NWUxM2RhNjMxMWI1MjM3MjI5Mzk4ZDMwYmMyYWU1In0.eyJhdWQiOiIzIiwianRpIjoiM2IzYmIwMjJlOTczZTgxNDBjYjE0ZjEyMWZjMjkxMjc3ODU1ZWZiOTIxMTQ0Mzc2NTU1ZTEzZGE2MzExYjUyMzcyMjkzOThkMzBiYzJhZTUiLCJpYXQiOjE1ODA4NzY4NzQsIm5iZiI6MTU4MDg3Njg3NCwiZXhwIjoxNjEyNDk5Mjc0LCJzdWIiOiIzMiIsInNjb3BlcyI6W119.OJse5Ce-_Zze8C5aIWLAJuCz7pBBj5gF0BdiK0kSxRP-YMUSEnnrE7tiNWQcaUq--Nqu_BUcFHAjQqLaUmoH7iQLdvRIUxTDB7XrZLI9WohdnjF8qxd5r7qihuT0UBhHpIhMzBzFPy42YC6d6rvCsXflPC5w_0C4y0iqvN7HyS7Z6Auo_7tdADRv4N1XgAp6B_dQ8a8NZW2h3ra1E-OFsqXh3wkz-XAPYP2nN_ttjJXGawUx5FxOtopT4Djcnp3dlC8eeHYrW2uYWKxMvgoNhNzgAGdKYsZbU-UxCln1CZZzjifmBI7gkUJ1n0qVYixBUsavpT3XrbOpde7htqmp9D1klIgN-nTowZ0k8FiR__1mD2MgaBsnWXeBuzuzT189JhBLYmvr9yS0oYW0e_F-hfwoP9eZtoYH5GMudFpdzu0jEqjOSjRTIiqHd3bI0Ei03CuOl1GbtZsHRHJKhbRrhvZoOhujuqEi2fv0vhe_y7PlCh2zo18lAmUUX-0tdcbtX2mhVBTmJOlvQ5K1LxUsMhqGWtB_piTQtzSaR5S5myiOr_-Y8LRHcDBmJ6nzyOIO0RK_A8q6xc5U7SRKLdDRge3pnz5fsT7ppnAMpl_5pTQ8C23B-FcdD9atx_g7anHHEgelTDA9ehJ7MT9Qp9E8RdXykTVfjG-TZRJ37kFbsmc",
//////          refreshToken: token.refreshToken,
//////          refreshUrl: "${ENV.TRACKER_HOST}/api/refresh_token",
//////          refreshPayload: {
//////            'refresh_token': '{refreshToken}'
//////          }
////        ),
////        encrypt: false,
////        stopOnTerminate: false,
////        startOnBoot: true,
////        enableHeadless: true))
////        .then((bg.State state) {
////      print("[ready] ${state.toMap()}");
////      setState(() {
////        _enabled = state.enabled;
////        _isMoving = state.isMoving;
////      });
////    }).catchError((error) {
////      print('[ready] ERROR: $error');
////    });
////
////    bg.BackgroundGeolocation.start().then((bg.State state) {
////      print('[start] success $state');
////      setState(() {
////        _enabled = state.enabled;
////        _isMoving = state.isMoving;
////      });
////    }).catchError((error) {
////      print('[start] ERROR: $error');
////    });
////  }
//
//  ////
//  // Event handlers
//  //
//
//  void _onLocation(bg.Location location) {
//    print('[location] - $location');
//
//    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
//
//    setState(() {
//      _content = encoder.convert(location.toMap());
//      coordinates['latitude'] = location.coords.latitude;
//      _odometer = odometerKM;
//    });
//    print('[Test] - $coordinates["coords"]["latitude"]');
//  }
//
//  void _onLocationError(bg.LocationError error) {
//    print('[location] ERROR - $error');
//  }
//
//  void _onMotionChange(bg.Location location) {
//    print('[motionchange] - $location');
//  }
//
//  void _onActivityChange(bg.ActivityChangeEvent event) {
//    print('[activitychange] - $event');
//    setState(() {
//      _motionActivity = event.activity;
//    });
//  }
//
//  void _onHttp(bg.HttpEvent event) async {
//    print('[${bg.Event.HTTP}] - $event');
//  }
//
//  void _onAuthorization(bg.AuthorizationEvent event) async {
//    print('[${bg.Event.AUTHORIZATION}] = $event');
//
//    bg.BackgroundGeolocation.setConfig(
//        bg.Config(url: ENV.TRACKER_HOST + '/api/locations'));
//  }
//
//  void _onProviderChange(bg.ProviderChangeEvent event) {
//    print('$event');
//
//    setState(() {
//      _content = encoder.convert(event.toMap());
//    });
//  }
//
//  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
//    print('$event');
//  }
//}
//
//@immutable
//class Message {
//  final String title;
//  final String body;
//
//  const Message({
//    @required this.title,
//    @required this.body,
//  });
//}
//
//class MessageBean {
//  MessageBean({this.itemId});
//  final String itemId;
//
//  StreamController<MessageBean> _controller =
//  StreamController<MessageBean>.broadcast();
//  Stream<MessageBean> get onChanged => _controller.stream;
//
//  String _status;
//  String get status => _status;
//  set status(String value) {
//    _status = value;
//    _controller.add(this);
//  }
//
//  static final Map<String, Route<void>> routes = <String, Route<void>>{};
//  Route<void> get route {
//    final String routeName = '/detail/$itemId';
//    return routes.putIfAbsent(
//      routeName,
//          () => MaterialPageRoute<void>(
//        settings: RouteSettings(name: routeName),
////            builder: (BuildContext context) => DetailPage(itemId),
//        builder: (BuildContext context) => DashboardPage(),
//      ),
//    );
//  }
//}
//
////import 'dart:async';
////import 'dart:io';
////import 'dart:math';
////import 'package:baniadam/screens/approver/leave_request_detail.dart';
////import 'package:baniadam/screens/logIn.dart';
////import 'package:baniadam/screens/register.dart';
////import 'package:shared_preferences/shared_preferences.dart';
////import 'package:baniadam/screens/dashboard.dart';
////import 'package:connectivity/connectivity.dart';
////import 'package:flutter/material.dart';
////import 'package:flutter/services.dart';
////import 'package:flutter/widgets.dart';
////import 'package:access_settings_menu/access_settings_menu.dart';
////import 'package:firebase_messaging/firebase_messaging.dart';
////import 'package:flutter_local_notifications/flutter_local_notifications.dart';
////import 'package:flutter/foundation.dart';
////import 'package:flutter/material.dart';
////import 'dart:async';
////import 'package:shared_preferences/shared_preferences.dart';
////import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
////    as bg;
////import 'package:baniadam/config/env.dart';
////import 'dart:convert';
////import '../data_provider/api_service.dart';
////
/////// a base class for any statful widget for checking internet connectivity
////
////JsonEncoder encoder = new JsonEncoder.withIndent("     ");
////
////abstract class BaseState<T extends StatefulWidget> extends State<T> {
////  final Connectivity _connectivity = Connectivity();
////
////  StreamSubscription<ConnectivityResult> _connectivitySubscription;
////
////  /// the internet connectivity status
////  bool isOnline = true;
////  var token;
////  var cID;
////
////  /// initialize connectivity checking
////  /// Platform messages are asynchronous, so we initialize in an async method.
////  Future<void> initConnectivity() async {
////    try {
////      await _connectivity.checkConnectivity();
////    } on PlatformException catch (e) {
////      print(e.toString());
////    }
////
////    /// If the widget was removed from the tree while the asynchronous platform
////    // message was in flight, we want to discard the reply rather than calling
////    // setState to update our non-existent appearance.
////    if (!mounted) {
////      return;
////    }
////
////    await updateConnectionStatus().then((bool isConnected) => setState(() {
////          isOnline = isConnected;
////        }));
////  }
////
////  _getUserInfo() async {
////    SharedPreferences prefs = await SharedPreferences.getInstance();
////    token = prefs.getString('curr-user');
////    cID = prefs.getString('curr-cid');
////  }
////
////  bool _isMoving;
////  bool _enabled;
////  String _motionActivity;
////  String _odometer;
////  String _content;
////  Map<String, dynamic> coordinates;
////  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
////  ApiService apiService;
////  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
////  final notifications = FlutterLocalNotificationsPlugin();
////
////  String appName;
////  String currentUserId;
////  String payloadData;
////  Map<String, dynamic> notificationData;
////  final List<Message> messages = [];
////  Map<String, dynamic> personalDetail;
////
////
////  @override
////  void initState() {
////    super.initState();
////    _getEmployeeDetail();
////    //// Notification start
////    notificationData = Map();
////    getNotification();
////
////    final settingsAndroid = AndroidInitializationSettings('app_icon',);
////    final settingsIOS = IOSInitializationSettings(
////        onDidReceiveLocalNotification: (id, title, body, payload) =>
////            onSelectNotification(payload));
////
////    notifications.initialize(
////        InitializationSettings(settingsAndroid, settingsIOS),
////        onSelectNotification: onSelectNotification);
////
////
////    //// Notification end
////
////    _getUserInfo();
////    initConnectivity();
////    _connectivitySubscription = Connectivity()
////        .onConnectivityChanged
////        .listen((ConnectivityResult result) async {
////      await updateConnectionStatus().then((bool isConnected) => setState(() {
////            isOnline = isConnected;
////            print('Connected: ' + isOnline.toString());
////            if (!isOnline) {
////              showDialog(
////                context: context,
////                builder: (BuildContext context) => _connectionDialog(context),
////              );
////            } else {
////              Navigator.pushReplacement(
////                context,
////                MaterialPageRoute(
////                  builder: (context) => cID != null
////                      ? token != null ? DashboardPage() : LogInPage()
////                      : RegisterPage(),
////                ),
////              );
////            }
////          }));
////    });
////
////    ////
////    //coder for background geolocation
////    ////
////    coordinates = Map();
////    _isMoving = false;
////    _enabled = false;
////    _content = '';
////    _motionActivity = 'UNKNOWN';
////    _odometer = '0';
//////    _initPlatformState();
////    ////
////    //code for background geolocation
////    ////
////  }
////
////
////  void _getEmployeeDetail() async {
////    final Map<String, dynamic> detailData =
////    await ApiService.getEmployeeDetail();
////    if (detailData != null) {
////      setState(() {
////        personalDetail = detailData;
////        currentUserId = personalDetail['id'].toString();
////      });
////    }
////    SharedPreferences prefs = await SharedPreferences.getInstance();
////    var portalID = prefs.getString('curr-cid');
////    if(portalID != null){
////      setState(() {
////        appName = portalID.toString()+ '_' + currentUserId.toString();
////      });
////    }
////  }
////
////  //// Notification Start
//////  void notificationReceived(Map<String, dynamic> notificationData){}
////
//////  void getNotification(BaseState baseStateChild){
////  void getNotification() {
////    _firebaseMessaging.subscribeToTopic(appName);
////    _firebaseMessaging.configure(
////        onMessage: (Map<String, dynamic> message) async {
////      print("onMessage:$message");
////      payloadData = message['data']['notification'];
////      setState(() {
////        notificationData = jsonDecode(payloadData);
////      });
////      String userIdFromServer = notificationData['data_payload']['showTo'];
//////          baseStateChild.notificationReceived(notificationData);
////      if (userIdFromServer == currentUserId) {
////        showOngoingNotification1(notifications,
////            title: notificationData['data_payload']['title'],
////            body: notificationData['data_payload']['body']);
////      }
////    }, onResume: (Map<String, dynamic> message) async {
////      print('on resume $message');
////    }, onLaunch: (Map<String, dynamic> message) async {
////      print('on launch $message');
////      payloadData = message['data']['notification'];
////      notificationData = jsonDecode(payloadData);
////    });
////  }
////
//////  Future onSelectNotification(String payload) async => await Navigator.push(
//////    context,
//////    MaterialPageRoute(builder: (context) => LeaveRequestDetailPage(payload: payload)),
//////  );
////
////  Future onSelectNotification(String payload) async{
////    await notifications.cancel(0);
////  }
////
////  Future<Map<String,dynamic>> onSelectNotification2(notificationDate) async {
////    if(notificationDate['data_payload']['module'] == 'Leave')
////    await Navigator.push(
////        context,
////        MaterialPageRoute(builder: (context) => LeaveRequestDetailPage(id: notificationDate['data_payload']['application_id'],)),
////      );
////  }
////
////  NotificationDetails get _ongoing {
////    final androidChannelSpecifics = AndroidNotificationDetails(
//////    'your channel id',
//////    'your channel name',
//////    'your channel description',
////      'a', 'b', 'c',
////      importance: Importance.Max,
////      priority: Priority.High,
////      ongoing: true,
////      autoCancel: true,
////    );
////    final iOSChannelSpecifics = IOSNotificationDetails();
////    return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
////  }
////
////  Future showOngoingNotification1(
////    FlutterLocalNotificationsPlugin notifications, {
////    @required String title,
////    @required String body,
////    int id = 0,
////  }) =>
////      _showNotification1(notifications,
////          title: title, body: body, id: id, type: _ongoing);
////
////  Future _showNotification1(
////    FlutterLocalNotificationsPlugin notifications, {
////    @required String title,
////    @required String body,
////    @required NotificationDetails type,
////    int id = 0,
////  }) =>
////      notifications.show(id, title, body, type);
////
////  //// Notification End
////
////  _connectionDialog(context) {
////    return AlertDialog(
////      title: Center(
////        child: Text('Internet interruption'),
////      ),
////      content: Text('No internet. Please check your internet connection.'),
////      actions: <Widget>[
////        FlatButton(
////          child: Text('Ok'),
////          onPressed: () {
////            Navigator.of(context).pop();
////          },
////        ),
////        FlatButton(
////          child: Text('Network setting'),
////          onPressed: () {
////            openSettingsMenu('ACTION_WIFI_SETTINGS');
////            Navigator.pop(context, true);
////          },
////        )
////      ],
////    );
////  }
////
////  openSettingsMenu(settingsName) async {
////    var resultSettingsOpening = false;
////
////    try {
////      resultSettingsOpening =
////          await AccessSettingsMenu.openSettings(settingsType: settingsName);
////    } catch (e) {
////      resultSettingsOpening = false;
////    }
////  }
////
////  @override
////  void dispose() {
////    _connectivitySubscription.cancel();
////    super.dispose();
////  }
////
////  @override
////  void deactivate() {
////    _connectivitySubscription.pause();
////    super.deactivate();
////  }
////
////  Future<bool> updateConnectionStatus() async {
////    bool isConnected;
////    try {
////      final List<InternetAddress> result =
////          await InternetAddress.lookup('google.com');
////      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
////        isConnected = true;
////      }
////    } on SocketException catch (_) {
////      isConnected = false;
////      return false;
////    }
////    return isConnected;
////  }
////
////  ////
////  //coder for background geolocation
////  ////
////
//////  Future<Null> _initPlatformState() async {
//////    SharedPreferences prefs = await SharedPreferences.getInstance();
//////    var currentUserToken = prefs.getString('curr-user');
//////
//////    // 1.  Listen to events (See docs for all 12 available events).
//////    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
//////    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
//////    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
//////    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
//////    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
//////    bg.BackgroundGeolocation.onHttp(_onHttp);
//////    bg.BackgroundGeolocation.onAuthorization(_onAuthorization);
//////
//////    // 2.  Configure the plugin
//////
//////    bg.BackgroundGeolocation.ready(bg.Config(
//////        reset: true,
//////        debug: true,
//////        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
//////        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//////        distanceFilter: 10.0,
//////        url:
//////        "http://devapi.baniadam.info/ideaxen/api/in/v1/employees/employee/my/track/save",
//////        authorization: bg.Authorization(
//////          // <-- demo server authenticates with JWT
////////              strategy: bg.Authorization.STRATEGY_JWT,
//////          accessToken:
//////          "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjNiM2JiMDIyZTk3M2U4MTQwY2IxNGYxMjFmYzI5MTI3Nzg1NWVmYjkyMTE0NDM3NjU1NWUxM2RhNjMxMWI1MjM3MjI5Mzk4ZDMwYmMyYWU1In0.eyJhdWQiOiIzIiwianRpIjoiM2IzYmIwMjJlOTczZTgxNDBjYjE0ZjEyMWZjMjkxMjc3ODU1ZWZiOTIxMTQ0Mzc2NTU1ZTEzZGE2MzExYjUyMzcyMjkzOThkMzBiYzJhZTUiLCJpYXQiOjE1ODA4NzY4NzQsIm5iZiI6MTU4MDg3Njg3NCwiZXhwIjoxNjEyNDk5Mjc0LCJzdWIiOiIzMiIsInNjb3BlcyI6W119.OJse5Ce-_Zze8C5aIWLAJuCz7pBBj5gF0BdiK0kSxRP-YMUSEnnrE7tiNWQcaUq--Nqu_BUcFHAjQqLaUmoH7iQLdvRIUxTDB7XrZLI9WohdnjF8qxd5r7qihuT0UBhHpIhMzBzFPy42YC6d6rvCsXflPC5w_0C4y0iqvN7HyS7Z6Auo_7tdADRv4N1XgAp6B_dQ8a8NZW2h3ra1E-OFsqXh3wkz-XAPYP2nN_ttjJXGawUx5FxOtopT4Djcnp3dlC8eeHYrW2uYWKxMvgoNhNzgAGdKYsZbU-UxCln1CZZzjifmBI7gkUJ1n0qVYixBUsavpT3XrbOpde7htqmp9D1klIgN-nTowZ0k8FiR__1mD2MgaBsnWXeBuzuzT189JhBLYmvr9yS0oYW0e_F-hfwoP9eZtoYH5GMudFpdzu0jEqjOSjRTIiqHd3bI0Ei03CuOl1GbtZsHRHJKhbRrhvZoOhujuqEi2fv0vhe_y7PlCh2zo18lAmUUX-0tdcbtX2mhVBTmJOlvQ5K1LxUsMhqGWtB_piTQtzSaR5S5myiOr_-Y8LRHcDBmJ6nzyOIO0RK_A8q6xc5U7SRKLdDRge3pnz5fsT7ppnAMpl_5pTQ8C23B-FcdD9atx_g7anHHEgelTDA9ehJ7MT9Qp9E8RdXykTVfjG-TZRJ37kFbsmc",
////////          refreshToken: token.refreshToken,
////////          refreshUrl: "${ENV.TRACKER_HOST}/api/refresh_token",
////////          refreshPayload: {
////////            'refresh_token': '{refreshToken}'
////////          }
//////        ),
//////        encrypt: false,
//////        stopOnTerminate: false,
//////        startOnBoot: true,
//////        enableHeadless: true))
//////        .then((bg.State state) {
//////      print("[ready] ${state.toMap()}");
//////      setState(() {
//////        _enabled = state.enabled;
//////        _isMoving = state.isMoving;
//////      });
//////    }).catchError((error) {
//////      print('[ready] ERROR: $error');
//////    });
//////
//////    bg.BackgroundGeolocation.start().then((bg.State state) {
//////      print('[start] success $state');
//////      setState(() {
//////        _enabled = state.enabled;
//////        _isMoving = state.isMoving;
//////      });
//////    }).catchError((error) {
//////      print('[start] ERROR: $error');
//////    });
//////  }
////
////  ////
////  // Event handlers
////  //
////
////  void _onLocation(bg.Location location) {
////    print('[location] - $location');
////
////    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
////
////    setState(() {
////      _content = encoder.convert(location.toMap());
////      coordinates['latitude'] = location.coords.latitude;
////      _odometer = odometerKM;
////    });
////    print('[Test] - $coordinates["coords"]["latitude"]');
////  }
////
////  void _onLocationError(bg.LocationError error) {
////    print('[location] ERROR - $error');
////  }
////
////  void _onMotionChange(bg.Location location) {
////    print('[motionchange] - $location');
////  }
////
////  void _onActivityChange(bg.ActivityChangeEvent event) {
////    print('[activitychange] - $event');
////    setState(() {
////      _motionActivity = event.activity;
////    });
////  }
////
////  void _onHttp(bg.HttpEvent event) async {
////    print('[${bg.Event.HTTP}] - $event');
////  }
////
////  void _onAuthorization(bg.AuthorizationEvent event) async {
////    print('[${bg.Event.AUTHORIZATION}] = $event');
////
////    bg.BackgroundGeolocation.setConfig(
////        bg.Config(url: ENV.TRACKER_HOST + '/api/locations'));
////  }
////
////  void _onProviderChange(bg.ProviderChangeEvent event) {
////    print('$event');
////
////    setState(() {
////      _content = encoder.convert(event.toMap());
////    });
////  }
////
////  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
////    print('$event');
////  }
////}
////
////@immutable
////class Message {
////  final String title;
////  final String body;
////
////  const Message({
////    @required this.title,
////    @required this.body,
////  });
////}
