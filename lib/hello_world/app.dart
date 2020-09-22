//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'dart:async';
//
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
//import '../config/ENV.dart';
//
//////
//// For pretty-printing locations as JSON
//// @see _onLocation
////
//import 'dart:convert';
//JsonEncoder encoder = new JsonEncoder.withIndent("     ");
//
//class HelloWorldApp extends StatelessWidget {
//  static const String NAME = 'hello_world';
//
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'BackgroundGeolocation Demo',
//      theme: Theme.of(context).copyWith(
//          accentColor: Colors.black,
//          bottomAppBarColor: Colors.amberAccent,
//          primaryTextTheme: Theme
//              .of(context)
//              .primaryTextTheme
//              .apply(
//            bodyColor: Colors.black,
//          )
//      ),
//      home: new HelloWorldPage(),
//    );
//  }
//}
//
//class HelloWorldPage extends StatefulWidget {
//  HelloWorldPage({Key key}) : super(key: key);
//
//  @override
//  _HelloWorldPageState createState() => new _HelloWorldPageState();
//}
//
//class _HelloWorldPageState extends State<HelloWorldPage> {
//  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//  bool _isMoving;
//  bool _enabled;
//  String _motionActivity;
//  String _odometer;
//  String _content;
//
//  @override
//  void initState() {
//    super.initState();
//    _content = "    Enable the switch to begin tracking.";
//    _isMoving = false;
//    _enabled = false;
//    _content = '';
//    _motionActivity = 'UNKNOWN';
//    _odometer = '0';
//    _initPlatformState();
//  }
//
//  Future<Null> _initPlatformState() async {
//
//    // 1.  Listen to events (See docs for all 12 available events).
//    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
//    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
//    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
//    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
//    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
//    bg.BackgroundGeolocation.onHttp(_onHttp);
//    bg.BackgroundGeolocation.onAuthorization(_onAuthorization);
//
//    // 2.  Configure the plugin
//
//    // // With auth
//
//    bg.BackgroundGeolocation.ready(bg.Config(
//        reset: true,
//        debug: true,
//        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
//        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//        distanceFilter: 10.0,
//        url:
//        "http://devapi.baniadam.info/ideaxen/api/in/v1/employees/employee/my/track/save",
//        authorization: bg.Authorization(
//          // <-- demo server authenticates with JWT
////              strategy: bg.Authorization.STRATEGY_JWT,
//          accessToken:
//          "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjNiM2JiMDIyZTk3M2U4MTQwY2IxNGYxMjFmYzI5MTI3Nzg1NWVmYjkyMTE0NDM3NjU1NWUxM2RhNjMxMWI1MjM3MjI5Mzk4ZDMwYmMyYWU1In0.eyJhdWQiOiIzIiwianRpIjoiM2IzYmIwMjJlOTczZTgxNDBjYjE0ZjEyMWZjMjkxMjc3ODU1ZWZiOTIxMTQ0Mzc2NTU1ZTEzZGE2MzExYjUyMzcyMjkzOThkMzBiYzJhZTUiLCJpYXQiOjE1ODA4NzY4NzQsIm5iZiI6MTU4MDg3Njg3NCwiZXhwIjoxNjEyNDk5Mjc0LCJzdWIiOiIzMiIsInNjb3BlcyI6W119.OJse5Ce-_Zze8C5aIWLAJuCz7pBBj5gF0BdiK0kSxRP-YMUSEnnrE7tiNWQcaUq--Nqu_BUcFHAjQqLaUmoH7iQLdvRIUxTDB7XrZLI9WohdnjF8qxd5r7qihuT0UBhHpIhMzBzFPy42YC6d6rvCsXflPC5w_0C4y0iqvN7HyS7Z6Auo_7tdADRv4N1XgAp6B_dQ8a8NZW2h3ra1E-OFsqXh3wkz-XAPYP2nN_ttjJXGawUx5FxOtopT4Djcnp3dlC8eeHYrW2uYWKxMvgoNhNzgAGdKYsZbU-UxCln1CZZzjifmBI7gkUJ1n0qVYixBUsavpT3XrbOpde7htqmp9D1klIgN-nTowZ0k8FiR__1mD2MgaBsnWXeBuzuzT189JhBLYmvr9yS0oYW0e_F-hfwoP9eZtoYH5GMudFpdzu0jEqjOSjRTIiqHd3bI0Ei03CuOl1GbtZsHRHJKhbRrhvZoOhujuqEi2fv0vhe_y7PlCh2zo18lAmUUX-0tdcbtX2mhVBTmJOlvQ5K1LxUsMhqGWtB_piTQtzSaR5S5myiOr_-Y8LRHcDBmJ6nzyOIO0RK_A8q6xc5U7SRKLdDRge3pnz5fsT7ppnAMpl_5pTQ8C23B-FcdD9atx_g7anHHEgelTDA9ehJ7MT9Qp9E8RdXykTVfjG-TZRJ37kFbsmc",
////          refreshToken: token.refreshToken,
////          refreshUrl: "${ENV.TRACKER_HOST}/api/refresh_token",
////          refreshPayload: {
////            'refresh_token': '{refreshToken}'
////          }
//        ),
//        encrypt: false,
//        stopOnTerminate: false,
//        startOnBoot: true,
//        enableHeadless: true))
//        .then((bg.State state) {
//      print("[ready] ${state.toMap()}");
//      setState(() {
//        _enabled = state.enabled;
//        _isMoving = state.isMoving;
//      });
//    }).catchError((error) {
//      print('[ready] ERROR: $error');
//    });
//
////    bg.BackgroundGeolocation.ready(bg.Config(
////        url: "http://devapi.baniadam.info/ideaxen/api/in/v1/employees/employee/my/track/save",
//////        url: "devapi.baniadam.info/ideaxen/api/filetest",
////        reset: true,
////        debug: true,
////        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
////        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
////        distanceFilter: 10.0,
////        autoSync: true,
////        autoSyncThreshold: 5,
////        batchSync: true,
////        maxBatchSize: 50,
////        authorization: bg.Authorization(  // <-- demo server authenticates with JWT
////          strategy: bg.Authorization.STRATEGY_JWT,
////          accessToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjNiM2JiMDIyZTk3M2U4MTQwY2IxNGYxMjFmYzI5MTI3Nzg1NWVmYjkyMTE0NDM3NjU1NWUxM2RhNjMxMWI1MjM3MjI5Mzk4ZDMwYmMyYWU1In0.eyJhdWQiOiIzIiwianRpIjoiM2IzYmIwMjJlOTczZTgxNDBjYjE0ZjEyMWZjMjkxMjc3ODU1ZWZiOTIxMTQ0Mzc2NTU1ZTEzZGE2MzExYjUyMzcyMjkzOThkMzBiYzJhZTUiLCJpYXQiOjE1ODA4NzY4NzQsIm5iZiI6MTU4MDg3Njg3NCwiZXhwIjoxNjEyNDk5Mjc0LCJzdWIiOiIzMiIsInNjb3BlcyI6W119.OJse5Ce-_Zze8C5aIWLAJuCz7pBBj5gF0BdiK0kSxRP-YMUSEnnrE7tiNWQcaUq--Nqu_BUcFHAjQqLaUmoH7iQLdvRIUxTDB7XrZLI9WohdnjF8qxd5r7qihuT0UBhHpIhMzBzFPy42YC6d6rvCsXflPC5w_0C4y0iqvN7HyS7Z6Auo_7tdADRv4N1XgAp6B_dQ8a8NZW2h3ra1E-OFsqXh3wkz-XAPYP2nN_ttjJXGawUx5FxOtopT4Djcnp3dlC8eeHYrW2uYWKxMvgoNhNzgAGdKYsZbU-UxCln1CZZzjifmBI7gkUJ1n0qVYixBUsavpT3XrbOpde7htqmp9D1klIgN-nTowZ0k8FiR__1mD2MgaBsnWXeBuzuzT189JhBLYmvr9yS0oYW0e_F-hfwoP9eZtoYH5GMudFpdzu0jEqjOSjRTIiqHd3bI0Ei03CuOl1GbtZsHRHJKhbRrhvZoOhujuqEi2fv0vhe_y7PlCh2zo18lAmUUX-0tdcbtX2mhVBTmJOlvQ5K1LxUsMhqGWtB_piTQtzSaR5S5myiOr_-Y8LRHcDBmJ6nzyOIO0RK_A8q6xc5U7SRKLdDRge3pnz5fsT7ppnAMpl_5pTQ8C23B-FcdD9atx_g7anHHEgelTDA9ehJ7MT9Qp9E8RdXykTVfjG-TZRJ37kFbsmc",
//////          refreshToken: token.refreshToken,
//////          refreshUrl: "${ENV.TRACKER_HOST}/api/refresh_token",
//////          refreshPayload: {
//////            'refresh_token': '{refreshToken}'
//////          }
////        ),
////
//////        headers: {
////////          "Bearer Token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjNiM2JiMDIyZTk3M2U4MTQwY2IxNGYxMjFmYzI5MTI3Nzg1NWVmYjkyMTE0NDM3NjU1NWUxM2RhNjMxMWI1MjM3MjI5Mzk4ZDMwYmMyYWU1In0.eyJhdWQiOiIzIiwianRpIjoiM2IzYmIwMjJlOTczZTgxNDBjYjE0ZjEyMWZjMjkxMjc3ODU1ZWZiOTIxMTQ0Mzc2NTU1ZTEzZGE2MzExYjUyMzcyMjkzOThkMzBiYzJhZTUiLCJpYXQiOjE1ODA4NzY4NzQsIm5iZiI6MTU4MDg3Njg3NCwiZXhwIjoxNjEyNDk5Mjc0LCJzdWIiOiIzMiIsInNjb3BlcyI6W119.OJse5Ce-_Zze8C5aIWLAJuCz7pBBj5gF0BdiK0kSxRP-YMUSEnnrE7tiNWQcaUq--Nqu_BUcFHAjQqLaUmoH7iQLdvRIUxTDB7XrZLI9WohdnjF8qxd5r7qihuT0UBhHpIhMzBzFPy42YC6d6rvCsXflPC5w_0C4y0iqvN7HyS7Z6Auo_7tdADRv4N1XgAp6B_dQ8a8NZW2h3ra1E-OFsqXh3wkz-XAPYP2nN_ttjJXGawUx5FxOtopT4Djcnp3dlC8eeHYrW2uYWKxMvgoNhNzgAGdKYsZbU-UxCln1CZZzjifmBI7gkUJ1n0qVYixBUsavpT3XrbOpde7htqmp9D1klIgN-nTowZ0k8FiR__1mD2MgaBsnWXeBuzuzT189JhBLYmvr9yS0oYW0e_F-hfwoP9eZtoYH5GMudFpdzu0jEqjOSjRTIiqHd3bI0Ei03CuOl1GbtZsHRHJKhbRrhvZoOhujuqEi2fv0vhe_y7PlCh2zo18lAmUUX-0tdcbtX2mhVBTmJOlvQ5K1LxUsMhqGWtB_piTQtzSaR5S5myiOr_-Y8LRHcDBmJ6nzyOIO0RK_A8q6xc5U7SRKLdDRge3pnz5fsT7ppnAMpl_5pTQ8C23B-FcdD9atx_g7anHHEgelTDA9ehJ7MT9Qp9E8RdXykTVfjG-TZRJ37kFbsmc"
//////          'Authorization': 'Bearer ' + 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjNiM2JiMDIyZTk3M2U4MTQwY2IxNGYxMjFmYzI5MTI3Nzg1NWVmYjkyMTE0NDM3NjU1NWUxM2RhNjMxMWI1MjM3MjI5Mzk4ZDMwYmMyYWU1In0.eyJhdWQiOiIzIiwianRpIjoiM2IzYmIwMjJlOTczZTgxNDBjYjE0ZjEyMWZjMjkxMjc3ODU1ZWZiOTIxMTQ0Mzc2NTU1ZTEzZGE2MzExYjUyMzcyMjkzOThkMzBiYzJhZTUiLCJpYXQiOjE1ODA4NzY4NzQsIm5iZiI6MTU4MDg3Njg3NCwiZXhwIjoxNjEyNDk5Mjc0LCJzdWIiOiIzMiIsInNjb3BlcyI6W119.OJse5Ce-_Zze8C5aIWLAJuCz7pBBj5gF0BdiK0kSxRP-YMUSEnnrE7tiNWQcaUq--Nqu_BUcFHAjQqLaUmoH7iQLdvRIUxTDB7XrZLI9WohdnjF8qxd5r7qihuT0UBhHpIhMzBzFPy42YC6d6rvCsXflPC5w_0C4y0iqvN7HyS7Z6Auo_7tdADRv4N1XgAp6B_dQ8a8NZW2h3ra1E-OFsqXh3wkz-XAPYP2nN_ttjJXGawUx5FxOtopT4Djcnp3dlC8eeHYrW2uYWKxMvgoNhNzgAGdKYsZbU-UxCln1CZZzjifmBI7gkUJ1n0qVYixBUsavpT3XrbOpde7htqmp9D1klIgN-nTowZ0k8FiR__1mD2MgaBsnWXeBuzuzT189JhBLYmvr9yS0oYW0e_F-hfwoP9eZtoYH5GMudFpdzu0jEqjOSjRTIiqHd3bI0Ei03CuOl1GbtZsHRHJKhbRrhvZoOhujuqEi2fv0vhe_y7PlCh2zo18lAmUUX-0tdcbtX2mhVBTmJOlvQ5K1LxUsMhqGWtB_piTQtzSaR5S5myiOr_-Y8LRHcDBmJ6nzyOIO0RK_A8q6xc5U7SRKLdDRge3pnz5fsT7ppnAMpl_5pTQ8C23B-FcdD9atx_g7anHHEgelTDA9ehJ7MT9Qp9E8RdXykTVfjG-TZRJ37kFbsmc'
////////          "AUTHENTICATION_TOKEN": token
//////        },
////        encrypt: false,
////        stopOnTerminate: false,
////        startOnBoot: true,
////        enableHeadless: true,
////        locationsOrderDirection: "DESC",
////        maxDaysToPersist: 14
////    )).then((bg.State state) {
////      print('[ready] success: ${state}');
////    });
//
//
//
//
//
//
//
//    // // Without auth
////    bg.BackgroundGeolocation.ready(bg.Config(
//////            reset: true,
//////            debug: true,
//////            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
//////            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//////            distanceFilter: 10.0,
//////            url:
//////                "http://devapi.baniadam.info/ideaxen/api/in/v1/employees/employee/my/track/save/now",
//////            encrypt: false,
//////            stopOnTerminate: false,
//////            startOnBoot: true,
//////            enableHeadless: true))
//////        .then((bg.State state) {
//////      print("[ready] ${state.toMap()}");
//////      setState(() {
//////        _enabled = state.enabled;
//////        _isMoving = state.isMoving;
//////      });
//////    }).catchError((error) {
//////      print('[ready] ERROR: $error');
//////    });
//
//    // // Original
////    bg.BackgroundGeolocation.ready(bg.Config(
////        reset: true,
////        debug: true,
////        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
////        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
////        distanceFilter: 10.0,
////        url:"api.baniadam.app/demo/api/in/v1/employees/employee/my/track/save",
//////        url: "${ENV.TRACKER_HOST}/api/locations",
//////        authorization: bg.Authorization(  // <-- demo server authenticates with JWT
//////          strategy: bg.Authorization.STRATEGY_JWT,
//////          accessToken: token.accessToken,
////////          refreshToken: token.refreshToken,
////////          refreshUrl: "${ENV.TRACKER_HOST}/api/refresh_token",
////////          refreshPayload: {
////////            'refresh_token': '{refreshToken}'
////////          }
//////        ),
////        encrypt: false,
////        stopOnTerminate: false,
////        startOnBoot: true,
////        enableHeadless: true
////    )).then((bg.State state) {
////      print("[ready] ${state.toMap()}");
////      setState(() {
////        _enabled = state.enabled;
////        _isMoving = state.isMoving;
////      });
////    }).catchError((error) {
////      print('[ready] ERROR: $error');
////    });
//  }
//
//  void _onClickEnable(enabled) {
//    if (enabled) {
//      // Reset odometer.
//      bg.BackgroundGeolocation.start().then((bg.State state) {
//        print('[start] success $state');
//        setState(() {
//          _enabled = state.enabled;
//          _isMoving = state.isMoving;
//        });
//      }).catchError((error) {
//        print('[start] ERROR: $error');
//      });
//    } else {
//      bg.BackgroundGeolocation.stop().then((bg.State state) {
//        print('[stop] success: $state');
//
//        setState(() {
//          _enabled = state.enabled;
//          _isMoving = state.isMoving;
//        });
//      });
//    }
//  }
//
//  // Manually toggle the tracking state:  moving vs stationary
//  void _onClickChangePace() {
//    setState(() {
//      _isMoving = !_isMoving;
//    });
//    print("[onClickChangePace] -> $_isMoving");
//
//    bg.BackgroundGeolocation.changePace(_isMoving).then((bool isMoving) {
//      print('[changePace] success $isMoving');
//    }).catchError((e) {
//      print('[changePace] ERROR: ' + e.code.toString());
//    });
//  }
//
//  // Manually fetch the current position.
//  void _onClickGetCurrentPosition() {
//    bg.BackgroundGeolocation.getCurrentPosition(
//        persist: true,      // <-- do persist this location
//        desiredAccuracy: 0, // <-- desire best possible accuracy
//        timeout: 30000,     // <-- wait 30s before giving up.
//        samples: 3          // <-- sample 3 location before selecting best.
//    ).then((bg.Location location) {
//      print('[getCurrentPosition] - $location');
//    }).catchError((error) {
//      print('[getCurrentPosition] ERROR: $error');
//    });
//  }
//
//  // Go back to HomeApp.
//  void _onClickHome() {
////    runApp(HomeApp());
//  }
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
//      _odometer = odometerKM;
//    });
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
//    bg.BackgroundGeolocation.setConfig(bg.Config(
//      url: ENV.TRACKER_HOST + '/api/locations'
//    ));
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
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//          leading: IconButton(
//              icon: Icon(Icons.home, color: Colors.black),
//              onPressed: _onClickHome
//          ),
//          title: const Text('BG Geo'),
//          brightness: Brightness.light,
//          actions: <Widget>[
//            Switch(
//                value: _enabled,
//                onChanged: _onClickEnable
//            ),
//          ],
//          backgroundColor: Theme.of(context).bottomAppBarColor,
//      ),
//      body: SingleChildScrollView(
//          child: Text('$_content')
//      ),
//      bottomNavigationBar: BottomAppBar(
//          child: Container(
//              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//              child: Row(
//                  mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    IconButton(
//                      icon: Icon(Icons.gps_fixed),
//                      onPressed: _onClickGetCurrentPosition,
//                    ),
//                    Text('$_motionActivity · $_odometer km'),
//                    MaterialButton(
//                        minWidth: 50.0,
//                        child: Icon((_isMoving) ? Icons.pause : Icons.play_arrow, color: Colors.white),
//                        color: (_isMoving) ? Colors.red : Colors.green,
//                        onPressed: _onClickChangePace
//                    )
//                  ]
//              )
//          )
//      ),
//    );
//  }
//}