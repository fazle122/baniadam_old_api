import 'package:flutter/material.dart';
import '../../data_provider/api_service.dart';
import '../../models/leaveList.dart';
import '../../widgets/leave_approval_dialog.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:intl/intl.dart';



class LeaveRequestDetailPage extends StatefulWidget {
  final int id;
  final String payload;
  LeaveRequestDetailPage({
    this.payload,
    this.id,
    Key key,
  }) : super(key: key);

  @override
  _LeaveRequestDetailPageState createState() => _LeaveRequestDetailPageState();
}

class _LeaveRequestDetailPageState extends BaseState<LeaveRequestDetailPage> {
  LeavesList leaveList;
  List leaveListItem = [];
  String leave;
  bool isPerformingRequest = false;


  Map<String, dynamic> personalLeaveDetail;

  @override
  void initState() {
    super.initState();
    _getLeaveDetail();

  }

  Future<List> _approveLeave(BuildContext context, id,approveType) async {
    return await showDialog<List>(
      context: context,
      builder: (BuildContext context) =>
          LeaveApprovalDialog(id: id,type: approveType),
    );
  }

  void _getLeaveDetail() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
    }
    final Map<String, dynamic> detailData = await ApiService.getLeave(widget.id);
//    LeavesList newLeaveList = await ApiService.getLeaves();
//    debugPrint(detailData['employee'].toString());
//    debugPrint(detailData['leave_type'].toString());
    isPerformingRequest = false;
    if (detailData != null) {
      setState(() {
        personalLeaveDetail = detailData;

      });
    }
  }

  _listItem(String title,String value){
    return  Container(
        decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
//          padding: const EdgeInsets.only(top:10.0),
        height: 25.0,
        width: MediaQuery.of(context).size.width * 4.7/5,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 1.5/5,
                color: Theme.of(context).backgroundColor,
                child: Center(child:Text(title,style: TextStyle(fontSize: 12.0),)),
              ),
              SizedBox(width: 20.0,),
              Container(
                width: MediaQuery.of(context).size.width * 2.5/5,
                child: Text(value,style: TextStyle(fontSize: 12.0),),
              ),
            ],
          ),
        )
    );
  }

  _listItem2(String title,String value){
    return  Container(
        decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
//          padding: const EdgeInsets.only(top:10.0),
        height: 40.0,
        width: MediaQuery.of(context).size.width * 4.7/5,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 1.5/5,
                color: Theme.of(context).backgroundColor,
                child: Center(child:Text(title,style: TextStyle(fontSize: 12.0),)),
              ),
              SizedBox(width: 20.0,),
              Container(
                width: MediaQuery.of(context).size.width * 2.5/5,
                child: Text(value,style: TextStyle(fontSize: 12.0),),
              ),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BaniAdam HR'),
      ),
      body: personalLeaveDetail != null ?
      Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(top:10.0),
              height: MediaQuery.of(context).size.height * .8/10,
              width: MediaQuery.of(context).size.width * 4.5/5,
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: Text('Request detail',style: Theme.of(context).textTheme.title,),
                ),)
          ),
          SizedBox(height: 10.0,),
          Text('Request',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
          SizedBox(height: 5.0,),
          _listItem('Leave type', personalLeaveDetail['leave_type']['value']),
          SizedBox(height: 5.0,),
          _listItem('From', personalLeaveDetail['from']),
          SizedBox(height: 5.0,),
          _listItem('To', personalLeaveDetail['to']),
          SizedBox(height: 5.0,),
          _listItem('Applied for', personalLeaveDetail['totalDays'].toString()),
          SizedBox(height: 5.0,),
          _listItem('Applied on', DateFormat.yMMMd().format(
              DateTime.parse(personalLeaveDetail['created_at']))),
          SizedBox(height: 5.0,),
          _listItem2('Leave reason', personalLeaveDetail['reason']),




          SizedBox(height: 10.0,),
          Center(child:Text('Employee',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),),
          SizedBox(height: 5.0,),
          _listItem('Name', personalLeaveDetail['employee']['fullName']),
          SizedBox(height: 5.0,),
          _listItem('ID', personalLeaveDetail['id'].toString()),
          SizedBox(height: 5.0,),
          _listItem('Branch', personalLeaveDetail['branch']['branch']),
          SizedBox(height: 5.0,),
          _listItem('Department', personalLeaveDetail['employee']['department']['value']),
          SizedBox(height: 5.0,),
          _listItem('Designation', personalLeaveDetail['employee']['designation']['value']),

          SizedBox(height: 20.0,),

          personalLeaveDetail['status'] == "Pending"
              ? Container(
//            padding: const EdgeInsets.only(right: 20.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: 100.0,
                    height: 30.0,
                    color: Theme.of(context).buttonColor,
                    child: Center(
                        child: Text(
                          'DECLINE',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  onTap: () async{
                    List data = await _approveLeave(
                        context,widget.id, 'DECLINED');
//                    if (data != null) {
//                      newLeaveItems = [];
//                      setState(() {
//                        newLeaveItems.addAll(data);
//                      });
//                    }
////                    print(personalLeaveDetail['id'].toString());
////                    showDialog(
//////                        barrierDismissible: false,
////                      context: context,
////                      builder: (BuildContext context) =>
////                          LeaveDeclinationDialog(id: personalLeaveDetail['id']),
////                    );
                  },
                ),
                SizedBox(width: 10.0),
                InkWell(
                  child: Container(
                    width: 100.0,
                    height: 30.0,
                    color: Theme.of(context).buttonColor,
                    child: Center(
                        child: Text(
                          'APPROVE',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  onTap: () async{


                      List data = await _approveLeave(
                      context, widget.id, 'APPROVED');
//                      if (data != null) {
//                      newLeaveItems = [];
//                      setState(() {
//                      newLeaveItems.addAll(data);
//                      });
//                      }
//
//
////                    print(personalLeaveDetail['id'].toString());
////                    showDialog(
//////                        barrierDismissible: false,
////                      context: context,
////                      builder: (BuildContext context) =>
////                          LeaveApprovalDialog(id: personalLeaveDetail['id']),
////                    );
                  },
                ),
              ],
            ),
          )
              : SizedBox(
            width: 0.0,
            height: 0.0,
          ),
        ],


      )):Center(child:CircularProgressIndicator()),
    );
  }

  Widget leaveDetailDataWidget() {
    if (leaveListItem.isNotEmpty) //has data & performing/not performing
      return LeaveItemListWidget(
        leaveItems: leaveListItem,
        isPerformingRequest: isPerformingRequest,
      );
    if (isPerformingRequest)
      return Center(
        child: CircularProgressIndicator(),
      );

    return Center(
      child: Text('no list item'),
    );
  }


}

class LeaveItemListWidget extends StatelessWidget {
  final List leaveItems;
  final bool isPerformingRequest;

  LeaveItemListWidget(
      {this.leaveItems, this.isPerformingRequest});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: leaveItems.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == leaveItems.length) {
          return _buildProgressIndicator();
        } else {
          return _makeListItemUI(index, context);
        }
      },
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  _makeListItemUI(int index, BuildContext context) {
    if (index >= leaveItems.length) {
      return null;
    }
    return _dMaterialItemUI(
        leaves: leaveItems.elementAt(index), context: context);
  }

  Widget _dMaterialItemUI({Map<String, dynamic> leaves, BuildContext context}) {
    return Card(
      elevation: 8.0,
    );
  }
}
