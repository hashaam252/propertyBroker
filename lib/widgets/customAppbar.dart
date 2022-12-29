import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/screen.dart/addStaff.dart';
import 'package:property_broker/screen.dart/addproperty.dart';
import 'package:property_broker/screen.dart/notification.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';

// class HomeBar extends StatefulWidget {

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState

//     return DetailAppbar();
//   }
// }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  var width, height;
  double h;
  bool support = false,
      notifications = false,
      home = false,
      appointment = false;
  String title;
  int count = 0, notificationCount = 0;
  int screen = 0;

  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  CustomAppBar(
      {@required this.title,
      @required this.appointment,
      @required this.notifications,
      @required this.notificationCount,
      @required this.count,
      @required this.screen,
      @required this.home,
      @required this.height,
      @required this.support,
      @required this.width});
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    int cou = NotificationNotifier.count;
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(
          top: height * .05, left: width * .03, right: width * .03),
      width: width,
      height: height * .15,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                splashColor: white,
                onTap: () {
                  if (title == "${getTranslated(context, "addProperty")}" ||
                      title == "${getTranslated(context, "propertyDetail")}" ||
                      title == "${getTranslated(context, "editProperty")}" ||
                      title ==
                          "${getTranslated(context, "archiveProperties")}") {
                    AppRoutes.pop(context);
                  } else {
                    Scaffold.of(context).openDrawer();
                  }
                },
                child: Icon(
                  title == "${getTranslated(context, "addProperty")}" ||
                          title ==
                              "${getTranslated(context, "propertyDetail")}" ||
                          title ==
                              "${getTranslated(context, "editProperty")}" ||
                          title ==
                              "${getTranslated(context, "archiveProperties")}"
                      ? Icons.arrow_back_ios
                      : Icons.menu,
                  size: height * .03,
                  color: mainColor,
                ),
              ),
              Text(
                "$title",
                style: headingStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              home == true
                  ? Row(
                      children: [
                        ValueListenableBuilder(
                            valueListenable:
                                NotificationNotifier.notificationCount,
                            // ignore: missing_return
                            builder: (context, value, child) {
                              return InkWell(
                                splashColor: white,
                                onTap: () {
                                  AppRoutes.push(context, NotificationScreen());
                                },
                                child: Badge(
                                  badgeContent: Text(
                                    value == null ? "0" : '${value}',
                                    style: headingStyle.copyWith(
                                        fontSize: height * .012, color: white),
                                  ),
                                  child: Icon(
                                    Icons.notifications,
                                    color: mainColor,
                                    size: height * .03,
                                  ),
                                ),
                              );
                            }),
                        SizedBox(
                          width: width * .06,
                        ),
                        InkWell(
                          splashColor: white,
                          onTap: () {
                            AppRoutes.push(context, AddProperty());
                          },
                          child: Icon(
                            Icons.add,
                            size: height * .03,
                            color: mainColor,
                          ),
                        ),
                      ],
                    )
                  : notifications == true
                      ? ValueListenableBuilder(
                          valueListenable:
                              NotificationNotifier.notificationCount,
                          // ignore: missing_return
                          builder: (context, value, child) {
                            return InkWell(
                              splashColor: white,
                              onTap: () {
                                AppRoutes.push(context, NotificationScreen());
                              },
                              child: Badge(
                                badgeContent: Text(
                                  value == null ? "0" : '${value}',
                                  style: headingStyle.copyWith(
                                      fontSize: height * .012, color: white),
                                ),
                                child: Icon(
                                  Icons.notifications,
                                  color: mainColor,
                                  size: height * .03,
                                ),
                              ),
                            );
                          })

                      // InkWell(
                      //     splashColor: white,
                      //     onTap: () {
                      //       AppRoutes.push(context, NotificationScreen());
                      //       a
                      //     },
                      //     child: Icon(
                      //       Icons.notifications,
                      //       size: height * .03,
                      //       color: mainColor,
                      //     ),
                      //   )
                      : support == true
                          ? InkWell(
                              splashColor: white,
                              onTap: () {},
                              child: Icon(
                                FontAwesomeIcons.edit,
                                size: height * .03,
                                color: mainColor,
                              ),
                            )
                          : appointment == true
                              ? Container(
                                  width: width * .06,
                                  height: height * .03,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * .02),
                                    color: Colors.grey,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$count",
                                      style: headingStyle.copyWith(
                                          fontSize: 16, color: mainColor),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  splashColor: white,
                                  onTap: () {
                                    AppRoutes.push(
                                        context,
                                        AddStaff(
                                          screen: screen,
                                          staffResult: null,
                                        ));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: height * .03,
                                    color: mainColor,
                                  ),
                                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50);
}
