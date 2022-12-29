import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/pushNotificationModel.dart';
import 'package:property_broker/screen.dart/propertyDetail.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotificationScreen();
  }
}

class _NotificationScreen extends State<NotificationScreen> {
  var width, height;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationNotifier().fetchNotifications(context);
    // BaseHelper().getNotificaitons(_dataNotifier, context).then((value) {

    // });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        NotificationNotifier().fetchNotifications(context);
        AppRoutes.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "${getTranslated(context, "Notifications")}",
            style: headingStyle.copyWith(
                fontSize: 18, color: mainColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: white,
          leading: GestureDetector(
            onTap: () {
              NotificationNotifier().fetchNotifications(context);
              AppRoutes.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: height * .03,
              color: mainColor,
            ),
          ),
        ),
        body: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(width * .02),
          child: Column(
            children: [
              ValueListenableBuilder(
                  valueListenable: NotificationNotifier.dataNotifier,
                  // ignore: missing_return
                  builder: (context, value, child) {
                    if (value == null) {
                      return Center(
                        child: CupertinoActivityIndicator(
                          radius: height * .03,
                          iOSVersionStyle:
                              CupertinoActivityIndicatorIOSVersionStyle.iOS14,
                        ),
                      );
                    } else {
                      return Expanded(
                          child: ListView.builder(
                        itemBuilder: (context, int index) {
                          return Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Container(
                              width: width * .88,
                              // height: height*,
                              padding: EdgeInsets.all(width * .02),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      NotificationNotifier.dataNotifier
                                                      .value[index].isRead ==
                                                  "0" ||
                                              NotificationNotifier.dataNotifier
                                                      .value[index].isRead ==
                                                  0
                                          ? Container(
                                              height: 5,
                                              width: 5,
                                              color: Colors.red,
                                            )
                                          : Container(
                                              height: 5,
                                              width: 5,
                                              color: white,
                                            )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NotificationNotifier.dataNotifier
                                                    .value[index].type
                                                    .toString() ==
                                                "book-appointment"
                                            ? "Book Appointment"
                                            : NotificationNotifier.dataNotifier
                                                        .value[index].type
                                                        .toString() ==
                                                    "contact-request"
                                                ? "Contact Request"
                                                : "${NotificationNotifier.dataNotifier.value[index].type}",
                                        style: headingStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: mainColor,
                                            fontSize: 18),
                                      ),
                                      InkWell(
                                        splashColor: white,
                                        onTap: () {
                                          BaseHelper()
                                              .readNotificaiton(
                                                  NotificationNotifier
                                                      .dataNotifier
                                                      .value[index]
                                                      .id,
                                                  context)
                                              .then((val) {
                                            if (val['error'] == false) {
                                              NotificationNotifier()
                                                  .fetchNotifications(context);
                                            }
                                          });
                                          AppRoutes.push(
                                              context,
                                              PropertyDetail(
                                                  id: NotificationNotifier
                                                      .dataNotifier
                                                      .value[index]
                                                      .propertId));
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "View",
                                                  style: headingStyle.copyWith(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: NotificationNotifier
                                                                      .dataNotifier
                                                                      .value[
                                                                          index]
                                                                      .isRead ==
                                                                  "0" ||
                                                              NotificationNotifier
                                                                      .dataNotifier
                                                                      .value[
                                                                          index]
                                                                      .isRead ==
                                                                  0
                                                          ? mainColor
                                                          : Colors.grey),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: width * .15,
                                                  height: 2,
                                                  color: NotificationNotifier
                                                                  .dataNotifier
                                                                  .value[index]
                                                                  .isRead ==
                                                              "0" ||
                                                          NotificationNotifier
                                                                  .dataNotifier
                                                                  .value[index]
                                                                  .isRead ==
                                                              0
                                                      ? mainColor
                                                      : Colors.grey,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  NotificationNotifier.dataNotifier.value[index]
                                                  .email ==
                                              null ||
                                          NotificationNotifier.dataNotifier
                                                  .value[index].email ==
                                              "null" ||
                                          NotificationNotifier
                                              .dataNotifier.value[index].email
                                              .toString()
                                              .isEmpty
                                      ? Container()
                                      : SizedBox(
                                          height: height * .02,
                                        ),
                                  NotificationNotifier.dataNotifier.value[index]
                                                  .email ==
                                              null ||
                                          NotificationNotifier.dataNotifier
                                                  .value[index].email ==
                                              "null" ||
                                          NotificationNotifier
                                              .dataNotifier.value[index].email
                                              .toString()
                                              .isEmpty
                                      ? Container()
                                      : Row(
                                          children: [
                                            Text(
                                              "${NotificationNotifier.dataNotifier.value[index].email}",
                                              style: headingStyle.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  // color: mainColor,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                  SizedBox(
                                    height: height * .02,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${NotificationNotifier.dataNotifier.value[index].phone}",
                                        style: headingStyle.copyWith(
                                            fontWeight: FontWeight.w300,
                                            // color: mainColor,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount:
                            NotificationNotifier.dataNotifier.value.length,
                      ));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
