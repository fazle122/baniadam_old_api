import 'package:baniadam/widgets/common_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnLeaveEmployeeListPage extends StatefulWidget {
  final onLeaveEmployee;

  OnLeaveEmployeeListPage({
    this.onLeaveEmployee,
    Key key,
  }) : super(key: key);

  @override
  _OnLeaveEmployeeListPageState createState() =>
      _OnLeaveEmployeeListPageState();
}

class _OnLeaveEmployeeListPageState extends BaseState<OnLeaveEmployeeListPage> {
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  List attendenceList;
  List newAttendenceList;
  Map<String, dynamic> filters;
  int currentPage;
  int lastPage;
  int nextPage;

  bool _refreshList = false;

  @override
  void initState() {
    filters = new Map();
    attendenceList = [];
    newAttendenceList = [];
    _getAttendanceList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreAttendanceList();
      }
    });

    super.initState();
  }

  _refreshData() {
    attendenceList = [];
    newAttendenceList = [];
    _getAttendanceList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreAttendanceList();
      }
    });
  }

  void _getAttendanceList() async {
    setState(() {
      _refreshList = true;
    });
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
    }

    Map<String, dynamic> attendenceData = await ApiService.getDashBoardData();
    if (attendenceData != null) {
      _refreshList = false;
      print(attendenceData['data']);
      setState(() {
        currentPage = attendenceData['current_page'];
        lastPage = attendenceData['last_page'];
        attendenceList.addAll(attendenceData['onleave']['data']);
        print(attendenceList.length.toString());
      });
    }
  }

  void _getMoreAttendanceList() async {
    newAttendenceList.clear();

    if (currentPage < lastPage) {
      setState(() {
        currentPage += 1;
        filters['page'] = currentPage;
      });
      final Map<String, dynamic> attendenceData =
          await ApiService.getDashBoardData();
      if (attendenceData != null) {
        print(attendenceData['data']);
        setState(() {
          newAttendenceList.addAll(attendenceData['onleave']['data']);
          attendenceList.addAll(newAttendenceList);
          print(attendenceList.length.toString());
          print(newAttendenceList);
        });
      }
    } else if (currentPage == lastPage) {}
  }

  _onLeaveListItemUI() {
//    if (attendenceList.isNotEmpty)
    return OnLeaveListItemWidget(
      onLeaveEmp: widget.onLeaveEmployee,
      scrollController: _scrollController,
      isPerformingRequest: isPerformingRequest,
      filters: filters,
    );
  }

//  _onLeaveListItemUI() {
////    if (attendenceList.isNotEmpty)
//    return CommonListItemWidget(
//      employee: widget.onLeaveEmployee,
//      scrollController: _scrollController,
//      isPerformingRequest: isPerformingRequest,
//    );
//  }

  Widget listWidget() {
    return !_refreshList
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: _onLeaveListItemUI(),
              )
            ],
          )
        : Container(
        padding:EdgeInsets.only(top:MediaQuery.of(context).size.height * 1/2),
        child:Center(
          child: CircularProgressIndicator(),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On leave today'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refreshData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
            color: Color(0xFFF7F7F7),
            child: Center(child: listWidget()),
          )),
    );
  }
}

class OnLeaveListItemWidget extends StatefulWidget {
  final List onLeaveEmp;
  final ScrollController scrollController;
  final bool isPerformingRequest;
  final Map<String, dynamic> filters;

  OnLeaveListItemWidget(
      {this.onLeaveEmp,
      this.scrollController,
      this.isPerformingRequest,
      this.filters});

  @override
  _OnLeaveListItemWidgetState createState() => _OnLeaveListItemWidgetState();
}

class _OnLeaveListItemWidgetState extends State<OnLeaveListItemWidget> {
  Map<String, dynamic> data;
  bool refreshData = false;
  List newAttendenceList;
  String baseCdnUrl;
  int currentPage;
  int lastPage;

  @override
  void initState() {
    getCDN();
    newAttendenceList = widget.onLeaveEmp;
    data = Map();
    super.initState();
  }

