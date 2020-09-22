import 'package:flutter/material.dart';
import 'employee.dart';
import 'leaveType.dart';
import 'branch.dart';

class Leave {
  String id;
  Employee employee;
  LeaveType leaveType;
  String from;
  String to;
  String status;
  String reason;
  String declineReason;
  Branch branch;

  Leave({
    this.id,
    this.employee,
    this.leaveType,
    this.from,
    this.to,
    this.status,
    this.reason,
    this.declineReason,
    this.branch,
  });

  Leave.fromJson(Map json)
      : id = json['id'],
        employee = json['employee'],
        leaveType = json['leaveType'],
        from = json['from'],
        to = json['to'],
        status = json['status'],
        reason = json['reason'],
        declineReason = json["declineReason"],
        branch = json["branch"];

//  public String getId() {
//    return id;
//  }
//
//  public void setId(String id) {
//    this.id = id;
//  }
//
//  public Employee getEmployee() {
//    return employee;
//  }
//
//  public void setEmployee(Employee employee) {
//    this.employee = employee;
//  }
//
//  public LeaveType getLeaveType() {
//    return leaveType;
//  }
//
//  public void setLeaveType(LeaveType leaveType) {
//    this.leaveType = leaveType;
//  }
//
//  public String getFrom() {
//    return from;
//  }
//
//  public void setFrom(String from) {
//    this.from = from;
//  }
//
//  public String getTo() {
//    return to;
//  }
//
//  public void setTo(String to) {
//    this.to = to;
//  }
//
//  public String getStatus() {
//    return status;
//  }
//
//  public void setStatus(String status) {
//    this.status = status;
//  }
//
//  public String getReason() {
//    return reason;
//  }
//
//  public void setReason(String reason) {
//    this.reason = reason;
//  }
//
//  public String getDeclineReason() {
//    return declineReason;
//  }
//
//  public void setDeclineReason(String declineReason) {
//    this.declineReason = declineReason;
//  }
//
//  public Branch getBranch() {
//    return branch;
//  }
//
//  public void setBranch(Branch branch) {
//    this.branch = branch;
//  }
//
//  @Override
//  public String toString() {
//    return "Leave{" +
//        "id='" + id + '\'' +
//        ", employee=" + employee +
//        ", leaveType=" + leaveType +
//        ", from='" + from + '\'' +
//        ", to='" + to + '\'' +
//        ", status='" + status + '\'' +
//        ", reason='" + reason + '\'' +
//        ", declineReason='" + declineReason + '\'' +
//        ", branch=" + branch +
//        '}';
//  }
}
