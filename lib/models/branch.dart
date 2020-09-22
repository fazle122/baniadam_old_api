
class Branch{
  String id;
  String code;
  String branch;



  Branch({
    this.id,
    this.code,
    this.branch,
  });

//  protected Branch(Parcel in) {
//  id = in.readString();
//  code = in.readString();
//  branch = in.readString();
//  }
//
//  @Override
//  public void writeToParcel(Parcel dest, int flags) {
//    dest.writeString(id);
//    dest.writeString(code);
//    dest.writeString(branch);
//  }
//
//  @Override
//  public int describeContents() {
//    return 0;
//  }
//
//  public static final Creator<Branch> CREATOR = new Creator<Branch>() {
//  @Override
//  public Branch createFromParcel(Parcel in) {
//  return new Branch(in);
//  }
//
//  @Override
//  public Branch[] newArray(int size) {
//    return new Branch[size];
//  }
//};
//
//public String getId() {
//  return id;
//}
//
//public void setId(String id) {
//  this.id = id;
//}
//
//public String getCode() {
//  return code;
//}
//
//public void setCode(String code) {
//  this.code = code;
//}
//
//public String getBranch() {
//  return branch;
//}
//
//public void setBranch(String branch) {
//  this.branch = branch;
//}
}
