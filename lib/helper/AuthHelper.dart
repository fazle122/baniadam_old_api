import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

//import '../models/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baniadam/app_constant.dart';

typedef void LocaleChangeCallback(Locale locale);

class AuthHelper {
  static SharedPreferences prefs;
  static String userToken;
//  static Employee currUser;

  static initApp() async {
    prefs = await SharedPreferences.getInstance();
    await getLoginUser();

  }

//  static setLoginUser(Employee user) async {
//    AuthHelper.currUser = user;
//    if(user != null) {
//      await prefs.setString('curr-user', jsonEncode(user.toJson()));
//    }else{
//      prefs.remove('curr-user');
//    }
//  }

//  static setLoginUser(String userToken,int type) async {
//    if(userToken != null) {
//      prefs = await SharedPreferences.getInstance();
//      prefs.setString('curr-user', userToken);
//      prefs.setInt('user-type', type);
//    }
//    else{
//      prefs.remove('curr-user');
//    }
//  }

  static setLoginUser(String userToken,String userType,String userRole) async {
    if(userToken != null) {
      prefs = await SharedPreferences.getInstance();
      prefs.setString('curr-user', userToken);
      prefs.setString('user-type', userType);
      prefs.setString('user-role', userRole);
    }
    else{
      prefs.remove('curr-user');
    }
  }

  static setCompanyId(String cID) async {
    if(cID != null) {
      prefs = await SharedPreferences.getInstance();
      prefs.setString('curr-cid', cID);
    }
    else{
      prefs.remove('curr-cid');
    }
  }

  static getLoginUser() async{
    prefs = await SharedPreferences.getInstance();
    userToken = await prefs.getString('curr-user');
//    print(userToken);
//    String jsonStr = prefs.getString('curr-user');
//    currUser = Employee.fromJson(jsonDecode(jsonStr));
  }
}