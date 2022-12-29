import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:property_broker/helper/apisscreen.dart';
import 'package:property_broker/helper/profilenotifier.dart';
import 'package:property_broker/helper/propertynotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/helper/searchnotifier.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/brokermodel.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/screen.dart/editproperty.dart';
import 'package:property_broker/screen.dart/propertyDetail.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/const.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:share/share.dart';

import 'custombutton.dart';
import 'package:url_launcher/url_launcher.dart';

// class PropertyCard extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _PropertyCard();
//   }
// }

class PropertyCard extends StatelessWidget {
  PropertyResult propertyResult;
  int index;
  BuildContext context;
  PropertyCard(
      {@required this.propertyResult,
      @required this.context,
      @required this.index});
  var width, height;
  ValueNotifier<List<BrokerResult>> _dataNotifier =
      ValueNotifier<List<BrokerResult>>(null);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        AppRoutes.push(
            context,
            PropertyDetail(
              id: propertyResult.id,
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: height * .02),
        width: width * .9,
        // padding: EdgeInsets.all(wid),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                new DropdownButton<String>(
                  elevation: 0,
                  underline: Container(
                    height: 1.0,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.transparent, width: 0.0))),
                  ),
                  icon: Icon(Icons.more_vert),
                  items: <String>[
                    "${getTranslated(context, "Email")}",
                    "${getTranslated(context, "share")}",
                    "${getTranslated(context, "pdf")}",
                    propertyResult.isFeatured == 0 ||
                            propertyResult.isFeatured == "0"
                        ? "${getTranslated(context, "feature")}"
                        : "${getTranslated(context, "unfeature")}",
                    propertyResult.published == 0 ||
                            propertyResult.published == "0"
                        ? "${getTranslated(context, "Publish")}"
                        : "${getTranslated(context, "unpublish")}",
                    // "${getTranslated(context, "duplicate")}",
                    propertyResult.archive == 0 || propertyResult.archive == "0"
                        ? "${getTranslated(context, "archive")}"
                        : "${getTranslated(context, "unArchive")}",
                    "${getTranslated(context, "assign")}",
                    "${getTranslated(context, "delete")}",
                  ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Image.asset(
                            value == "${getTranslated(context, "duplicate")}"
                                ? "images/duplicate.png"
                                : value == "${getTranslated(context, "Publish")}" ||
                                        value ==
                                            "${getTranslated(context, "unpublish")}"
                                    ? "images/publish.png"
                                    : value ==
                                            "${getTranslated(context, "archive")}"
                                        ? "images/unarchive.png"
                                        : value ==
                                                "${getTranslated(context, "assign")}"
                                            ? "images/user.png"
                                            : value ==
                                                    "${getTranslated(context, "delete")}"
                                                ? "images/delete.png"
                                                : value == "${getTranslated(context, "feature")}" ||
                                                        value ==
                                                            "${getTranslated(context, "unfeature")}"
                                                    ? "images/star.png"
                                                    : value ==
                                                            "${getTranslated(context, "pdf")}"
                                                        ? "images/pdf.png"
                                                        : value ==
                                                                "${getTranslated(context, "Email")}"
                                                            ? "images/email.png"
                                                            : "images/share.png",
                            width: width * .06,
                            color: mainColor,
                            height: height * .04,
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          Text(value)
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    print("selected value: $value");
                    if (value == "${getTranslated(context, "duplicate")}") {
                      BaseHelper()
                          .duplicate(propertyResult.id, context)
                          .then((value) {
                        print("duplicate response: $value");
                        if (value['error'] == false) {
                          PropertyNotifier().fetchProperties(
                              context, SearchNotifier.search.text);
                          PropertyNotifier().fetchArchiveProperties(context);
                          ProfileNotifier().setProfile(context);
                          constValues().toast("${value['message']}", context);
                        } else {
                          constValues().toast("${value['message']}", context);
                        }
                      });
                    } else if (value == "${getTranslated(context, "pdf")}") {
                      var whatsappUrl = "${API.pdflink}${propertyResult.id}";
                      print("pdf url: $whatsappUrl");
                      await canLaunch(whatsappUrl)
                          ? launch(whatsappUrl)
                          : Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${getTranslated(context, "noWhatsapp")}",
                                ),
                              ),
                            );
                    } else if (value == "${getTranslated(context, "Email")}") {
                      await launch(
                        "mailto:${propertyResult.email}",
                        forceSafariVC: false,
                        forceWebView: false,
                        enableJavaScript: true,
                      );
                    } else if (value == "${getTranslated(context, "share")}") {
                      final RenderBox box = context.findRenderObject();
                      String url = "Hello world";
                      // await _createDynamicLink(property.id);
                      Share.share(url);
                      await Share.share("$url",
                          subject: "Future Property",
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    } else if (value == "${getTranslated(context, "assign")}") {
                      EasyLoading.show();
                      BaseHelper()
                          .getBrokers(_dataNotifier, context)
                          .then((value) {
                        EasyLoading.dismiss();
                        _dataNotifier.value = value;
                        print("Response: ${_dataNotifier.value}");
                        _showModal();
                      });
                    } else if (value == "${getTranslated(context, "edit")}") {
                      AppRoutes.push(
                          context,
                          EditProperty(
                            propertyId: propertyResult.id,
                          ));
                      // AppRoutes.push(
                      //     context,
                      //     EditProperty(
                      //       propertyId:  propertyResult.id,
                      //     ));
                    } else if (value ==
                        "${getTranslated(context, "Publish")}") {
                      BaseHelper()
                          .publishProperty(propertyResult.id, context)
                          .then((value) {
                        print("delete response: $value");
                        if (value['error'] == false) {
                          PropertyNotifier().fetchProperties(
                              context, SearchNotifier.search.text);
                          PropertyNotifier().fetchArchiveProperties(context);
                          ProfileNotifier().setProfile(context);
                          // constValues().toast("${value['message']}", context);
                        } else {
                          constValues().toast("${value['message']}", context);
                        }
                      });
                    } else if (value ==
                        "${getTranslated(context, "unpublish")}") {
                      BaseHelper()
                          .publishProperty(propertyResult.id, context)
                          .then((value) {
                        print("delete response: $value");
                        if (value['error'] == false) {
                          PropertyNotifier().fetchProperties(
                              context, SearchNotifier.search.text);
                          PropertyNotifier().fetchArchiveProperties(context);
                          ProfileNotifier().setProfile(context);
                          // constValues().toast("${value['message']}", context);
                        } else {
                          constValues().toast("${value['message']}", context);
                        }
                      });
                    } else if (value ==
                        "${getTranslated(context, "unfeature")}") {
                      BaseHelper()
                          .featureProperty(propertyResult.id,
                              propertyResult.isFeatured == 0 ? 1 : 0, context)
                          .then((value) {
                        print("delete response: $value");
                        if (value['error'] == false) {
                          PropertyNotifier().fetchProperties(
                              context, SearchNotifier.search.text);
                          PropertyNotifier().fetchArchiveProperties(context);
                          ProfileNotifier().setProfile(context);
                          constValues().toast("${value['message']}", context);
                        } else {
                          constValues().toast("${value['message']}", context);
                        }
                      });
                    } else if (value ==
                        "${getTranslated(context, "feature")}") {
                      BaseHelper()
                          .featureProperty(propertyResult.id,
                              propertyResult.isFeatured == 0 ? 1 : 0, context)
                          .then((value) {
                        print("delete response: $value");
                        if (value['error'] == false) {
                          PropertyNotifier().fetchProperties(
                              context, SearchNotifier.search.text);
                          PropertyNotifier().fetchArchiveProperties(context);
                          constValues().toast("${value['message']}", context);
                          ProfileNotifier().setProfile(context);
                        } else {
                          constValues().toast("${value['message']}", context);
                        }
                      });
                    } else if (value == "${getTranslated(context, "delete")}") {
                      BaseHelper()
                          .deleteProperty(propertyResult.id, context)
                          .then((value) {
                        print("delete response: $value");
                        if (value['error'] == false) {
                          PropertyNotifier().fetchProperties(
                              context, SearchNotifier.search.text);
                          PropertyNotifier().fetchArchiveProperties(context);
                          ProfileNotifier().setProfile(context);
                          constValues().toast("${value['message']}", context);
                        } else {
                          constValues().toast("${value['message']}", context);
                        }
                      });
                    } else if (value ==
                        "${getTranslated(context, "archive")}") {
                      BaseHelper()
                          .archiveProperty(propertyResult.id, context)
                          .then((value) {
                        print("delete response: $value");
                        if (value['error'] == false) {
                          PropertyNotifier().fetchProperties(
                              context, SearchNotifier.search.text);
                          PropertyNotifier().fetchArchiveProperties(context);
                          ProfileNotifier().setProfile(context);
                          constValues().toast("${value['message']}", context);
                        } else {
                          constValues().toast("${value['message']}", context);
                        }
                      });
                    } else if (value ==
                        "${getTranslated(context, "unArchive")}") {
                      BaseHelper()
                          .archiveProperty(propertyResult.id, context)
                          .then((value) {
                        print("delete response: $value");
                        if (value['error'] == false) {
                          PropertyNotifier().fetchProperties(
                              context, SearchNotifier.search.text);
                          PropertyNotifier().fetchArchiveProperties(context);
                          ProfileNotifier().setProfile(context);
                          constValues().toast("${value['message']}", context);
                        } else {
                          constValues().toast("${value['message']}", context);
                        }
                      });
                    }
                    // final response =
                    // await http.post(API.saveUnSave,
                    //     headers: {
                    //       "Authorization":"token ${User.userData.token}:${User.userData.userResult.id}",
                    //     },
                    //     body: {
                    //       "productId":"${User.userData.savedDataModel.result[index].productId}",
                    //     }
                    // );
                    // print(json.decode(response.body));
                    // var JSON=json.decode(response.body);
                    // if(response.statusCode==200)
                    //   {
                    //     if(JSON['Data']['WithError']==false)
                    //       {
                    //         print("unsaved successfully");
                    //         getSavedProductApi();
                    //       }
                    //   }
                    print("hello");
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * .9,
                  height: height * .2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * .03),
                      image: DecorationImage(
                          image: propertyResult.productImages == null ||
                                  propertyResult.productImages
                                      .toString()
                                      .isEmpty
                              ? AssetImage(
                                  "images/logoName.png",
                                )
                              : NetworkImage(
                                  "${propertyResult.baseUrl}${propertyResult.productImages[0].imagePath}"),
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.darken),
                          fit: BoxFit.fill)),
                  padding: EdgeInsets.all(width * .02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: width * .25,
                            height: height * .04,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * .02),
                                color: white),
                            child: Center(
                              child: Text(
                                propertyResult.published == 1 ||
                                        propertyResult.published == "1"
                                    ? "${getTranslated(context, "published")}"
                                    : "${getTranslated(context, "NotPublished")}",
                                style: headingStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: mainColor),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              User.userData.lang == "en"
                                  ? "${propertyResult.title}"
                                  : propertyResult.titleAr == null ||
                                          propertyResult.titleAr == "null" ||
                                          propertyResult.titleAr
                                              .toString()
                                              .isEmpty
                                      ? "${propertyResult.title}"
                                      : "${propertyResult.titleAr}",
                              // User.userData.lang == "en"
                              //     ? "${ propertyResult.title}"
                              //     :  propertyResult.titleAr == null
                              //         ? "${ propertyResult.title}"
                              //         : "${ propertyResult.titleAr}",
                              // "2 Bedroom Flat in Mercato Palazzo for rent",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: headingStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * .02,
            ),
            Padding(
              padding: EdgeInsets.only(left: width * .04, right: width * .04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${propertyResult.price} QAR",
                    style: headingStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                  InkWell(
                    splashColor: white,
                    onTap: () {
                      AppRoutes.push(
                          context,
                          EditProperty(
                            propertyId: propertyResult.id,
                          ));
                    },
                    child: Container(
                      width: width * .2,
                      height: height * .04,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * .02),
                          color: mainColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${getTranslated(context, "edit")}",
                                style: headingStyle.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                              SizedBox(
                                width: width * .025,
                              ),
                              Icon(
                                FontAwesomeIcons.edit,
                                color: white,
                                size: height * .02,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: width * .04, top: height * .015, right: width * .04),
                child: bottomOptions(
                    "${getTranslated(context, "sNo")}${index + 1}",
                    "${getTranslated(context, "code")}: ${propertyResult.code}",
                    "${propertyResult.date}",
                    "${getTranslated(context, "views")}:${propertyResult.viewCount}",
                    "${getTranslated(context, "leads")}:0}")),
          ],
        ),
      ),
    );
  }

  Widget bottomOptions(serial, code, date, views, lead) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "$serial",
          style: headingStyle.copyWith(
              fontSize: height * .015, color: Colors.grey),
        ),
        Text(
          "$code",
          style: headingStyle.copyWith(
              fontSize: height * .015, color: Colors.grey),
        ),
        Text(
          "$date",
          style: headingStyle.copyWith(
              fontSize: height * .015, color: Colors.grey),
        ),
        Text(
          "$views",
          style: headingStyle.copyWith(
              fontSize: height * .015, color: Colors.grey),
        ),
        // Text(
        //   "$lead",
        //   style: headingStyle.copyWith(
        //       fontSize: height * .015, color: Colors.grey),
        // ),
      ],
    );
  }

  void _showModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * .5,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .02),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 10,
              right: 10,
              left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            color: Colors.white,
          ),
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
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, int index) {
                            return Card(
                                elevation: 2,
                                color: white,
                                child: Container(
                                  width: width * .88,
                                  // height: height * .08,
                                  margin: EdgeInsets.only(bottom: height * .03),
                                  padding: EdgeInsets.all(width * .02),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "${_dataNotifier.value[index].name}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: headingStyle.copyWith(
                                                  fontSize: 18,
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              BaseHelper()
                                                  .assignProperty(
                                                      propertyResult.id,
                                                      _dataNotifier
                                                          .value[index].id,
                                                      context)
                                                  .then((value) {
                                                print(
                                                    "assign response: $value");
                                                if (value['error'] == false) {
                                                  PropertyNotifier()
                                                      .fetchProperties(
                                                          context,
                                                          SearchNotifier
                                                              .search.text);
                                                  // PropertyNotifier().fetchArchiveProperties(context);
                                                  // ProfileNotifier().setProfile(context);
                                                  constValues().toast(
                                                      "${value['message']}",
                                                      context);
                                                  AppRoutes.pop(context);
                                                } else {
                                                  constValues().toast(
                                                      "${value['message']}",
                                                      context);
                                                }
                                              });
                                            },
                                            child: CustomButton(
                                              width: width * .35,
                                              height: height * .06,
                                              color: mainColor,
                                              textColor: Colors.white,
                                              title:
                                                  "${getTranslated(context, "assign")}",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          itemCount: _dataNotifier.value.length,
                        ),
                      ),
                    ],
                  );
                }
              }),
        );
      },
    );
  }
}
