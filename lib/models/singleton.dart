import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:property_broker/models/userdatamodel.dart';

class User {
  // singleton
  static final User _singleton = User._internal();
  factory User() => _singleton;
  User._internal();
  static User get userData => _singleton;

  String mobile;
  var mobileVerify;
  String token;
  UserResult userResult;
  UserDataModel userDataModel;
  var lang = "en";
  var notificationToken;
  var navigatorKey;
}
