import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/supportcontactModel.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';
import 'package:property_broker/widgets/customdrawer.dart';
import 'package:property_broker/widgets/customtextfield.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactRequest();
  }
}

class _ContactRequest extends State<SupportContact> {
  var width, height;
  ValueNotifier<SupportModelResult> _dataNotifier =
      ValueNotifier<SupportModelResult>(null);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BaseHelper().getSupport(context: context, notifier: _dataNotifier);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    int count = NotificationNotifier.count;
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      drawer: BuyerDrawer(),
      appBar: CustomAppBar(
        screen: 0,
        height: height * .08,
        notificationCount: count,
        count: 0,
        title: "${getTranslated(context, "supportContact")}",
        appointment: false,
        support: false,
        width: width,
        notifications: true,
        home: false,
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(width * .03),
        child: ValueListenableBuilder(
            valueListenable: _dataNotifier,
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
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * .5,
                          height: height * .17,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, spreadRadius: 0.2)
                              ],
                              color: Colors.white),
                          child: Center(
                            child: Image.asset("images/support.png",
                                width: width * .4,
                                height: height * .1,
                                fit: BoxFit.contain),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * .04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${value.name}",
                          style: headingStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: height * .025),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * .08,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: mainColor,
                          onTap: () async {
                            await launch(
                              "mailto:${value.email}",
                              forceSafariVC: false,
                              forceWebView: false,
                              enableJavaScript: true,
                            );
                          },
                          child: Container(
                            width: width * .85,
                            height: height * .06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * .02),
                              border: Border.all(color: Colors.grey[200]),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(width * .01),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      color: mainColor,
                                    ),
                                    SizedBox(
                                      width: width * .02,
                                    ),
                                    Text("${value.email}")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // CustomTextField(
                        //   // controller: confirmPassword,
                        //   email: true,
                        //   phone: false,
                        //   whatapp: false,
                        //   width: width * .85,
                        //   pass: false,
                        //   keyboardTypenumeric: false,
                        //   number: false,
                        //   title: "support@futureproperty.qa",
                        //   height: height * .06,
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: mainColor,
                          onTap: () async {
                            await launch(
                              "tel://${value.phone}",
                              forceSafariVC: false,
                              forceWebView: false,
                              enableJavaScript: true,
                            );
                          },
                          child: Container(
                            width: width * .85,
                            height: height * .06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * .02),
                              border: Border.all(color: Colors.grey[200]),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(width * .01),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: mainColor,
                                    ),
                                    SizedBox(
                                      width: width * .02,
                                    ),
                                    Text(
                                      "${value.phone}",
                                      textDirection: TextDirection.ltr,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // CustomTextField(
                        //   // controller: confirmPassword,
                        //   email: false,
                        //   phone: true,
                        //   whatapp: false,
                        //   width: width * .85,
                        //   pass: false,
                        //   keyboardTypenumeric: false,
                        //   number: false,
                        //   title: "+974440010080",
                        //   height: height * .06,
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: mainColor,
                          onTap: () async {
                            var whatsappUrl =
                                "whatsapp://send?phone=${value.whatsApp}";
                            await canLaunch(whatsappUrl)
                                ? launch(whatsappUrl)
                                : scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${getTranslated(context, "noWhatsapp")}",
                                      ),
                                    ),
                                  );
                          },
                          child: Container(
                            width: width * .85,
                            height: height * .06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * .02),
                              border: Border.all(color: Colors.grey[200]),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(width * .01),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: mainColor,
                                    ),
                                    SizedBox(
                                      width: width * .02,
                                    ),
                                    Text(
                                      "${value.whatsApp}",
                                      textDirection: TextDirection.ltr,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
