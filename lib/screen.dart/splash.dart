import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_broker/screen.dart/loginscreen.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';

class Splash extends StatefulWidget {
  var navigatorKey;
  Splash({this.navigatorKey});
  @override
  _Splash createState() => new _Splash();
}

class _Splash extends State<Splash> with SingleTickerProviderStateMixin {
  var token, lat, long;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _animationController;
  double currentValue;
  Animation curveAnimation;

  startTime() async {
    var duration = new Duration(seconds: 3);
    return Timer(duration, navigationpage);
  }

  void navigationpage() {
    // AppRoutes.replace(context, Languages());
  }

  // getsharedprefdata() async {
  //   await SharedPreferences.getInstance().then((onValue) {
  //     setState(() {
  //       token = (onValue.getString("token") ?? '');
  //       User.userData.token = token;
  //       User.userData.address = (onValue.getString("address") ?? "");
  //       lat = (onValue.getDouble("lat") ?? 0.0);
  //       long = (onValue.getDouble("long") ?? 0.0);
  //       print("shared prefs lat: $lat shared pref long: $long");
  //       lat == 0.0
  //           ? User.userData.homeLat = 25.2854
  //           : User.userData.homeLat = lat;
  //       long == 0.0
  //           ? User.userData.homeLong = 51.531000000000006
  //           : User.userData.homeLong = long;

  //       //   User.userData.lang = (onValue.getString("language") ?? '');
  //     });
  //     if (token == null || token.toString().isEmpty) {
  //       startTime();
  //     } else {
  //       getProfile();
  //     }
  //   });
  // }

  // getProfile() {
  //   APIHelper()
  //       .getUserprofile("${API.API_URL}${API.getUserProfile}", token, context)
  //       .then((value) {
  //     setState(() {
  //       print("values: $value");
  //       if (value['error'] == false) {
  //         setState(() {
  //           userDataModel = UserDataModel.fromJson(value['data']);
  //           User.userData.userDetailModel = userDataModel.result;
  //         });
  //         print("my token " + User.userData.token);
  //         // AppRoutes.push(context, ());
  //         // AppRoutes.makeFirst(context, HomePage1());
  //         AppRoutes.makeFirst(context, Dashboard());
  //       } else {
  //         startTime();
  //       }
  //     });
  //   }).catchError((onError) {
  //     constValues().toast("$onError", context);
  //     AppRoutes.replace(context, Languages());
  //   });
  // }

  _splashdelay() async {
    _animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    curveAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticInOut,
    );
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _animationController.dispose();
      }
    });
    _animationController.forward();
  }

  // getcurrentVersion() async {
  //   // SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   try {
  //     await GetVersion.projectVersion.then((value) {
  //       if (value != null) {
  //         // localStorage.setString('currentVersion', value);
  //         User.userData.currentVersion = value;
  //         print(value);
  //       }
  //     });
  //     //  print("current version||: ${User.userData.currentVersion}");
  //   } on PlatformException {
  //     User.userData.currentVersion = null;
  //   }
  // }

  // void firebaseCloudMessagingToken() async {
  //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //   //SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   _firebaseMessaging.getToken().then((token) {
  //     print("Mobile Token is: $token");
  //     setState(() {
  //       print("tokennnnn; $token");

  //       User.userData.notificationToken = token;
  //     });
  //     //print(User.userData.notificationToken);
  //     //localStorage.setString('notificationToken', token);
  //   }).catchError((onError) {
  //     print(onError);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // firebaseCloudMessagingToken();
    // Firebase_Notification(context)
    //     .setupfirebase(_scaffoldKey, widget.navigatorKey);
    // getcurrentVersion();
    // _splashdelay();
    startTime();
  }

  var width, height;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: mainColor,
        floatingActionButton: InkWell(
          splashColor: mainColor,
          onTap: () {
            AppRoutes.push(context, LoginScreen());
          },
          child: Container(
            width: width * .5,
            margin: EdgeInsets.only(bottom: height * .1),
            height: height * .1,
            decoration:
                BoxDecoration(color: lightmainColor, shape: BoxShape.circle),
            child: Center(
              child: Icon(
                Icons.arrow_upward,
                color: mainColor,
                size: height * .06,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * .15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/splash.png",
                  width: width * .5,
                  height: height * .2,
                )
              ],
            ),
            SizedBox(
              height: height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Future Property",
                  style: headingStyle.copyWith(
                      fontSize: height * .04,
                      color: white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        )
        //  Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     decoration: BoxDecoration(
        //         image: DecorationImage(image: AssetImage("images/splash.png"))),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Container(
        //               width: MediaQuery.of(context).size.width,
        //               height: MediaQuery.of(context).size.height * .07,
        //               decoration: BoxDecoration(
        //                   color: Color(0xffFFFDF6),
        //                   image: DecorationImage(
        //                       image: AssetImage("images/splashloading.gif"),
        //                       fit: BoxFit.cover)),
        //             )
        //           ],
        //         ),
        //       ],
        //     )),
        );
  }
}