  getCDN()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var portalID = prefs.getString('curr-cid');
    if(portalID != null){
      setState(() {
        baseCdnUrl = ApiService.CDN_URl+"$portalID/";
      });

    }
  }

  void _getRefreshData() async {
    setState(() {
      refreshData = true;
    });
    newAttendenceList = [];
    final Map<String, dynamic> attendenceData =
        await ApiService.getAttendanceList(widget.filters);
    if (attendenceData != null) {
      refreshData = false;
      newAttendenceList.addAll(attendenceData['data']);
      print(newAttendenceList);
    }
  }

  Widget _listBody(BuildContext context) {
    if (newAttendenceList.length > 0)
      return Container(
        height: MediaQuery.of(context).size.height * 4.2 / 5,
        width: MediaQuery.of(context).size.width * 4.5 / 5,
        child: ListView.builder(
          itemCount: newAttendenceList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: Column(
                  children: <Widget>[
                    _makeListItemUI(index, context),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ));
          },
          controller: widget.scrollController,
        ),
      );
    if (refreshData)
      return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *1/2),
      child: CircularProgressIndicator(),
      );
  return Container(
    padding: EdgeInsets.only(bottom: 100),
        height: MediaQuery.of(context).size.height,
    child:_sizedContainer(Image.asset('assets/on-leave-today.png',width: 300.0,height: 250.0,))
  );

//    return Container(
//        child: Column(
//      children: <Widget>[
//        newAttendenceList.length > 0
//            ? Container(
//                child: !refreshData
//                    ? Container(
//                        padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
//                        height: MediaQuery.of(context).size.height * 4.2 / 5,
//                        child: ListView.builder(
//                          itemCount: newAttendenceList.length,
//                          itemBuilder: (BuildContext context, int index) {
//                            return _makeListItemUI(index, context);
//                          },
//                          controller: widget.scrollController,
//                        ),
//                      )
//                    : Container(
//                        margin: EdgeInsets.only(top: 250.0),
//                        child: Center(
//                          child: CircularProgressIndicator(),
//                        )))
//            : Container(
////                margin: EdgeInsets.only(top: 250.0),
//                child: Center(
//                    child: Text(
//                  'No data',
//                  style: TextStyle(fontSize: 20.0),
//                ))),
//      ],
//    ));
  }
  Widget _sizedContainer(Widget child) {
    return Container(
        child:
        SizedBox(
          child: new Center(
            child: child,
          ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return _listBody(context);
  }

  _makeListItemUI(int index, BuildContext context) {
    if (index >= newAttendenceList.length) {
      return null;
    }
    return newAttendenceList.length > 0
//    return newAttendenceList.isNotEmpty
        ? _listItemUI(
            listData: newAttendenceList.elementAt(index),
            context: context,
            index: index)
        : Center(
            child: Text('no data'),
          );
  }

  DateTime date;

  Widget _listItemUI(
      {Map<String, dynamic> listData, BuildContext context, index}) {
    return Card(
      color:Colors.white,
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                        ),
                        padding: const EdgeInsets.only(left: 0.0),
                        height: 60.0,
                        width: 50.0,
                        child: baseCdnUrl == null?
                        Material(
                            borderRadius: BorderRadius.circular(5.0),
                            child:Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40.0,
                                )))
                            :
                        Material(
                            borderRadius: BorderRadius.circular(5.0),
                            child: listData['employee']['photoAttachment'] ==
                                null ||
                                listData['employee']['photoAttachment'] ==
                                    ""
                                ? Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40.0,
                                ))
//                                : Image.network('http://testcdn.ideaxen.net/test/'+listData['employee']['photoAttachment']))),
                                : Image.network(baseCdnUrl+listData['employee']['photoAttachment']))
//                                  : Image.network(imageUrl))
                    ),
//                        child: Material(
//                            borderRadius: BorderRadius.circular(5.0),
//                            child: listData['employee']['photoAttachment'] ==
//                                        null ||
//                                    listData['employee']['photoAttachment'] ==
//                                        ""
//                                ? Center(
//                                    child: Icon(
//                                    Icons.person,
//                                    size: 40.0,
//                                  ))
////                                : Image.network('http://testcdn.ideaxen.net/test/'+listData['employee']['photoAttachment']))),
//                                  : Image.network(baseCdnUrl+listData['employee']['photoAttachment']))),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 2.5/5,
                              child: Text(
                                listData['employee']['fullName'],
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
//                            Wrap(
//                              direction: Axis.vertical,
//                              spacing: 0.0,
//                              runSpacing: 5.0,
//                              children: <Widget>[
//                                Text(
//                                  listData['employee']['fullName'],
//                                  style: TextStyle(fontSize: 15.0),
//                                ),
//                              ],
//                            ),
                            Wrap(
                              direction: Axis.vertical,
                              spacing: 0.0,
                              runSpacing: 5.0,
                              children: <Widget>[
                                Text(
                                  listData['employee']['department']['value'],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                Text(
                                  listData['employee']['designation']['value'],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),

                          ],
                        )),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.directions_car),
//            subtitle: Text(listData['department']['value']+ ' , '+listData['designation']['value']),
          ),
        ],
      ),
    );
  }
}
