import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:bot_toast/bot_toast.dart';

import 'package:http/http.dart' as http;

import 'package:another_flushbar/flushbar.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/screen.dart/propertyDetail.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';

// ignore: camel_case_types
class Firebase_Notification {
  final BuildContext context;

  // var _navigationService = locator<NavigationService>();
  Firebase_Notification(this.context);
  FirebaseMessaging _firebaseMessaging;

  void setupfirebase(_navigatorKey, navigatorKey) {
    // User.userData.navigatorKey = navigatorKey;
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners(_navigatorKey, navigatorKey);
    firebaseCloudMessagingToken();
  }

  void firebaseCloudMessagingToken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    //SharedPreferences localStorage = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((token) {
      print("Mobile Token is: $token");
      User.userData.notificationToken = token;
      //print(User.userData.notificationToken);
      //localStorage.setString('notificationToken', token);
    }).catchError((onError) {
      print(onError);
    });
  }

  void _navigateScreen(title, data) {
    print(data);
  }

  // ignore: non_constant_identifier_names
  void firebaseCloudMessaging_Listeners(var _navigatorKey, var navigatorKey) {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      // FlutterBeep.playSysSound(41);
      // var response = (message['data']['data']);
      // var res = json.decode(response);
      // var response = (message['data']['data']);
      // var res = json.decode(response);
      // NotificationModel notificationModel = NotificationModel();
      // notificationModel = NotificationModel.fromLinkedHashMap(res);
      // print("${notificationModel.result.name}");
      print("${message['notification']['body']}");
      Flushbar(
        title: "${message['notification']['title']}",
        message: "${message['notification']['body']}",
        onTap: (value) {
          print("property id: ${message['data']['property_id']}");
          var propertyId = "${message['data']['property_id']}";
          User.userData.navigatorKey.currentState.pop(context);
          User.userData.navigatorKey.currentState.push(MaterialPageRoute(
              builder: (_) => PropertyDetail(
                    id: propertyId,
                  )));
        },
        // onTap: (value) {
        //   User.userData.productResult = notificationModel.result;
        //   User.userData.productImages.clear();
        //   User.userData.valueNames.clear();
        //   User.userData.values.clear();

        //   User.userData.productId = notificationModel.result.id;
        //   var valueName = notificationModel.result.detail;
        //   var val = valueName.toString().split(",");
        //   // print("my valuessss:  $val");
        //   User.userData.valueNames = val;
        //   print("my valuessss:  ${User.userData.valueNames}");
        //   print("imagess::::: ${notificationModel.result.images}");
        //   // if (notificationModel.result.images == null) {
        //   // } else {
        //   //   for (int i = 0; i < notificationModel.result.images.length; i++) {
        //   //     if (notificationModel.result.images[i].imageType == "product") {
        //   //       User.userData.productImages.add(
        //   //           "${API.API_URL}${notificationModel.result.images[i].imagePath.normal}");
        //   //     } else {}
        //   //   }
        //   // }
        //   print("imagessssss: ${notificationModel.result}");
        //   if (notificationModel.result.images == null) {
        //   } else {
        //     for (int i = 0; i < notificationModel.result.images.length; i++) {
        //       if (notificationModel.result.images[i].imageType == "product" &&
        //           notificationModel.result.images[i].format != "mp4") {
        //         User.userData.productImages.add(
        //             "${API.API_URL}${notificationModel.result.images[i].imagePath.normal}");
        //       } else if (notificationModel.result.images[i].format == "mp4") {
        //         User.userData.videobase64 =
        //             notificationModel.result.images[i].imagePath.original;
        //         print(User.userData.videobase64);
        //       }
        //     }
        //   }
        //   User.userData.productResult = notificationModel.result;
        //   if (message['notification']['body'].toString().contains("win")) {
        //     User.userData.navigatorKey.currentState
        //         .push(MaterialPageRoute(builder: (_) => Purchase()));
        //   } else {
        //     User.userData.navigatorKey.currentState.push(MaterialPageRoute(
        //         builder: (_) => ProductDetail(
        //               screen: 1,
        //             )));
        //   }
        // },
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        flushbarPosition: FlushbarPosition.TOP,
        duration: Duration(seconds: 8),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
      // _navigateScreen("${message['notification']['body']}", notificationModel);
      // constValues().toast("${message['notification']['body']}", context);
    }, onResume: (Map<String, dynamic> message) async {
      //_navigateToItemDetail(message);p;
      var propertyId = "${message['data']['property_id']}";
      Future.delayed(Duration(seconds: 1), () {
        User.userData.navigatorKey.currentState.push(MaterialPageRoute(
            builder: (_) => PropertyDetail(
                  id: propertyId,
                )));
      });
      print('on Resume $message');
      print("property id: ${message['data']['property_id']}");
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      var propertyId = "${message['data']['property_id']}";
      Future.delayed(Duration(seconds: 1), () {
        User.userData.navigatorKey.currentState.push(MaterialPageRoute(
            builder: (_) => PropertyDetail(
                  id: propertyId,
                )));
      });
    });
  }

  // void _navigateToItemDetail(Map<String, dynamic> message) {
  //   final Item item = _itemForMessage(message);
  //   // Clear away dialogs
  //   Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
  //   if (!item.route.isCurrent) {
  //     Navigator.push(context, item.route);
  //   }
  // }

  navigationAfterNotification(message, navigatorKey) {
    //  NotificationModel notificationModel = NotificationModel();
    // print('on Message $message');
    // print('First ride complete message');
    // String titl = (message['data']['title']);
    // print('title is: $titl');
  }

  void updateDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
              width: MediaQuery.of(context).size.width * .7,
              height: MediaQuery.of(context).size.height * .32,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          width: MediaQuery.of(context).size.width * .7,
                          height: MediaQuery.of(context).size.height * .25,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .06,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "abcd",
                                    style: headingStyle.copyWith(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ))),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .2,
                      height: MediaQuery.of(context).size.height * .1,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor),
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.ban,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }
}
