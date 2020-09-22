import 'package:flutter/material.dart';

class Employee{
  String id;
  String employeeId;
  String fullName;
  String email;
  String contactNumber;
//  Designation designation;
//  Department department;
//  Branch branch;
  String photoAttachment;


  Employee({this.id, this.employeeId, this.fullName,this.email,this.contactNumber,this.photoAttachment});

  Employee.fromJson(Map json)
      : id = json['id'],
        employeeId = json['employeeId'],
        fullName = json['fullName'],
        email = json['email'],
        contactNumber = json['contactNumber'],
        photoAttachment = json['photoAttachment'];


  Map toJson() {
    return {
      'id': id,
      'employeeId':employeeId,
      'fullName': fullName,
      'email': email,
      'contactNumber': contactNumber,
      'photoAttachment':photoAttachment,
    };
  }

}
