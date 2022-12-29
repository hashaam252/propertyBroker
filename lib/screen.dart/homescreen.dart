import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_broker/firebasenotification/firebasenotification.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/propertynotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/helper/searchnotifier.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/models/userdatamodel.dart';
import 'package:property_broker/screen.dart/archiveProperties.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';
import 'package:property_broker/widgets/customdrawer.dart';
import 'package:property_broker/widgets/propertyCard.dart';
import 'package:property_broker/helper/profilenotifier.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  var width, height;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<List<PropertyResult>> _dataNotifier =
      ValueNotifier<List<PropertyResult>>(null);
  ValueNotifier<List<PropertyResult>> archivedataNotifier =
      ValueNotifier<List<PropertyResult>>(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase_Notification(context)
        .setupfirebase(scaffoldKey, User.userData.navigatorKey);
    ProfileNotifier().setProfile(context);
    PropertyNotifier().fetchProperties(context, SearchNotifier.search.text);
    NotificationNotifier().fetchNotifications(context);
    PropertyNotifier().fetchArchiveProperties(context);
  }

  static ValueNotifier<UserDataModel> profileNotifiers =
      ValueNotifier<UserDataModel>(null);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    archivedataNotifier = PropertyNotifier.archivedataNotifier;
    int count = NotificationNotifier.count;
    profileNotifiers = ProfileNotifier.profileNotifiers;
    _dataNotifier = PropertyNotifier.dataNotifier;
    // print("property length: ${_dataNotifier.value}");
    return Scaffold(
      key: scaffoldKey,
      drawer: BuyerDrawer(),
      backgroundColor: white,
      appBar: CustomAppBar(
        notificationCount: count,
        height: height * .08,
        count: 0,
        title: "${getTranslated(context, "Properties")}",
        screen: 0,
        notifications: false,
        home: true,
        appointment: false,
        support: false,
        width: width,
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(width * .02),
        child: Column(
          children: [
            header(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * .9,
                  height: height * .06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * .02),
                    border: Border.all(color: Colors.grey[200]),
                    color: Colors.white,
                  ),
                  // padding: ,
                  child: TextField(
                    controller: SearchNotifier.search,

                    // maxLength: widget.number == true ? 8 : 40,
                    style: labelTextStyle.copyWith(
                        // color: secondaryColor,
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),

                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(width * .02),
                        counterText: "",
                        hintText: "${getTranslated(context, "Search")}",
                        suffixIcon: InkWell(
                          splashColor: white,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            EasyLoading.show();
                            PropertyNotifier().fetchProperties(
                                context, SearchNotifier.search.text);
                            Future.delayed(Duration(seconds: 2), () {
                              EasyLoading.dismiss();
                            });
                          },
                          child: Container(
                            width: width * .12,
                            height: height * .04,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * .03),
                                color: mainColor),
                            child: Center(
                              child: Icon(
                                Icons.search,
                                color: white,
                              ),
                            ),
                          ),
                        ),
                        // labelText: "${widget.title}",
                        hintStyle: headingStyle.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300)),
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * .03,
            ),
            ValueListenableBuilder(
                valueListenable: archivedataNotifier,
                // ignore: missing_return
                builder: (context, value, child) {
                  if (value == null) {
                    return Container();
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(
                          right: width * .05, left: width * .05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, "archive")}",
                            style: headingStyle.copyWith(
                                fontSize: 18,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              AppRoutes.push(context, ArchiveProperties());
                            },
                            child: Text(
                              "${getTranslated(context, "view")} (${archivedataNotifier.value.length})",
                              style: headingStyle.copyWith(
                                  fontSize: 16,
                                  color: mainColor,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
            SizedBox(
              height: height * .03,
            ),
            ValueListenableBuilder(
                valueListenable: _dataNotifier,
                // ignore: missing_return
                builder: (context, value, child) {
                  if (value == null) {
                    return SingleChildScrollView(
                      child: Container(
                        width: width,
                        height: height * .5,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            radius: height * .03,
                            iOSVersionStyle:
                                CupertinoActivityIndicatorIOSVersionStyle.iOS14,
                          ),
                        ),
                      ),
                    );
                  } else {
                    if (value.length == 0) {
                      print("eadsadfsafsaf");
                      return Container(
                        width: width,
                        height: height * .5,
                        child: Center(
                            child: Text(
                          "${getTranslated(context, "No results found")}",
                          style: headingStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                      );
                    } else {
                      return Expanded(
                          child: ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, int index) {
                                return PropertyCard(
                                  index: index,
                                  context: context,
                                  propertyResult: value[index],
                                );
                              }));
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return ValueListenableBuilder(
        valueListenable: profileNotifiers,
        // ignore: missing_return
        builder: (context, value, child) {
          if (value == null) {
            return Container();
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * .93,
                  height: height * .12,
                  padding: EdgeInsets.all(width * .03),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${getTranslated(context, "accountStatus")}",
                            style: headingStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            profileNotifiers.value == null
                                ? ""
                                : "${getTranslated(context, "subcriptionStatus")}: ${profileNotifiers.value.subscriptionStatus}",
                            maxLines: 1,
                            style: headingStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: height * .012),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: width * .008, right: width * .008),
                            color: Colors.grey,
                            height: height * .02,
                            width: 1,
                          ),
                          Text(
                            "${getTranslated(context, "activeProperties")}: ${profileNotifiers.value.activeProperties}",
                            maxLines: 1,
                            style: headingStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: height * .012),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: width * .005, right: width * .005),
                            color: Colors.grey,
                            height: height * .02,
                            width: 1,
                          ),
                          Text(
                            "${getTranslated(context, "Feature Properties")}: ${profileNotifiers.value.featuredProperties}",
                            maxLines: 1,
                            style: headingStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: height * .012),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        });
  }
}
