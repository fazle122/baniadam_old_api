

class LeaveType {

  String id;
  String value;


  LeaveType({
    this.id,
    this.value,
  });

//  public String getId() {
//    return id;
//  }
//
//  public void setId(String id) {
//    this.id = id;
//  }
//
//  public String getValue() {
//    return value;
//  }
//
//  public void setValue(String value) {
//    this.value = value;
//  }
//
//  @Override
//  public String toString() {
//    return "LeaveType{" +
//        "id='" + id + '\'' +
//        ", value='" + value + '\'' +
//        '}';
//  }
//
//  private LeaveType(Parcel in) {
//  id = in.readString();
//  value = in.readString();
//  }
//
//  @Override
//  public void writeToParcel(Parcel dest, int flags) {
//    dest.writeString(id);
//    dest.writeString(value);
//  }
//
//  @Override
//  public int describeContents() {
//    return 0;
//  }
//
//  public static final Creator<LeaveType> CREATOR = new Creator<LeaveType>() {
//  @Override
//  public LeaveType createFromParcel(Parcel in) {
//  return new LeaveType(in);
//  }
//
//  @Override
//  public LeaveType[] newArray(int size) {
//    return new LeaveType[size];
//  }
//}
}
