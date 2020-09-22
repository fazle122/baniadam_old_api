import 'package:flutter/material.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CommonListItemWidget extends StatefulWidget {
  final List employee;
  final ScrollController scrollController;
  final bool isPerformingRequest;

  CommonListItemWidget(
      {this.employee, this.scrollController, this.isPerformingRequest});

  @override
  _CommonListItemWidgetState createState() => _CommonListItemWidgetState();
}

class _CommonListItemWidgetState extends State<CommonListItemWidget> {
  Map<String, dynamic> data;
  bool refreshData = false;
  List newEmployeeList;
  String baseCdnUrl;
  int currentPage;
  int lastPage;

  @override
  void initState() {
    newEmployeeList = widget.employee;
    getCDN();
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


  Widget _listBody(BuildContext context) {
    if (newEmployeeList.length > 0)
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 4.5/5,
        child: ListView.builder(
          itemCount: newEmployeeList.length+1,
          itemBuilder: (BuildContext context, int index) {
            return _makeListItemUI(index, context);
          },
          controller: widget.scrollController,
        ),
      );
    if (refreshData)
      return Container(
          padding:EdgeInsets.only(top:MediaQuery.of(context).size.height * 1/2),
          child: Center(
            child: CircularProgressIndicator(),
          )
      );
    return Container(
        padding: EdgeInsets.only(bottom: 100),
        height: MediaQuery.of(context).size.height,
        child:_sizedContainer(Image.asset('assets/absent-today.png',width: 300.0,height: 250.0,))
    );
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
    return SingleChildScrollView(child: _listBody(context));
  }

  _makeListItemUI(int index, BuildContext context) {
    if (index >= newEmployeeList.length) {
      return null;
    }
    return newEmployeeList.elementAt(index)['employee'] != null ?
    _listItemUI(
        listData: newEmployeeList.elementAt(index)['employee'],
        context: context,
        index: index)
        :
    _listItemUI(
        listData: newEmployeeList.elementAt(index),
        context: context,
        index: index)
    ;
  }


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
                            child: listData['photoAttachment'] == null ||
                                listData['photoAttachment'] == ""
                                ? Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40.0,
                                ))
//                                : Image.network('http://testcdn.ideaxen.net/test/' + listData['photoAttachment']))),
                                : Image.network(baseCdnUrl + listData['photoAttachment']))
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 2.5/5,
                              child: Text(
                                listData['fullName'],
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              spacing: 0.0,
                              runSpacing: 5.0,
                              children: <Widget>[
                                Text(
                                  listData['department']['value'],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                Text(
                                  listData['designation']['value'],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.sentiment_dissatisfied),
          ),
        ],
      ),
    );
  }
}