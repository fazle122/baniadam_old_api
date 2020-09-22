import 'dart:async';
import 'dart:io';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/screens/approver/attendance_request_list_for_admin.dart';
import 'package:baniadam/screens/approver/leave_requests_list_for_admin.dart';
import 'package:baniadam/screens/logIn.dart';
import 'package:baniadam/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baniadam/screens/dashboard.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:access_settings_menu/access_settings_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:baniadam/config/env.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' show Random;


JsonEncoder encoder = new JsonEncoder.withIndent("     ");

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isOnline = true;
  var token;
  var cID;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final notifications = FlutterLocalNotificationsPlugin();

  String notificationForSpecificUser;
  String notificationForAll = "ideaxen_all";
  String currentUserId = '34';
  String payloadData;
  Map<String, dynamic> notificationData;
  final List<Message> messages = [];

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  var randomizer = new Random();
  String notificationTitle;

  String title = "Title";
  String helper = "helper";

  @override
  void initState() {
    super.initState();

    initConnectivity();
//    _getUserInfo();
//    getPushNotification();
//    getMessage();
//    getPushNotification1();

//
//    notificationData = Map();
//    final settingsAndroid = AndroidInitializationSettings('app_icon');
//    final settingsIOS = IOSInitializationSettings(
//        onDidReceiveLocalNotification: (id, title, body, payload) =>
//            onSelectNotification(payload));
//
//    notifications.initialize(
//        InitializationSettings(settingsAndroid, settingsIOS),
//        onSelectNotification: onSelectNotification);
//
//    var android = new AndroidInitializationSettings('app_icon');
//    var ios = new IOSInitializationSettings();
//    var platform = new InitializationSettings(android, ios);
//    flutterLocalNotificationsPlugin.initialize(platform);


    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await updateConnectionStatus().then((bool isConnected) => setState(() {
        isOnline = isConnected;
        print('Connected: ' + isOnline.toString());
        if (!isOnline) {
          showDialog(
            context: context,
            builder: (BuildContext context) => _connectionDialog(context),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => cID != null
                  ? token != null ? DashboardPage() : LogInPage()
                  : RegisterPage(),
            ),
          );
        }
      }));
    });
  }

  Future<void> initConnectivity() async {
    try {
      await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    /// If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    await updateConnectionStatus().then((bool isConnected) => setState(() {
      isOnline = isConnected;
    }));
  }



  _connectionDialog(context) {
    return AlertDialog(
      title: Center(
        child: Text('Internet interruption'),
      ),
      content: Text('No internet. Please check your internet connection.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Network setting'),
          onPressed: () {
            openSettingsMenu('ACTION_WIFI_SETTINGS');
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }

  openSettingsMenu(settingsName) async {
    var resultSettingsOpening = false;

    try {
      resultSettingsOpening =
      await AccessSettingsMenu.openSettings(settingsType: settingsName);
    } catch (e) {
      resultSettingsOpening = false;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _connectivitySubscription.pause();
    super.deactivate();
  }

  Future<bool> updateConnectionStatus() async {
    bool isConnected;
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }


//  _getUserInfo() async {
//    Map<String, dynamic> personalDetail;
//    var empId;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    token = prefs.getString('curr-user');
//    cID = prefs.getString('curr-cid');
//
//    final Map<String, dynamic> detailData =
//    await ApiService.getEmployeeDetail();
//    if (detailData != null) {
//      setState(() {
//        personalDetail = detailData;
//        empId = personalDetail['data']['id'];
//      });
//    }
//    if(cID != null  && empId != null){
//      setState(() {
//        notificationForSpecificUser = cID + '_'+ empId.toString();
//      });
//    }
//  }
//
//  Future onSelectNotification(String payload) async {
//    await notifications.cancel(0);
//
////    await Navigator.push(
////        context,
////        MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
////    );
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
//  getPushNotification1(){
//    _firebaseMessaging.subscribeToTopic(notificationForAll);
//    _firebaseMessaging.subscribeToTopic(notificationForSpecificUser);
//    if(notificationForSpecificUser != null)
//      print('notificationForSpecificUser :' + notificationForSpecificUser);
//
//    _firebaseMessaging.configure(
//      onMessage: (message) async{
//        setState(() {
//          title = message["notification"]["title"];
//          helper = "You have recieved a new notification";
//        });
//
//      },
//      onResume: (message) async{
//        setState(() {
//          title = message["data"]["title"];
//          helper = "You have open the application from notification";
//        });
//
//      },
//
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
}

