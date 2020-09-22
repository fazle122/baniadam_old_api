import 'leave.dart';

class LeavesList {

  String currentPage;
  List<Leave> data;
  String prevPageUrl;
  String perPage;
  String nextPageUrl;
  String lastPage;
  String total;


  LeavesList({
    this.currentPage,
    this.data,
    this.prevPageUrl,
    this.perPage,
    this.nextPageUrl,
    this.lastPage,
    this.total,
  });


  LeavesList.fromJson(Map json)
      :
        currentPage= json['current_page'],
        data = json['data'],
        prevPageUrl = json['prevPageUrl'],
        perPage = json['perPage'],
        nextPageUrl = json['nextPageUrl'],
        lastPage = json['lastPage'],
        total = json['total'];

}
