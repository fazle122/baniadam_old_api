//import 'package:baniadam/screens/employee/monthly_holyday_list.dart';
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
//import 'package:baniadam/widgets/attendance_filter_dialog.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:baniadam/screens/employee/leave_application.dart';
//import 'package:baniadam/screens/approver/leave_requests_list_for_admin.dart';
//import 'package:baniadam/screens/employee/current_date_personal_attendance.dart';
//import 'package:baniadam/screens/employee/montly_attendance_list.dart';
//import 'approver/absent_employee_list.dart';
//import 'approver/attendance_list_for_admin_backup.dart';
//import 'package:flutter/services.dart';
//import 'package:file_picker/file_picker.dart';
//import 'package:dio/dio.dart';
//import 'package:toast/toast.dart';
//import 'dart:io';
//
//
//
//
//import 'approver/attendance_requests_list.dart';
//
//class DashboardPage extends StatefulWidget {
//  var userType;
//  var imagePath;
//
//  DashboardPage({
//    this.userType,
//    this.imagePath,
//    Key key,
//  }) : super(key: key);
//
//  @override
//  _DashboardPageState createState() => _DashboardPageState();
//}
//
//class _DashboardPageState extends BaseState<DashboardPage> {
//  ScrollController _scrollController = new ScrollController();
//  bool isPerformingRequest = false;
//  Map<String, dynamic> personalDetail;
//  List personalAttendenceList;
//  List attendenceList;
//  List newAttendenceList;
//  Map<String, dynamic> filters;
//  DateTime now;
//  String _timeString;
//  int userType;
//  String titleDurationHeader = 'Today\'s';
//  String titleStatusHeader = 'pending';
//
//  Color _buttonDisableColor;
//  String getFlag;
//
//  String empId;
//  String photoUrl;
//  int id;
//  String _pickedDuration = "today";
//  String _pickedStatus = "pending";
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
//
//  FileType _pickingType;
//  String _extension;
//  String _fileName;
//  var _imagePaths;
//  bool updateImage = false;
//
//
//
//
//  @override
//  void initState() {
//    _pickingType = FileType.IMAGE;
//    absentEmployeeList = [];
//    onLeaveEmployeeList = [];
//    lateEmployeeList = [];
//    filters = new Map();
//    _getLogo();
//    filters['duration'] = _pickedDuration;
//    filters['status'] = _pickedStatus;
//    _getUserType();
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
//    _getDashBoardData();
//
//    _timeString =
//        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
//    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
////    _timer..periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
//    now = DateTime.now();
//    print('date :' + DateFormat("yyyy.MM.dd").format(now).toString());
//
//    super.initState();
//  }
//
//  _refreshListData() {
//    filters = new Map();
//    _getLogo();
//    filters['duration'] = _pickedDuration;
//    filters['status'] = _pickedStatus;
//    _getUserType();
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
//
//    _getDashBoardData();
//  }
//
//  bool refreshPersonalList = false;
//
//  _refreshPersonalData() async {
//    setState(() {
//      refreshPersonalList = true;
//    });
//    personalAttendenceList = [];
////    final List<dynamic> personalAttendenceData =
////        await ApiService.getDateWisePersonalAttendanceList(
////            id, DateFormat("yyyy.MM.dd").format(now));
//    final List<dynamic> personalAttendenceData =
//        await ApiService.getCurrentDatePersonalAttendanceList();
//    if (personalAttendenceData != null) {
//      setState(() {
//        refreshPersonalList = false;
//        personalAttendenceList.addAll(personalAttendenceData);
//      });
//    }
//  }
//
//
//
//  @override
//  void dispose() {
//    Timer.periodic(Duration(seconds: 1), null).cancel();
//    super.dispose();
//  }
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
//        companyLogo = data['value'];
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
//    height: MediaQuery.of(context).size.height * 1/10,
//      child: new Center(
//        child: child,
//      ),
//    );
//  }
//
//  void _getEmployeeDetail() async {
//    final Map<String, dynamic> detailData =
//        await ApiService.getEmployeeDetail();
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
//          await ApiService.getCurrentDatePersonalAttendanceList();
//      if (personalAttendenceData != null) {
//        setState(() {
//          personalAttendenceList.addAll(personalAttendenceData);
//        });
//      }
//    }
//  }
//
//  void _getDashBoardData() async {
//    setState(() {
//      _refreshDashBoard = true;
//    });
////    if(userType == 1){
//    final Map<String, dynamic> dashBoardData =
//        await ApiService.getDashBoardData();
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
////        totalPendingAttendancesToday =
////            dashBoardData['total_pending_attendances_today'] != null &&
////                    dashBoardData['total_pending_attendances_today']
////                            .toString() !=
////                        'n/a'
////                ? dashBoardData['total_pending_attendances_today']
////                : '0';
//
//        totalPendingAttendancesToday =
//        dashBoardData['total_present'] != null &&
//            dashBoardData['total_present']
//                .toString() !=
//                'n/a'
//            ? dashBoardData['total_present']
//            : '0';
//        totalPendingLeaveApplications =
//            dashBoardData['total_pending_leave_applications'] != null ||
//                    dashBoardData['total_pending_leave_applications'] != 'n/a'
//                ? dashBoardData['total_pending_leave_applications']
//                : '0';
//        _refreshDashBoard = false;
//      });
//    }
////    }
//  }
//
//  _getUserType() async {
//    if (widget.userType == null || widget.userType == "") {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      var type = prefs.getInt('user-type');
//      setState(() {
//        userType = type;
//      });
//    } else {
//      setState(() {
//        userType = widget.userType;
//      });
//    }
//  }
//
//  void _getAttendanceList() async {
//    if (!isPerformingRequest) {
//      setState(() => isPerformingRequest = true);
//    }
//    if (userType == 1) {
//      Map<String, dynamic> attendenceData =
//          await ApiService.getAttendanceList(filters);
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
//          await ApiService.getAttendanceList(filters);
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
//  Future<Map<String, dynamic>> _filterDialog(BuildContext context) async {
//    return showDialog<Map<String, dynamic>>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) => AttendanceFilterDialog(),
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
//  _applyAttendanceRequest(BuildContext context, var imagePath) async {
////    final flag =
////        await ApiService.getAttendanceFlag(personalDetail['employeeId']);
////    if (flag != null) {
////      setState(() {
////        currentAttendanceFlag = flag;
////      });
////    }
//    return showDialog<String>(
//        barrierDismissible: false,
//        context: context,
//        builder: (BuildContext context) => AttendenceConfirmationDialog(
//            uId: personalDetail['employeeId'],
//            userName: personalDetail['fullName']));
//  }
//
//  _linkItem(Icon icon, Color primaryColor, Color secondaryColor, String title,
//      String value, Icon clickIcon) {
//    return Container(
//        color: secondaryColor,
//        height: MediaQuery.of(context).size.height * .85 / 10,
//        width: MediaQuery.of(context).size.width,
//        margin: EdgeInsets.only(left: 20.0, right: 20.0),
//        child: Column(
//          children: <Widget>[
//            Row(
//              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Column(
//                  children: <Widget>[
//                    Container(
//                      color: primaryColor,
////                  padding: EdgeInsets.all(20.0),
//                      width: MediaQuery.of(context).size.width * 1 / 5,
//                      height: MediaQuery.of(context).size.height * .85 / 10,
//                      child: Center(child: icon),
//                    ),
//                  ],
//                ),
//                Column(
//                  mainAxisSize: MainAxisSize.max,
//                  children: <Widget>[
//                    Container(
//                      child: Text(
//                        title,
//                        style: TextStyle(fontSize: 15.0, color: Colors.white),
//                      ),
//                    ),
//                    Container(
//                      child: Text(
//                        value,
//                        style: TextStyle(
//                            fontSize: 25.0,
//                            fontWeight: FontWeight.bold,
//                            color: Colors.white),
//                      ),
//                    )
//                  ],
//                ),
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  children: <Widget>[
//                    Container(
//                      width: MediaQuery.of(context).size.width * 1 / 5,
//                      height: MediaQuery.of(context).size.height * .85 / 10,
//                      child: Center(child: clickIcon),
//                    ),
//                  ],
//                ),
//              ],
//            )
//          ],
//        ));
//  }
//
//  Widget adminDashboard() {
//    return Column(
//      children: <Widget>[
//        Column(
//          children: <Widget>[
//            _linkItem(
//                Icon(Icons.people),
//                Color(0xFF37479F),
//                Color(0xFF3C4DAC),
//                'Employees to attend',
//                empPresent.toString(),
//                Icon(
//                  Icons.radio_button_checked,
//                  color: Colors.blueGrey,
//                )),
//            SizedBox(
//              height: 5.0,
//            ),
//            _linkItem(
//                Icon(Icons.alarm_off),
//                Color(0xFF546E7A),
//                Color(0xFF5B7784),
//                'Day-off',
//                dayOff.toString(),
//                Icon(
//                  Icons.radio_button_checked,
//                  color: Colors.blueGrey,
//                )),
//            SizedBox(
//              height: 5.0,
//            ),
//            _linkItem(
//                Icon(Icons.sentiment_satisfied),
//                Color(0xFF439A46),
//                Color(0xFF48A64C),
//                'On time',
//                onTime.toString(),
//                Icon(
//                  Icons.radio_button_checked,
//                  color: Colors.blueGrey,
//                )),
//            SizedBox(
//              height: 5.0,
//            ),
//          ],
//        ),
//        Column(
//          children: <Widget>[
//            InkWell(
//              child: _linkItem(
//                  Icon(Icons.warning),
//                  Color(0xFFE08600),
//                  Color(0xFFF29000),
//                  'Late',
//                  late.toString(),
//                  Icon(
//                    Icons.launch,
//                  )),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => LateEmployeeListPage(
//                              lateEmployee: lateEmployeeList,
//                            )));
//              },
//            ),
//            SizedBox(
//              height: 5.0,
//            ),
//            InkWell(
//              child: _linkItem(
//                  Icon(Icons.directions_car),
//                  Color(0xFF008477),
//                  Color(0xFF008E81),
//                  'On-leave',
//                  onLeave.toString(),
//                  Icon(
//                    Icons.launch,
//                  )),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => OnLeaveEmployeeListPage(
//                              onLeaveEmployee: onLeaveEmployeeList,
//                            )));
//              },
//            ),
//            SizedBox(
//              height: 5.0,
//            ),
//            InkWell(
//              child: _linkItem(
//                  Icon(Icons.sentiment_dissatisfied),
//                  Color(0xFFD63B2F),
//                  Color(0xFFE84033),
//                  'Absent',
//                  absent.toString(),
//                  Icon(
//                    Icons.launch,
////                  color: Colors.blueGrey,
//                  )),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AbsentEmployeeListPage(
//                              absentEmployee: absentEmployeeList,
//                            )));
//              },
//            ),
//            SizedBox(
//              height: 5.0,
//            ),
//            InkWell(
//              child: _linkItem(
//                Icon(Icons.alarm_on),
//                Color(0xFF4B6695),
//                Color(0xFF6A99C4),
////                'Attendance requests',
//                'Present',
//                totalPendingAttendancesToday.toString(),
//                Icon(Icons.launch),
//              ),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AttendanceListPageForAdmin()));
////                builder: (context) => AttendanceListPage()));
//              },
//            ),
//            SizedBox(
//              height: 5.0,
//            ),
//            InkWell(
//              child: _linkItem(
//                Icon(Icons.flight),
//                Color(0xFFA34C40),
//                Color(0xFFC38D81),
//                'Leave requests',
//                totalPendingLeaveApplications.toString(),
//                Icon(Icons.launch),
//              ),
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => LeaveRequestListPage()));
//              },
//            ),
//            SizedBox(
//              height: 10.0,
//            ),
//          ],
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
//                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
//                  color: Theme.of(context).primaryColor,
//                  shape: BoxShape.circle,
//                ),
//                width: MediaQuery.of(context).size.width * 2 / 5,
//                height: MediaQuery.of(context).size.height * 2.3 / 10,
//                child: Center(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Center(child: Text('Give',style: TextStyle(color: Colors.white, fontSize: 20.0)),),
//                      Center(child: Text('Attendance',style: TextStyle(color: Colors.white, fontSize: 20.0)),),
//                    ],
//                  ),
//                ),
//              ),
//              onTap: () async {
//                await _applyAttendanceRequest(context, _imagePath);
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
//            DateFormat.yMMMEd()
//                .format(DateTime.parse(DateTime.now().toString(),),),style: TextStyle(fontWeight: FontWeight.bold),
//    ),
//          ),
//        ),
//
//        !refreshPersonalList
//            ? Container(
//                decoration: BoxDecoration(
//                color:Color(0xFFF3EEE0),
//                  borderRadius: new BorderRadius.only(
//                      topLeft: const Radius.circular(10.0),
//                      topRight: const Radius.circular(10.0)),
//                ),
//
//                margin: EdgeInsets.only(left: 5.0, right: 5.0),
//                padding: EdgeInsets.only(top: 5.0),
//                height: MediaQuery.of(context).size.height * 4.02 / 10,
//                child:Center(child:_personalAttendancListItemUI()) ,
//              )
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
//                                height: 30.0,
//                                color: Colors.white,
//                                child: Center(
//                                    child: Text(
//                                  'No',
//                                  style: TextStyle(
//                                      color: Theme.of(context).primaryColor),
//                                )),
//                              ),
//                              onTap: () {
//                                Navigator.of(context).pop(false);
//                              },
//                            ),
//                            InkWell(
//                              child: Container(
//                                width: 100.0,
//                                height: 30.0,
//                                color: Theme.of(context).primaryColor,
//                                child: Center(
//                                    child: Text(
//                                  'Yes',
//                                  style: TextStyle(color: Colors.white),
//                                )),
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
//              // _filterOptions(context),
//              );
//        });
//  }
//
////  static Future<String> openFileExplorer(FileType pickedFileType, String fileExt) async {
////    String selectedFilePath;
////    if (pickedFileType == FileType.IMAGE) {
////      try {
////        selectedFilePath = await FilePicker.getFilePath(
////            type: pickedFileType, fileExtension: fileExt);
////        return selectedFilePath;
////      } on PlatformException catch (e) {
////        print("Unsupported operation" + e.toString());
////      }
////    }
////    if (pickedFileType == FileType.VIDEO) {
////      try {
////        selectedFilePath = await FilePicker.getFilePath(
////            type: pickedFileType, fileExtension: fileExt);
////        return selectedFilePath;
////      } on PlatformException catch (e) {
////        print("Unsupported operation" + e.toString());
////      }
////    }
////    if (pickedFileType == FileType.CUSTOM) {
////      try {
////        selectedFilePath = await FilePicker.getFilePath(
////            type: pickedFileType, fileExtension: fileExt);
////        return selectedFilePath;
////      } on PlatformException catch (e) {
////        print("Unsupported operation" + e.toString());
////      }
////    }
////    return selectedFilePath;
////  }
//
//  String _path;
//
//   _openFileExplorer() async {
//    if (_pickingType == FileType.IMAGE) {
//      try {
//        _path = await FilePicker.getFilePath(
//            type: _pickingType, fileExtension: _extension);
//        setState(() {
//          _imagePaths = _path;
//          _fileName = _path;
//        });
//        // }
//      } on PlatformException catch (e) {
//        print("Unsupported operation" + e.toString());
//      }
//    }
//
//    if (!mounted) return;
//    print(_fileName.toString());
//  }
//
//  void _getSelectedFile() async {
//    String filePath =
//    await _openFileExplorer();
//    if (filePath != null) {
//      setState(() {
//        _fileName = filePath;
//        _imagePaths = filePath;
//        updateImage = true;
//        // _path = filePath;
//      });
//    }
//  }
//
//
//   employeeInfoDialog(BuildContext context, var data) {
//    return showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
//              contentPadding: EdgeInsets.all(25.0),
//              title: Center(child: Text('Personal information')),
//              content: SingleChildScrollView(
//                  child: Column(
//                children: <Widget>[
//                  Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisSize: MainAxisSize.max,
//                    children: <Widget>[
//                      Center(
//                        child: Container(
//                            padding: const EdgeInsets.only(left: 0.0),
//                            height: 120.0,
//                            width: 130.0,
//                            child: Material(
//                              borderRadius: BorderRadius.circular(5.0),
//                              child: data['photoAttachment'] != null &&
//                                      data['photoAttachment'] != "''"
////                                ?Text(data['photoAttachment']):Text('null')
//                                  ? Image.network(data['photoAttachment'])
//                                  : Image.asset('assets/profile.png'),
//                            )),
//                      ),
//                      Center(
//                        child: Container(
//                          padding: const EdgeInsets.only(top: 10.0),
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                data['fullName'],
//                                style: TextStyle(
//                                    fontSize: 23.0,
//                                    fontWeight: FontWeight.bold),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                      SizedBox(height: 10.0),
//                      Center(
//                        child: Container(
//                          padding: const EdgeInsets.only(top: 10.0),
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                data['designation']['value'],
//                                style: TextStyle(
//                                  fontSize: 20.0,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
////                      Center(
////                        child: InkWell(
////                          child: Text('Update image',style: TextStyle(
////                            decoration: TextDecoration.underline,
////                          ),),
////                          onTap: () {
////                            _pickingType = FileType.IMAGE;
////                            // _openFileExplorer();
////                            _extension = 'jpg|jpeg|png';
////                            _getSelectedFile();
////                          },
////                        ),
////                      ),
//                      SizedBox(height: 10.0),
//                      Center(
//                        child: InkWell(
//                          child: Text('Update image', style: TextStyle(
//                            decoration: TextDecoration.underline,
//                          ),),
//                          onTap: () {
//                            _pickingType = FileType.IMAGE;
//                            _extension = 'jpg|jpeg|png';
//                            _getSelectedFile();
//                          },
//                        ),
//                      ),
//                      SizedBox(
//                        height: 5.0,
//                      ),
//                      SizedBox(height: 10.0),
//                     updateImage ? Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        children: <Widget>[
//                          InkWell(
//                            child: Container(
//                              width: 100.0,
//                              height: 30.0,
//                              color: Theme.of(context).primaryColor,
//                              child: Center(
//                                  child: Text(
//                                'Ok',
//                                style: TextStyle(color: Colors.white),
//                              )),
//                            ),
//                            onTap: () async {
//                              Navigator.of(context).pop(false);
//                            },
//                          ),
//                          InkWell(
//                            child: Container(
//                              width: 100.0,
//                              height: 30.0,
//                              color: Theme.of(context).primaryColor,
//                              child: Center(
//                                  child: Text(
//                                    'Update',
//                                    style: TextStyle(color: Colors.white),
//                                  )),
//                            ),
//                            onTap: () async {
//                              if (_imagePaths != null) {
//                                FormData formData = new FormData.from({
//                                  "photoAttachment": new UploadFileInfo(
//                                      new File(_imagePaths), _fileName),
//                                });
//                                updateEmployeePic(formData);
//                              }
//                            },
//                          )
//                        ],
//                      ):Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        children: <Widget>[
//                          InkWell(
//                            child: Container(
//                              width: 100.0,
//                              height: 30.0,
//                              color: Theme.of(context).primaryColor,
//                              child: Center(
//                                  child: Text(
//                                    'Ok',
//                                    style: TextStyle(color: Colors.white),
//                                  )),
//                            ),
//                            onTap: () async {
//                              Navigator.of(context).pop(false);
//                            },
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                ],
//              ))
//              // _filterOptions(context),
//              );
//        });
//  }
//
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
//                            radius: 30.0,
//                            backgroundImage:
//                                NetworkImage(personalDetail['photoAttachment']),
//                            backgroundColor: Colors.transparent,
//                          )
//                        : CircleAvatar(
////                      child: Image.asset('assets/profile.png'),
//                            backgroundImage: AssetImage('assets/profile.png'),
//                            radius: 30.0,
//                            backgroundColor: Colors.transparent,
//                          ),
//                  ),
//                  onTap: () async {
////                    await employeeInfoDialog(context, personalDetail);
//
//                    showDialog(
//                        context: context,
//                        builder: (BuildContext context) => EmployeeInfoDialog(data:personalDetail)
//                        );
//
//                  },
//                ),
//              ),
//              actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.refresh),
//                  onPressed: () {
//                    userType == 1
//                        ? _getDashBoardData()
//                        : _refreshPersonalData();
//                  },
//                ),
//                PopupMenuButton<String>(
//                  onSelected: (val) async {
//                    switch (val) {
//                      case 'VIEW_ATTENDANCE_LIST':
//                        debugPrint('attendance list for employee');
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    MonthlyAttendanceListPage(id: id)));
//                        break;
//                      case 'VIEW_HOLYDAY_LIST':
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    MonthlyHolydayListPage(id: id)));
//                        break;
//                      case 'LEAVE_REQ_DIALOG':
//                        debugPrint('leave apply from dialog');
//                        showDialog<Map<String, dynamic>>(
//                          barrierDismissible: false,
//                          context: context,
//                          builder: (BuildContext context) =>
//                              LeaveApplicationDialogPage(),
//                        );
//                        break;
//                      case 'APPLIED_LEAVES':
//                        debugPrint('applied leaves');
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    PersonalLeaveRequestListPage()));
//
//                        break;
//                      case 'CHANGE_PASS':
//                        debugPrint('change password');
//                        _changePassDialog(context);
//                        break;
//                      case 'LOGOUT':
//                        debugPrint('logout');
//                        _logOutDialog(context);
//                        break;
//                      case 'UNREGISTER':
//                        debugPrint('unregister');
//                        _unRegisterDialog(context);
//                        break;
//                    }
//                  },
//                  itemBuilder: (BuildContext context) =>
//                      <PopupMenuItem<String>>[
//                    userType == 0
//                          ? PopupMenuItem<String>(
//                        value: 'VIEW_ATTENDANCE_LIST',
//                        child: Text('Monthly attendance'),
//                      )
//                          : PopupMenuItem(
//                        height: 0.0,
//                      ),
////                        userType == 0
////                            ? PopupMenuItem<String>(
////                          value: 'VIEW_HOLYDAY_LIST',
////                          child: Text('Monthly holydays'),
////                        )
////                            : PopupMenuItem(
////                          height: 0.0,
////                        ),
//                    userType == 0
//                        ? PopupMenuItem<String>(
//                            value: 'LEAVE_REQ_DIALOG',
//                            child: Text('Apply for leave'),
//                          )
//                        : PopupMenuItem(
//                            height: 0.0,
//                          ),
//                    userType == 0
//                        ? PopupMenuItem<String>(
//                            value: 'APPLIED_LEAVES',
//                            child: Text('Applied leaves'),
//                          )
//                        : PopupMenuItem(
//                            height: 0.0,
//                          ),
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
//              children: <Widget>[
//                SizedBox(height: 5.0,),
//                Container(
////                  height: MediaQuery.of(context).size.height * 1 / 10,
//                  child: companyLogo != null || cacheCompanyLogo != null
//                      ? _sizedContainer(
//                          new CachedNetworkImage(
//                            imageUrl: cacheCompanyLogo == null
//                                ? companyLogo
//                                : cacheCompanyLogo,
//                            placeholder: (context, url) =>
//                                new CircularProgressIndicator(),
//                            errorWidget: (context, url, error) =>
//                                new Icon(Icons.error),
//                            fadeOutDuration: new Duration(seconds: 1),
//                            fadeInDuration: new Duration(seconds: 3),
//                          ),
//                        )
//                      : _sizedContainer(
//                          Image.asset('assets/icons/BaniAdam-Logo_Final.png')),
//                ),
//                Container(
//                    child: personalDetail != null
//                        ? Container(
//                            child: userType == 1
//                                ? adminDashboard()
//                                : employeeDashboard(),
//                          )
//                        : Container(
//                        width: MediaQuery.of(context).size.width,
//                        child:Center(child: CircularProgressIndicator()))),
//              ],
//            ))));
//  }
//}
