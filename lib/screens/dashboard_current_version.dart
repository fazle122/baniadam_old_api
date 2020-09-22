//import 'dart:math';
//
//import 'package:baniadam/screens/employee/attendance_request_list_for_employee.dart';
//import 'package:baniadam/screens/employee/monthly_holyday_list.dart';
//import 'package:baniadam/widgets/attendance_request_dialog.dart';
//import 'package:baniadam/widgets/base_state.dart';
//import 'package:baniadam/widgets/employee_info.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:baniadam/screens/approver/late_employee_list.dart';
//import 'package:baniadam/screens/employee/leave_requests_for_employee.dart';
//import 'package:baniadam/screens/approver/onleave_employee_list.dart';
//import 'package:baniadam/widgets/change_password_dialog.dart';
//import 'package:baniadam/widgets/leave_application_dialog.dart';
//import 'package:baniadam/widgets/logOut_confirmation_dialog.dart';
//import 'package:baniadam/widgets/unRegister_confirmation_dialog.dart';
//import 'dart:async';
//import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:baniadam/data_provider/api_service.dart';
//import 'package:baniadam/widgets/apply_attendence_dialog.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:baniadam/screens/approver/leave_requests_list_for_admin.dart';
//import '../screens/employee/current_date_personal_attendance.dart';
//import 'package:baniadam/screens/employee/montly_attendance_list.dart';
//import 'package:baniadam/screens/approver/attendance_list_for_admin_new.dart';
//import 'approver/attendance_list_for_admin_new.dart';
//import 'approver/absent_employee_list.dart';
//import 'package:flutter/services.dart';
//import 'package:file_picker/file_picker.dart';
//import 'package:dio/dio.dart';
//import 'package:toast/toast.dart';
//import 'package:custom_switch/custom_switch.dart';
//import 'package:camera/camera.dart';
//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
//import 'dart:convert';
//import 'approver/attendance_request_list_for_admin.dart';
//import 'approver/tracked_employees.dart';
//import 'employee/camera_view.dart';
//
//
//
//class DashboardPage extends StatefulWidget {
//  var token;
//  var userType;
//  var imagePath;
//  var attendanceId;
//  var currentUserRole;
//  bool employeeMenu;
//  FormData attendanceSelfie;
//
//  DashboardPage({
//    this.token,
//    this.userType,
//    this.imagePath,
//    this.attendanceId,
//    this.currentUserRole,
//    this.employeeMenu,
//    this.attendanceSelfie,
//    Key key,
//  }) : super(key: key);
//
//  @override
//  _DashboardPageState createState() => _DashboardPageState();
//}
//
//class _DashboardPageState extends BaseState<DashboardPage> {
//  String baseCdnUrl;
//  ScrollController _scrollController = new ScrollController();
//  bool isPerformingRequest = false;
//  Map<String, dynamic> personalDetail;
//  List personalAttendenceList;
//  List attendenceList;
//  List newAttendenceList;
//  Map<String, dynamic> filters;
//  DateTime now;
//  String _timeString;
//  String userType;
//  String currentUserRole;
//  String currentUserRoleForSwitch;
////  String userTypeForSwitch;
//  String getFlag;
//
//  String empId;
//  String photoUrl;
//  int id;
//  String userRole;
//  int currentPage;
//  int lastPage;
//  int nextPage;
//  var _imagePath;
//  bool _refreshDashBoard = false;
//
//  int empPresent;
//  int onTime;
//  int late;
//  int dayOff;
//  int onLeave;
//  int absent;
//  int totalPendingAttendancesToday;
//  int totalPendingLeaveApplications;
//  List absentEmployeeList;
//  List onLeaveEmployeeList;
//  List lateEmployeeList;
//  String companyLogo;
//  String cacheCompanyLogo;
//  Timer _timer;
//  bool updateImage = false;
//  bool employeeMenu;
//  bool switchUser = false;
//
//
//  @override
//  void initState() {
//    _getUserType();
//
//    _enabled = false;
//    absentEmployeeList = [];
//    onLeaveEmployeeList = [];
//    lateEmployeeList = [];
//    filters = new Map();
//    getCDN();
//    _getLogo();
//    notificationData = Map();
////    getNotification(this);
////    _getuserTypeForSwitch();
//    if(widget.attendanceId != null && widget.attendanceSelfie != null) {
//      updateSelfie(widget.attendanceId,widget.attendanceSelfie);
//    }
//    personalAttendenceList = [];
//    attendenceList = [];
//    newAttendenceList = [];
//    _getEmployeeDetail();
//    _getAttendanceList();
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _getMoreAttendanceList();
//      }
//    });
//    _getAdminData();
//
//    _timeString =
//    "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
//    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
////    _timer..periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
//    now = DateTime.now();
//    print('date :' + DateFormat("yyyy.MM.dd").format(now).toString());
//
//
////    _animationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
////    _animation = IntTween(begin: 100, end: 0).animate(_animationController);
////    _animation.addListener(() => setState(() {}));
//
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
//    _startTracking();
////    _initGeolocationTracking();
//    ////
//    //coder for background geolocation
//    ////
//    super.initState();
//  }
//
//  _startTracking() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    int isTrackable = prefs.getInt('isTrackable');
//    if(isTrackable == 1)
//    _initGeolocationTracking();
//  }
//
//// void notificationReceived(Map<String, dynamic> notificationData){
////   String userIdFromServer = notificationData['data_payload']['showTo'].toString();
////   if(userIdFromServer == currentUserId){
////     showOngoingNotification1(notifications,
////         title: notificationData['data_payload']['title'],
////         body: notificationData['data_payload']['body'], id: Random().nextInt(100));
////   }
//// }
//  getCDN() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var portalID = prefs.getString('curr-cid');
//    if (portalID != null) {
//      setState(() {
//        baseCdnUrl = ApiService.CDN_URl + "$portalID/";
//      });
//    }
//  }
//
//  Future<void> updateSelfie(attendanceId,attendanceIdSelfie) async{
//    ApiService.updateAttendanceRequest(attendanceId,attendanceIdSelfie);
//  }
//
//  bool refreshPersonalList = false;
//
//  void _getCurrentTime() {
//    final DateTime now = DateTime.now();
//    final String formattedDateTime = _formatDateTime(now);
//    setState(() {
//      _timeString = formattedDateTime;
//    });
//  }
//
//  String _formatDateTime(DateTime dateTime) {
//    return DateFormat('hh:mm:ss a').format(dateTime);
//  }
//
//  void _getLogo() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var cid = prefs.getString('curr-cid');
//    var cacheLogo = prefs.getString('logo-url');
//    setState(() {
//      cacheCompanyLogo = cacheLogo;
//    });
//
//    final Map<String, dynamic> data = await ApiService.getLogo(cid);
//    if (data.containsKey('id') && data['id'] != null) {
//      setState(() {
//        companyLogo = baseCdnUrl + data['value'];
//      });
//    } else {
//      setState(() {
//        companyLogo = null;
//      });
//    }
//  }
//
//  Widget _sizedContainer(Widget child) {
//    return new SizedBox(
//      width: 100.0,
////      height: 50.0,
//      height: MediaQuery.of(context).size.height * 1 / 10,
//      child: new Center(
//        child: child,
//      ),
//    );
//  }
//
//  void _getEmployeeDetail() async {
//    final Map<String, dynamic> detailData =
//    await ApiService.getEmployeeDetail();
//    if (detailData != null) {
//      setState(() {
//        personalDetail = detailData;
//        id = personalDetail['id'];
//        empId = personalDetail['employeeId'];
//        userRole = personalDetail['department']['value'];
//        photoUrl = personalDetail['photoAttachment'];
//        print(userRole);
//        print('employee ID: ' + empId);
//      });
//      final List<dynamic> personalAttendenceData =
//      await ApiService.getCurrentDatePersonalAttendanceList();
//      if (personalAttendenceData != null) {
//        setState(() {
//          personalAttendenceList.addAll(personalAttendenceData);
//        });
//      }
//    }
//  }
//
//  void _getAdminData() async {
////    _getEmployeeDetail();
//    setState(() {
//      _refreshDashBoard = true;
//    });
////    if(userType == 1){
//    final Map<String, dynamic> dashBoardData =
//    await ApiService.getDashBoardData();
//    if (dashBoardData != null) {
//      List empToAttend = dashBoardData['current_shift_employees'];
//      List empOnleave = dashBoardData['onleave']['data'];
//      List empLate = dashBoardData['late']['data'];
//      List empDayOff = dashBoardData['offday_employees'];
//      absentEmployeeList = dashBoardData['absent_employees'];
//      onLeaveEmployeeList = dashBoardData['onleave']['data'];
//      lateEmployeeList = dashBoardData['late']['data'];
//      setState(() {
//        empPresent = empToAttend.length != null ? empToAttend.length : '0';
//        onTime = dashBoardData['late']['total'] != null
//            ? dashBoardData['total_present'] - dashBoardData['late']['total']
//            : '0';
//        late = empLate.length == null ? 0 : empLate.length;
//        onLeave = empOnleave.length == null ? 0 : empOnleave.length;
//        dayOff = empDayOff.length;
//        absent = dashBoardData['total_absent'];
//
//        totalPendingAttendancesToday = dashBoardData['total_present'] != null &&
//            dashBoardData['total_present'].toString() != 'n/a'
//            ? dashBoardData['total_present']
//            : '0';
//        totalPendingLeaveApplications =
//        dashBoardData['total_pending_leave_applications'] != null ||
//            dashBoardData['total_pending_leave_applications'] != 'n/a'
//            ? dashBoardData['total_pending_leave_applications']
//            : '0';
//        _refreshDashBoard = false;
//      });
//    }
////    }
//  }
//
//  void _getEmployeeData() async {
//    final Map<String, dynamic> detailData =
//    await ApiService.getEmployeeDetail();
//    if (detailData != null) {
//      setState(() {
//        personalDetail = detailData;
//        photoUrl = personalDetail['photoAttachment'];
//      });
//    }
//    setState(() {
//      refreshPersonalList = true;
//    });
//    personalAttendenceList = [];
//    final List<dynamic> personalAttendenceData =
//    await ApiService.getCurrentDatePersonalAttendanceList();
//    if (personalAttendenceData != null) {
//      setState(() {
//        refreshPersonalList = false;
//        personalAttendenceList.addAll(personalAttendenceData);
//      });
//    }
//  }
//
////  _getuserTypeForSwitch() async {
////    SharedPreferences prefs = await SharedPreferences.getInstance();
////    var type = prefs.getString('user-type');
////    setState(() {
////      userTypeForSwitch = type;
////    });
////  }
//
//  _getUserType() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var role = prefs.getString('user-role');
//    if(role == 'Admin' && widget.employeeMenu != null){
//      setState(() {
//        employeeMenu = true;
//        currentUserRoleForSwitch = role;
//        currentUserRole = role;
//        switchUser = true;
//
//      });
//    }
//    else if(role == 'Admin' && widget.employeeMenu == null){
//      setState(() {
//        employeeMenu = false;
//        currentUserRoleForSwitch = role;
//        currentUserRole = role;
//        switchUser = false;
//
//      });
//    }else {
//      setState(() {
//        employeeMenu = true;
//        currentUserRoleForSwitch = role;
//        currentUserRole = role;
//      });
//    }
//
////    if (widget.currentUserRole == null ) {
////      setState(() {
////        switchUser = false;
////      });
////    }
////    else {
////      setState(() {
//////        currentUserRole = widget.currentUserRole;
////        switchUser = true;
////      });
////    }
//
//  }
//
////  _getUserType() async {
////    if (widget.userType == null || widget.userType == "") {
////      SharedPreferences prefs = await SharedPreferences.getInstance();
////      var type = prefs.getString('user-type');
////      var role = prefs.getString('user-role');
////      setState(() {
////        userType = type;
////        currentUserRole = role;
////        userTypeForSwitch = type;
////      });
////      if  (userType == 'Approver' || currentUserRole == 'Admin') {
////        setState(() {
////          adminMenu = true;
////        });
////      } else {
////        setState(() {
////          adminMenu = false;
////        });
////      }
////    } else {
////      setState(() {
////        userType = widget.userType;
////      });
////      if  (userType == 'Approver' || currentUserRole == 'Admin') {
////        setState(() {
////          adminMenu = true;
////        });
////      } else {
////        setState(() {
////          adminMenu = false;
////        });
////      }
////    }
////  }
//
//  void _getAttendanceList() async {
////    if (!isPerformingRequest) {
////      setState(() => isPerformingRequest = true);
////    }
//    if (userType == 1) {
//      Map<String, dynamic> attendenceData =
//      await ApiService.getAttendanceList(filters);
//
//      if (attendenceData.containsKey('data') &&
//          attendenceData['data'] != null) {
//        print(attendenceData['data']);
//        setState(() {
//          currentPage = attendenceData['current_page'];
//          lastPage = attendenceData['last_page'];
//          attendenceList.addAll(attendenceData['data']);
//          print(attendenceList.length.toString());
//        });
//      }
//    }
//  }
//
//  void _getMoreAttendanceList() async {
////    if (!isPerformingRequest) {
////      setState(() => isPerformingRequest = true);
////    }
//
//    newAttendenceList.clear();
//
//    if (currentPage < lastPage) {
//      setState(() {
//        currentPage += 1;
//        filters['page'] = currentPage;
//      });
//      final Map<String, dynamic> attendenceData =
//      await ApiService.getAttendanceList(filters);
//      if (attendenceData != null) {
//        print(attendenceData['data']);
//        setState(() {
//          newAttendenceList.addAll(attendenceData['data']);
//          attendenceList.addAll(newAttendenceList);
//          print(attendenceList.length.toString());
//          print(newAttendenceList);
//        });
//      }
//    } else if (currentPage == lastPage) {}
//  }
//
//  _personalAttendancListItemUI() {
//    if (personalAttendenceList.isNotEmpty)
//      return EmployeeAttendenceItemListWidget(
//        attendanceItems: personalAttendenceList,
//        isPerformingRequest: isPerformingRequest,
//      );
////    if (isPerformingRequest)
////      return Center(
////        child: CircularProgressIndicator(),
////      );
////
//    return Center(
//      child: Text('no attendance data'),
//    );
//  }
//
//  Future<Map<String, dynamic>> _logOutDialog(BuildContext context) async {
//    return showDialog<Map<String, dynamic>>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) => LogOutConfirmationDialog(),
//    );
//  }
//
//  Future<Map<String, dynamic>> _unRegisterDialog(BuildContext context) async {
//    return showDialog<Map<String, dynamic>>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) => UnRegisterConfirmationDialog(),
//    );
//  }
//
//  Future<Map<String, dynamic>> _changePassDialog(BuildContext context) async {
//    return showDialog<Map<String, dynamic>>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) => ChangePasswordDialog(),
//    );
//  }
//
//  _applyAttendanceRequest(BuildContext context, var imagePath,var currentUserRole) async {
//    return showDialog<String>(
//        barrierDismissible: false,
//        context: context,
//        builder: (BuildContext context) => AttendenceConfirmationDialog(
//            currentUserRole: currentUserRole,
//            uId: personalDetail['employeeId'],
//            userName: personalDetail['fullName']));
//  }
//
//  void _applyForAttendance(BuildContext context,String currentUserRole) async {
//    final cameras = await availableCameras();
//    final firstCamera = cameras.last;
//
//    await Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(
//            builder: (context) => TakePictureScreen(
//                camera: firstCamera,userId: personalDetail['employeeId'], userName: personalDetail['fullName'],currentUserRole:currentUserRole)));
//
//  }
//
//  _linkItem2({Icon icon, Color primaryColor, String title, String value, Icon clickIcon}) {
//    return Container(
//        height: MediaQuery.of(context).size.height * 1.7 / 10,
//        width: MediaQuery.of(context).size.width * 2.2 / 5,
//        margin: EdgeInsets.only(left: 10.0, right: 10.0),
//        child: Card(
//            elevation: 20.0,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(15.0)),
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                clickIcon != null
//                    ? Center(
//                  child: Container(
//                    height: 0.0,
//                    padding: EdgeInsets.only(right: 10.0),
//                    alignment: AlignmentDirectional(1.0, 0.0),
//                    child: clickIcon,
//                  ),
//                )
//                    : SizedBox(
//                  width: 0.0,
//                  height: 0.0,
//                ),
////                Center(child: clickIcon),
//                Center(child: icon),
//                Center(
//                  child: Text(title),
//                ),
//                Center(
//                  child: Text(value.toString()),
//                ),
////            Row(
////              mainAxisSize: MainAxisSize.max,
////              mainAxisAlignment: MainAxisAlignment.spaceBetween,
////              children: <Widget>[
////                Column(
////                  children: <Widget>[
////                    Container(
////                      color: primaryColor,
//////                  padding: EdgeInsets.all(20.0),
////                      width: MediaQuery.of(context).size.width * 1 / 5,
////                      height: MediaQuery.of(context).size.height * .85 / 10,
////                      child: Center(child: icon),
////                    ),
////                  ],
////                ),
////                Column(
////                  mainAxisSize: MainAxisSize.max,
////                  children: <Widget>[
////                    Container(
////                      child: Text(
////                        title,
////                        style: TextStyle(fontSize: 15.0, color: Colors.white),
////                      ),
////                    ),
////                    Container(
////                      child: Text(
////                        value,
////                        style: TextStyle(
////                            fontSize: 25.0,
////                            fontWeight: FontWeight.bold,
////                            color: Colors.white),
////                      ),
////                    )
////                  ],
////                ),
////                Column(
////                  crossAxisAlignment: CrossAxisAlignment.end,
////                  children: <Widget>[
////                    Container(
////                      width: MediaQuery.of(context).size.width * 1 / 5,
////                      height: MediaQuery.of(context).size.height * .85 / 10,
////                      child: Center(child: clickIcon),
////                    ),
////                  ],
////                ),
////              ],
////            )
//              ],
//            )));
//  }
//
//  Widget adminDashboard() {
//    return Column(
//      children: <Widget>[
//        SizedBox(
//          height: 10.0,
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            _linkItem2(
//              icon: Icon(Icons.people),
//              primaryColor: Color(0xFFF0F0F0),
//              title: 'Employees to attend',
//              value: empPresent.toString(),
//            ),
//            _linkItem2(
//              icon: Icon(Icons.alarm_off),
//              primaryColor: Color(0xFFF0F0F0),
//              title: 'Day-off',
//              value: dayOff.toString(),
//            ),
//          ],
//        ),
//        SizedBox(
//          height: 10.0,
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            _linkItem2(
//              icon: Icon(Icons.sentiment_satisfied),
//              primaryColor: Color(0xFFF0F0F0),
//              title: 'On time',
//              value: onTime.toString(),
//            ),
//            InkWell(
//              child: _linkItem2(
//                  icon: Icon(Icons.warning),
//                  primaryColor: Color(0xFFF0F0F0),
//                  title: 'Late',
//                  value: late.toString(),
//                  clickIcon: Icon(
//                    Icons.launch,
//                    size: 15.0,
//                    color: Colors.black,
//                  )),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => LateEmployeeListPage(
//                          lateEmployee: lateEmployeeList,
//                        )));
//              },
//            ),
//          ],
//        ),
//        SizedBox(
//          height: 10.0,
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            InkWell(
//              child: _linkItem2(
//                  icon: Icon(Icons.directions_car),
//                  primaryColor: Color(0xFFF0F0F0),
//                  title: 'On-leave',
//                  value: onLeave.toString(),
//                  clickIcon: Icon(
//                    Icons.launch,
//                    size: 15.0,
//                    color: Colors.black,
//                  )),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => OnLeaveEmployeeListPage(
//                          onLeaveEmployee: onLeaveEmployeeList,
//                        )));
//              },
//            ),
//            InkWell(
//              child: _linkItem2(
//                  icon: Icon(Icons.sentiment_dissatisfied),
//                  primaryColor: Color(0xFFF0F0F0),
//                  title: 'Absent',
//                  value: absent.toString(),
//                  clickIcon: Icon(
//                    Icons.launch,
//                    size: 15.0,
//                    color: Colors.black,
//                  )),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AbsentEmployeeListPage(
//                          absentEmployee: absentEmployeeList,
//                        )));
//              },
//            ),
//          ],
//        ),
//        SizedBox(
//          height: 10.0,
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            InkWell(
//              child: _linkItem2(
//                  icon: Icon(Icons.alarm_on),
//                  primaryColor: Color(0xFFF0F0F0),
//                  title: 'Present',
//                  value: totalPendingAttendancesToday.toString(),
//                  clickIcon: Icon(
//                    Icons.launch,
//                    size: 15.0,
//                    color: Colors.black,
//                  )),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AttendanceListPageForAdmin()));
////                builder: (context) => AttendanceListPage()));
//              },
//            ),
//            InkWell(
//              child: _linkItem2(
//                  icon: Icon(Icons.flight),
//                  primaryColor: Color(0xFFF0F0F0),
//                  title: 'Leave requests',
//                  value: totalPendingLeaveApplications.toString(),
//                  clickIcon: Icon(
//                    Icons.launch,
//                    size: 15.0,
//                    color: Colors.black,
//                  )),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => LeaveRequestListPage()));
//              },
//            ),
//          ],
//        ),
//        SizedBox(
//          height: 10.0,
//        ),
//      ],
//    );
//  }
//
//  Widget employeeDashboard() {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            Container(
//                height: MediaQuery.of(context).size.height * .5 / 10,
//                child: Row(
//                  children: <Widget>[
//                    Text(
//                      _timeString,
//                      style:
//                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                    ),
//                  ],
//                )),
//          ],
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            InkWell(
//              child: Container(
//                decoration: new BoxDecoration(
//                  gradient: LinearGradient(
//                    colors: <Color>[
//                      Color(0xFF36AFEA),
//                      Color(0xFF37B8E5),
//                      Color(0xFF38C1E0),
//                      Color(0xFF39CCDA),
//                      Color(0xFF3AD8D3),
//                    ],
//                  ),
//                  color: Theme.of(context).primaryColorDark,
//                  shape: BoxShape.circle,
//                ),
//                width: MediaQuery.of(context).size.width * 2 / 5,
//                height: MediaQuery.of(context).size.height * 2.3 / 10,
//                child: Center(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Center(
//                        child: Text('Give',
//                            style:
//                            TextStyle(color: Colors.white, fontSize: 20.0)),
//                      ),
//                      Center(
//                        child: Text('Attendance',
//                            style:
//                            TextStyle(color: Colors.white, fontSize: 20.0)),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              onTap: () async {
////                await _applyAttendanceRequest(context, _imagePath,'');
//                await _applyForAttendance(context,currentUserRole);
//              },
//            ),
//          ],
//        ),
//        Container(
//          height: MediaQuery.of(context).size.height * .5 / 10,
//          child: Center(
//            child: Text(
//              'Today\'s Attendances',
//              style: Theme.of(context).textTheme.title,
//            ),
//          ),
//        ),
//        Container(
//          height: MediaQuery.of(context).size.height * .5 / 10,
//          child: Center(
//            child: Text(
//              DateFormat.yMMMEd().format(
//                DateTime.parse(
//                  DateTime.now().toString(),
//                ),
//              ),
//              style: TextStyle(fontWeight: FontWeight.bold),
//            ),
//          ),
//        ),
//        !refreshPersonalList
//            ? Container(
//          decoration: BoxDecoration(
//            color: Theme.of(context).primaryColor,
//            borderRadius: new BorderRadius.only(
//                topLeft: const Radius.circular(10.0),
//                topRight: const Radius.circular(10.0)),
//          ),
//          margin: EdgeInsets.only(left: 5.0, right: 5.0),
//          padding: EdgeInsets.only(top: 5.0),
//          height: MediaQuery.of(context).size.height * 4.02 / 10,
//          child: Center(child: _personalAttendancListItemUI()),
//        )
//            : Container(
//            width: MediaQuery.of(context).size.width,
//            padding: EdgeInsets.only(top: 100.0),
//            child: Center(child: CircularProgressIndicator()))
//      ],
//    );
//  }
//
//  Future<bool> _onBackPressed() {
//    return showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
//              contentPadding: EdgeInsets.all(25.0),
//              title: Center(child: Text('Exit app confirmation')),
//              content: SingleChildScrollView(
//                child: Column(
//                  children: <Widget>[
//                    Text('You are sure, you want to exit the application?'),
//                    SizedBox(
//                      height: 30.0,
//                    ),
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisSize: MainAxisSize.max,
//                      children: <Widget>[
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
//                            InkWell(
//                              child: Container(
//                                width: 100.0,
//                                height: 35.0,
//                                decoration: ShapeDecoration(
//                                  color: Colors.white,
//                                  shape: RoundedRectangleBorder(
//                                    side: BorderSide(
//                                        width: 1.0,
//                                        style: BorderStyle.solid,
//                                        color: Colors.grey.shade500),
//                                    borderRadius:
//                                    BorderRadius.all(Radius.circular(3.0)),
//                                  ),
//                                ),
//                                child: Center(
//                                    child: Text(
//                                      'No',
//                                      style: TextStyle(
//                                          color:
//                                          Theme.of(context).primaryColorDark),
//                                    )),
//                              ),
//                              onTap: () {
//                                Navigator.of(context).pop(false);
//                              },
//                            ),
//                            InkWell(
//                              child: Container(
//                                width: 100.0,
//                                height: 35.0,
//                                decoration: ShapeDecoration(
//                                  color: Theme.of(context).buttonColor,
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius:
//                                    BorderRadius.all(Radius.circular(3.0)),
//                                  ),
//                                ),
//                                child: Center(
//                                    child: Text(
//                                      'Yes',
//                                      style: TextStyle(color: Colors.white),
//                                    )),
//                              ),
//                              onTap: () async {
//                                await SystemChannels.platform
//                                    .invokeMethod<void>('SystemNavigator.pop');
//                              },
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              )
//            // _filterOptions(context),
//          );
//        });
//  }
//
//  updateEmployeePic(FormData formData) async {
//    final Map<String, dynamic> successinformation =
//    await ApiService.updateEmployeeInfo(formData);
//
//    if (successinformation['success']) {
//      Toast.show(successinformation['message'], context,
//          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//      Navigator.of(context, rootNavigator: true).pop('success');
//    } else {
//      Toast.show(successinformation['message'], context,
//          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }
//  }
//
//  Future<String> _asyncEmpDialog(BuildContext context) async {
//    return showDialog<String>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) =>
//          EmployeeInfoDialog(data: personalDetail),
//    );
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//        onWillPop: _onBackPressed,
//        child: Scaffold(
//            appBar: AppBar(
//              automaticallyImplyLeading: false,
//              title: Text('BaniAdam HR'),
//              leading: new Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: InkWell(
//                  child: Material(
//                    shape: new CircleBorder(),
//                    child: photoUrl != null && photoUrl != "''"
//                        ? CircleAvatar(
//                      radius: 30.0,
//                      backgroundImage:
////                            NetworkImage(baseCdnUrl +personalDetail['photoAttachment']),
//                      NetworkImage(baseCdnUrl + photoUrl),
//                      backgroundColor: Colors.transparent,
//                    )
//                        : CircleAvatar(
////                      child: Image.asset('assets/profile.png'),
//                      backgroundImage: AssetImage('assets/profile.png'),
//                      radius: 30.0,
//                      backgroundColor: Colors.transparent,
//                    ),
//                  ),
//                  onTap: () async {
//                    var updatedPhoto = await _asyncEmpDialog(context);
//                    if (updatedPhoto != null) {
//                      final Map<String, dynamic> detailData =
//                      await ApiService.getEmployeeDetail();
//                      if (detailData != null) {
//                        setState(() {
//                          personalDetail = detailData;
//                          photoUrl = detailData['photoAttachment'];
//                        });
//                      }
//                    }
//                  },
//                ),
//              ),
//              actions: <Widget>[
//                currentUserRoleForSwitch == 'Admin'
//                    ?
//                Container(
//                    height:15.0,
//                    child:CustomSwitch(
//                      activeColor: Color(0xffB2B2B2),
//                      value: switchUser,
//                      onChanged: (value) {
//                        setState(() {
//                          switchUser = value;
//                          employeeMenu = value;
////                          switchUser?
////                          _updateUserType('Admin'):_updateUserType('');
//                        });
//
//                      },
//                    )
//                ) : SizedBox(
//                  width: 0.0,
//                  height: 0.0,
//                ),
////                Switch(value: _enabled, onChanged: _onClickEnable),
//                IconButton(
//                  icon: Icon(Icons.refresh),
//                  onPressed: () {
//                    _getAdminData();
//                    _getEmployeeData();
//                  },
//                ),
//                PopupMenuButton<String>(
//                  onSelected: (val) async {
//                    switch (val) {
//                      case 'VIEW_ATTENDANCE_LIST':
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    MonthlyAttendanceListPage(id: id)));
//                        break;
//                      case 'ATTENDANCE_REQUEST_LIST':
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    AttendanceRequestListPageForEmployee()));
//                        break;
//                      case 'VIEW_HOLYDAY_LIST':
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    MonthlyHolydayListPage(id: id)));
//                        break;
//                      case 'LEAVE_REQ_DIALOG':
//                        showDialog<Map<String, dynamic>>(
//                          barrierDismissible: false,
//                          context: context,
//                          builder: (BuildContext context) =>
//                              LeaveApplicationDialogPage(),
//                        );
//                        break;
//                      case 'APPLIED_LEAVES':
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    PersonalLeaveRequestListPage()));
//
//                        break;
//                      case 'MANUAL_ATTENDANCE':
//                        showDialog<Map<String, dynamic>>(
//                          barrierDismissible: false,
//                          context: context,
//                          builder: (BuildContext context) =>
//                              AttendanceRequestDialogPage(
//                                  userId: personalDetail['employeeId'],
//                                  userName: personalDetail['fullName'],
//                                  currentUserRole: '',
//                                  employeeMenu:true,
//                              ),
//                        );
//
//                        break;
//                      case 'ATTENDANCE_REQUEST_LIST_FOR_ADMIN':
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    AttendanceRequestListPageForAdmin()));
//                        break;
//                      case 'DAILY_TRACKING':
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    TrackableEmployeesForAdmin()));
//                        break;
//                      case 'CHANGE_PASS':
//                        _changePassDialog(context);
//                        break;
//                      case 'LOGOUT':
//                        _logOutDialog(context);
//                        break;
//                      case 'UNREGISTER':
//                        _unRegisterDialog(context);
//                        break;
//                    }
//                  },
//                  itemBuilder: (BuildContext context) =>
//                  <PopupMenuItem<String>>[
//                    employeeMenu?
//                    PopupMenuItem<String>(
//                      value: 'VIEW_ATTENDANCE_LIST',
//                      child: Text('Monthly attendance'),
//                    ):PopupMenuItem(height: 0.0,),
//                    employeeMenu?
//                    PopupMenuItem<String>(
//                      value: 'ATTENDANCE_REQUEST_LIST',
//                      child: Text('Attendance requests'),
//                    ):PopupMenuItem(height: 0.0,),
//                    employeeMenu?
//                    PopupMenuItem<String>(
//                      value: 'LEAVE_REQ_DIALOG',
//                      child: Text('Apply for leave'),
//                    ):PopupMenuItem(height: 0.0,),
//                    employeeMenu?
//                    PopupMenuItem<String>(
//                      value: 'APPLIED_LEAVES',
//                      child: Text('Applied leaves'),
//                    ):PopupMenuItem(height: 0.0,),
//                    employeeMenu?
//                    PopupMenuItem<String>(
//                      value: 'MANUAL_ATTENDANCE',
//                      child: Text('Request for attendance'),
//                    ):PopupMenuItem(height: 0.0,),
//                    !employeeMenu?
//                    PopupMenuItem<String>(
//                      value: 'ATTENDANCE_REQUEST_LIST_FOR_ADMIN',
//                      child: Text('Attendance requests'),
//                    ):PopupMenuItem(height: 0.0,),
//                    !employeeMenu?
//                    PopupMenuItem<String>(
//                      value: 'DAILY_TRACKING',
//                      child: Text('Daily tracking'),
//                    ):PopupMenuItem(height: 0.0,),
//                    PopupMenuItem<String>(
//                      value: 'CHANGE_PASS',
//                      child: Text('Change password'),
//                    ),
//                    PopupMenuItem<String>(
//                      value: 'LOGOUT',
//                      child: Text('Logout'),
//                    ),
//                    PopupMenuItem<String>(
//                      value: 'UNREGISTER',
//                      child: Text('Unregister'),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//            body: Container(
//                child: Column(
//                  children: <Widget>[
//                    companyLogo != null
//                        ? Container(
//                        height: MediaQuery.of(context).size.height * .9 / 10,
//                        width: MediaQuery.of(context).size.width * .8 / 5,
//                        child: _sizedContainer(
//                          CachedNetworkImage(
//                            imageUrl: companyLogo,
//                            placeholder: (context, url) =>
//                            new CircularProgressIndicator(),
//                            errorWidget: (context, url, error) =>
//                                _sizedContainer(Image.asset(
//                                    'assets/icons/BaniAdam-Logo_Final.png')),
//                            fadeOutDuration: new Duration(seconds: 1),
//                            fadeInDuration: new Duration(seconds: 3),
//                          ),
//                        ))
//                        : SizedBox(
//                      child: CircularProgressIndicator(),
//                    ),
//                    Container(
//                        child: personalDetail != null?
//                        Container(
//                          child:  currentUserRole == 'Admin'
//                              ? switchUser
//                              ? employeeDashboard()
//                              : adminDashboard()
//                              : employeeDashboard(),
//                        )
////                        Container(
////                          child:  currentUserRole == 'Admin'
////                              ? switchUser
////                              ? employeeDashboard()
////                              : adminDashboard()
////                              : switchUser
////                              ? adminDashboard()
////                              : employeeDashboard(),
////                        )
////                        Container(
////                          child:  currentUserRole == 'Admin'
////                              ? !switchUser
////                              ? employeeDashboard()
////                              : adminDashboard()
////                              : switchUser
////                              ? adminDashboard()
////                              : employeeDashboard(),
////                        )
//                            : Container(
//                            width: MediaQuery.of(context).size.width,
//                            child: Center(child: CircularProgressIndicator()))),
//                  ],
//                ))));
//  }
//
//  @override
//  void dispose() {
//    Timer.periodic(Duration(seconds: 1), null).cancel();
//    super.dispose();
//  }
//  bool _enabled;
//
////  void _onClickEnable(enabled) {
////    if (enabled) {
////      // Reset odometer.
////      bg.BackgroundGeolocation.start().then((bg.State state) {
////        print('[start] success $state');
////        setState(() {
////          _enabled = state.enabled;
////        });
////      }).catchError((error) {
////        print('[start] ERROR: $error');
////      });
////    } else {
////      bg.BackgroundGeolocation.stop().then((bg.State state) {
////        print('[stop] success: $state');
////
////        setState(() {
////          _enabled = state.enabled;
////        });
////      });
////    }
////  }
//
//
//  bool _isMoving;
////  bool _enabled;
//  String _motionActivity;
//  String _odometer;
//  String _content;
//  Map<String,dynamic> coordinates;
////  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//  ////
//  //code for background geolocation
//  ////
//
//  Future<Null> _initGeolocationTracking() async {
//    String currentUserToken1;
//    String url;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var token = prefs.getString('curr-user');
//    var portalID = prefs.getString('curr-cid');
//    setState(() {
//      currentUserToken1 = token;
//      url = ApiService.BASE_URL+ portalID +"/api/in/v1/employees/employee/my/track/save";
//    });
////    SharedPreferences prefs = await SharedPreferences.getInstance();
////    var currentUserToken = prefs.getString('curr-user');
//
//    // 1.  Listen to events (See docs for all 12 available events).
//    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
//    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
//    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
//    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
//    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
//    bg.BackgroundGeolocation.onHttp(_onHttp);
////    bg.BackgroundGeolocation.onAuthorization(_onAuthorization);
//
//    // 2.  Configure the plugin
//
//    bg.BackgroundGeolocation.ready(bg.Config(
//        allowIdenticalLocations:true,
//        enableHeadless:true,
//        deferTime: 15000,
//        startOnBoot:true,
//        stopOnTerminate:false,
//        autoSync: true,
//        autoSyncThreshold: 1,
//        batchSync: true,
//        maxBatchSize: 20,
//        reset: true,
//        debug: true,
//        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
//        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//        distanceFilter: 50.0,
//
////      url:"http://devapi.baniadam.info/ideaxen/api/filetest",
////      url:"http://devapi.baniadam.info/ideaxen/api/filetest2",
//        url:url,
//        authorization: bg.Authorization(
////        strategy: bg.Authorization.STRATEGY_JWT,
//          accessToken:currentUserToken1,
////          refreshToken: token.refreshToken,
////          refreshUrl: "${ENV.TRACKER_HOST}/api/refresh_token",
////          refreshPayload: {
////            'refresh_token': '{refreshToken}'
////          }
//        ),
//
//        encrypt: false,))
//        .then((bg.State state) {
//      print("[ready] ${state.toMap()}");
////      setState(() {
////        _enabled = state.enabled;
////        _isMoving = state.isMoving;
////      });
//    }).catchError((error) {
//      print('[ready] ERROR: $error');
//    });
//
//
//    bg.BackgroundGeolocation.start().then((bg.State state) {
//      print('[start] success $state');
////      setState(() {
////        _enabled = state.enabled;
////        _isMoving = state.isMoving;
////      });
//    }).catchError((error) {
//      print('[start] ERROR: $error');
//    });
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
////  void _onAuthorization(bg.AuthorizationEvent event) async {
////    print('[${bg.Event.AUTHORIZATION}] = $event');
////
////    bg.BackgroundGeolocation.setConfig(bg.Config(
////        url: ENV.TRACKER_HOST + '/api/locations'
////    ));
////  }
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
//}
