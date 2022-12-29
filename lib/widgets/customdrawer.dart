import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/screen.dart/appointment.dart';
import 'package:property_broker/screen.dart/contactrequest.dart';
import 'package:property_broker/screen.dart/dashboard.dart';
import 'package:property_broker/screen.dart/homescreen.dart';
import 'package:property_broker/screen.dart/loginscreen.dart';
import 'package:property_broker/screen.dart/staff.dart';
import 'package:property_broker/screen.dart/supportContact.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/const.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerDrawer extends StatefulWidget {
  bool filter;
  BuyerDrawer({this.filter});
  @override
  _BuyerDrawerState createState() => _BuyerDrawerState();
}

class _BuyerDrawerState extends State<BuyerDrawer> {
  bool physical = false;

  bool virtual = false, all = false, location = false;
  double radius = 0.0;
  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width * .65,
      height: MediaQuery.of(context).size.height * .95,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(width * .1),
              bottomRight: Radius.circular(width * .1)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColor,
                blurRadius: 2,
                spreadRadius: 0.3),
          ]),
      // padding: EdgeInsets.only(left: 10, bottom: 10),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  AppRoutes.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: mainColor,
                ),
              ),
              SizedBox(
                width: width * .02,
              ),
            ],
          ),
          SizedBox(
            height: height * .03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/drawerLogo.png",
                width: width * .6,
                height: height * .12,
              )
            ],
          ),
          SizedBox(
            height: height * .06,
          ),
          ListTile(
            onTap: () {
              AppRoutes.push(context, DashBoard());
            },
            title: Text(
              "${getTranslated(context, "Dashboard")}",
              style: headingStyle.copyWith(
                  fontSize: 14, color: mainColor, fontWeight: FontWeight.bold),
            ),
            leading: Image.asset(
              "images/dashboard.png",
              width: width * .08,
              height: height * .04,
            ),
          ),
          ListTile(
            onTap: () {
              AppRoutes.replace(context, HomeScreen());
            },
            title: Text(
              "${getTranslated(context, "Properties")}",
              style: headingStyle.copyWith(
                  fontSize: 14, color: mainColor, fontWeight: FontWeight.bold),
            ),
            leading: Image.asset(
              "images/Union.png",
              width: width * .08,
              height: height * .03,
            ),
          ),
          ListTile(
            onTap: () {
              AppRoutes.push(context, ContactRequest());
            },
            title: Text(
              "${getTranslated(context, "contactRequest")}",
              style: headingStyle.copyWith(
                  fontSize: 14, color: mainColor, fontWeight: FontWeight.bold),
            ),
            leading: Image.asset(
              "images/phone.png",
              width: width * .08,
              height: height * .03,
            ),
          ),
          ListTile(
            onTap: () {
              AppRoutes.push(context, AppointmentScreen());
            },
            title: Text(
              "${getTranslated(context, "APPOINTMENT")}",
              style: headingStyle.copyWith(
                  fontSize: 14, color: mainColor, fontWeight: FontWeight.bold),
            ),
            leading: Image.asset(
              "images/appointment.png",
              width: width * .08,
              height: height * .03,
            ),
          ),
          ListTile(
            onTap: () {
              AppRoutes.push(context, SupportContact());
            },
            title: Text(
              "${getTranslated(context, "supportContact")}",
              style: headingStyle.copyWith(
                  fontSize: 14, color: mainColor, fontWeight: FontWeight.bold),
            ),
            leading: Image.asset(
              "images/support.png",
              width: width * .08,
              height: height * .03,
            ),
          ),
          ListTile(
            onTap: () {
              AppRoutes.push(context, StaffScreen());
            },
            title: Text(
              "${getTranslated(context, "staff")}",
              style: headingStyle.copyWith(
                  fontSize: 14, color: mainColor, fontWeight: FontWeight.bold),
            ),
            leading: Image.asset(
              "images/staff.png",
              width: width * .08,
              height: height * .03,
            ),
          ),
          ListTile(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              // await prefs.setString("token", token);
              prefs.clear();
              AppRoutes.makeFirst(context, LoginScreen());
            },
            title: Text(
              "${getTranslated(context, "Logout")}",
              style: headingStyle.copyWith(
                  fontSize: 14, color: mainColor, fontWeight: FontWeight.bold),
            ),
            leading: Image.asset(
              "images/logout.png",
              width: width * .08,
              height: height * .03,
            ),
          ),
          SizedBox(
            height: height * .06,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                splashColor: mainColor,
                onTap: () {
                  if (User.userData.lang == "en") {
                    User.userData.lang = "ar";
                    print("Selected languages: ${User.userData.lang}");

                    constValues().changeLanguage("ar", context);
                  } else {
                    User.userData.lang = "en";
                    print("Selected languages: ${User.userData.lang}");
                    constValues().changeLanguage("en", context);
                  }
                },
                child: Text(
                  "English",
                  style: headingStyle.copyWith(
                      fontSize: 16,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * .01, right: width * .01),
                color: mainColor,
                height: height * .03,
                width: 1.5,
              ),
              InkWell(
                splashColor: mainColor,
                onTap: () {
                  if (User.userData.lang == "en") {
                    User.userData.lang = "ar";
                    print("Selected languages: ${User.userData.lang}");

                    constValues().changeLanguage("ar", context);
                  } else {
                    User.userData.lang = "en";
                    print("Selected languages: ${User.userData.lang}");
                    constValues().changeLanguage("en", context);
                  }
                },
                child: Text(
                  "عربى",
                  style: headingStyle.copyWith(
                      fontSize: 16,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
