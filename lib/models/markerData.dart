



class MarkerData{
  int id;
  String activityType;
  String activityAt;
  String speed;
  String latitude;
  String longitude;
  String heading;
  String isMoving;

  MarkerData(this.id,this.activityType, this.activityAt, this.speed,this.latitude,this.longitude,this.heading,this.isMoving);

  Map toJson() {
    return {
      'id': id,
      'activity_type': activityType,
      'activity_at_raw': activityAt,
      'speed': speed,
      'latitude':latitude,
      'longitude':longitude,
      'heading':heading,
      'is_moving':isMoving
    };
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["activity_type"] = activityType;
    map["activity_at_raw"] = activityAt;
    map["speed"] = speed;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["heading"] = heading;
    map['is_moving'] = isMoving;

    return map;
  }
}