import 'package:flutter/material.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/models/userdatamodel.dart';

class ProfileNotifier extends ChangeNotifier {
  UserDataModel userDataModel = UserDataModel();
  static ValueNotifier<UserDataModel> profileNotifiers =
      ValueNotifier<UserDataModel>(null);
  void setProfile(context) {
    // address = value;
    BaseHelper().getUserProfile(profileNotifiers, context).then((value) {
      print("sadsadsad: $value");
      userDataModel = value;
      profileNotifiers.value = userDataModel;
      // User.userData.userDataModel = userDataModel;
      print("profile response: ${profileNotifiers.value.result.address}");
    });
    notifyListeners();
  }
}

final profileNotifier = ProfileNotifier();
