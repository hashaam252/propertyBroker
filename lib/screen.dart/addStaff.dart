import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:property_broker/helper/apisscreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/staffmodel.dart';
import 'package:property_broker/screen.dart/homescreen.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/const.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';
import 'package:property_broker/widgets/custombutton.dart';
import 'package:property_broker/widgets/customdrawer.dart';
import 'package:property_broker/widgets/customtextfield.dart';

class AddStaff extends StatefulWidget {
  int screen = 0;
  StaffResult staffResult;
  AddStaff({@required this.screen, @required this.staffResult});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactRequest();
  }
}

class _ContactRequest extends State<AddStaff> {
  var width, height;
  bool publish = false;
  File image;
  var base64Images;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController whatsApp = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var selectedType;
  List<String> type = [
    "Admin",
    "Staff",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeController();
  }

  initializeController() {
    if (widget.screen == 0) {
    } else {
      setState(() {
        name.text = widget.staffResult.name.toString();
        email.text = widget.staffResult.email.toString();
        // password.text = ;
        whatsApp.text = widget.staffResult.whatsApp.toString();
        phone.text = widget.staffResult.phone.toString();
      });
      if (widget.staffResult.type == 1) {
        setState(() {
          selectedType = "Admin";
        });
      } else {
        setState(() {
          selectedType = "Staff";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    int count = NotificationNotifier.count;
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: CustomAppBar(
        notificationCount: count,
        height: height * .08,
        count: 0,
        screen: widget.screen,
        title: widget.screen == 0
            ? "${getTranslated(context, "addStaff")}"
            : "${getTranslated(context, "editStaff")}",
        appointment: false,
        support: false,
        width: width,
        notifications: true,
        home: false,
      ),
      drawer: BuyerDrawer(),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(width * .03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .03,
              ),
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
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: width * .08),
                            child: InkWell(
                              splashColor: white,
                              onTap: () {
                                _showDialog(context);
                              },
                              child: Icon(
                                Icons.camera_alt,
                                size: height * .04,
                                color: mainColor,
                              ),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: width * .5,
                              height: height * .15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: image != null
                                          ? FileImage(image)
                                          : widget.staffResult.profileImage
                                                      .toString()
                                                      .isNotEmpty ||
                                                  widget.staffResult
                                                          .profileImage !=
                                                      null
                                              ? NetworkImage(
                                                  "${API.Image_Path}${widget.staffResult.profileImage}")
                                              : AssetImage(
                                                  "images/support.png"))),
                            )),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    email: false,
                    phone: false,
                    whatapp: false,
                    controller: name,
                    width: width * .85,
                    pass: false,
                    keyboardTypenumeric: false,
                    number: false,
                    title: "${getTranslated(context, "fullName")}*",
                    height: height * .06,
                  ),
                ],
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    email: false,
                    phone: true,
                    whatapp: false,
                    controller: phone,
                    width: width * .85,
                    pass: false,
                    keyboardTypenumeric: true,
                    number: false,
                    title: "${getTranslated(context, "PhoneNumber")}*",
                    height: height * .06,
                  ),
                ],
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    email: false,
                    phone: false,
                    whatapp: true,
                    controller: whatsApp,
                    width: width * .85,
                    pass: false,
                    keyboardTypenumeric: true,
                    number: false,
                    title: "${getTranslated(context, "whatsApp")}*",
                    height: height * .06,
                  ),
                ],
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    email: true,
                    phone: false,
                    whatapp: false,
                    controller: email,
                    width: width * .85,
                    pass: false,
                    keyboardTypenumeric: false,
                    number: false,
                    title: "${getTranslated(context, "Email")}*",
                    height: height * .06,
                  ),
                ],
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    email: false,
                    phone: false,
                    whatapp: false,
                    controller: password,
                    width: width * .85,
                    pass: true,
                    keyboardTypenumeric: false,
                    number: false,
                    title: "${getTranslated(context, "password")}*",
                    height: height * .06,
                  ),
                ],
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // margin: EdgeInsets.only(top: height * .02),
                    width: width * .85,
                    height: height * .06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * .02),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]),
                    ),
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .03,
                        right: MediaQuery.of(context).size.width * .02),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: mainColor,
                        hint: Text("${getTranslated(context, "selectStaff")}*"),
                        items: type.map((item) {
                          return new DropdownMenuItem(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("$item"),
                              ],
                            ),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            selectedType = newVal;
                          });
                          // print(_propertyTypeSelected);
                        },
                        value: selectedType == null ? null : selectedType,
                        dropdownColor: Colors.white,
                      ),
                    ),
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
                    "${getTranslated(context, "Publish")}",
                    style: headingStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                  Switch(
                    onChanged: (bool value) {
                      setState(() {
                        publish = value;
                      });
                    },
                    activeColor: mainColor,
                    // inactiveThumbColor: Colors.grey,
                    activeTrackColor: mainColor,
                    inactiveTrackColor: Colors.grey,
                    value: publish,
                  ),
                ],
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: lightmainColor,
                    onTap: () {
                      bool isValid = EmailValidator.validate(email.text);
                      // AppRoutes.push(context, HomeScreen());
                      if (name.text.trim().isEmpty ||
                          phone.text.trim().isEmpty ||
                          whatsApp.text.trim().isEmpty ||
                          email.text.trim().isEmpty ||
                          password.text.trim().isEmpty) {
                        constValues().toast(
                            "${getTranslated(context, "fieldEmptyText")}!",
                            context);
                      } else if (!isValid) {
                        constValues().toast(
                            "${getTranslated(context, "invalid_email")}",
                            context);
                      } else if (phone.text.trim().length != 8) {
                        constValues().toast(
                            "${getTranslated(context, "phoneCheck")}!",
                            context);
                      } else if (password.text.trim().length < 8) {
                        constValues().toast(
                            "${getTranslated(context, "must8")}!", context);
                      } else if (selectedType == null) {
                        constValues().toast(
                            "${getTranslated(context, "selectStaff")}!",
                            context);
                      } else {
                        if (widget.screen == 1) {
                          BaseHelper()
                              .updateStaff(
                                  context: context,
                                  profileImage: base64Images,
                                  email: email.text,
                                  id: widget.staffResult.id,
                                  name: name.text,
                                  password: password.text,
                                  phone: "${phone.text}",
                                  staffType: selectedType == "Admin" ? 1 : 2,
                                  whatsApp: whatsApp.text)
                              .then((value) {
                            print("update response: $value");
                            if (value['message'].toString().contains(
                                "Integrity constraint violation: 1062 Duplicate entry ")) {
                              constValues().toast(
                                  "${getTranslated(context, "emailCheck")}!",
                                  context);
                            } else if (value['error'] == false) {
                              constValues()
                                  .toast("${value['message']}", context);
                              AppRoutes.makeFirst(context, HomeScreen());
                            } else {
                              constValues()
                                  .toast("${value['message']}", context);
                            }
                          });
                        } else {
                          BaseHelper()
                              .addStaff(
                                  context: context,
                                  profileImage: base64Images,
                                  email: email.text,
                                  name: name.text,
                                  password: password.text,
                                  phone: "+974${phone.text}",
                                  staffType: selectedType == "Admin" ? 1 : 2,
                                  whatsApp: whatsApp.text)
                              .then((value) {
                            print("update response: $value");
                            if (value['error'] == false) {
                              constValues()
                                  .toast("${value['message']}", context);
                              AppRoutes.makeFirst(context, HomeScreen());
                            } else {
                              constValues()
                                  .toast("${value['message']}", context);
                            }
                          });
                        }
                      }
                    },
                    child: CustomButton(
                      width: width * .85,
                      height: height * .06,
                      color: mainColor,
                      textColor: Colors.white,
                      title: widget.screen == 0
                          ? "${getTranslated(context, "submit")}"
                          : "${getTranslated(context, "update")}",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: lightmainColor,
                    onTap: () {
                      AppRoutes.pop(context);
                      // AppRoutes.push(context, HomeScreen());
                    },
                    child: CustomButton(
                      width: width * .85,
                      height: height * .06,
                      color: white,
                      textColor: mainColor,
                      title: "${getTranslated(context, "cancel")}",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
              width: MediaQuery.of(context).size.width * .7,
              height: MediaQuery.of(context).size.height * .3,
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
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      AppRoutes.pop(context);
                                      BaseHelper()
                                          .chooseImage(true)
                                          .then((value) {
                                        if (value != null) {
                                          setState(() {
                                            final bytes = Io.File(value.path)
                                                .readAsBytesSync();
                                            var img64 = base64Encode(bytes);
                                            base64Images = img64;
                                            image = value;
                                            // images.add(img64);
                                            // _image.value.add(value);
                                          });
                                          //   setState(() {
                                          //     if (id == 1) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       idFront = img64;
                                          //       qataridFront = value;
                                          //     } else if (id == 2) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       idBack = img64;
                                          //       qataridBack = value;
                                          //     } else if (id == 3) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       pasport = img64;
                                          //       passport = value;
                                          //     } else if (id == 4) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       licence = img64;
                                          //       lic = value;
                                          //     }
                                          //   });
                                          //   print("selectedc images: $value");
                                          //   final bytes = Io.File(value.path)
                                          //       .readAsBytesSync();
                                          //   final img = base64Encode(bytes);
                                          //   setState(() {
                                          //     _img = img;
                                          //   });
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  mainColor.withOpacity(0.2)),
                                          color: mainColor),
                                      child: Center(
                                        child: Text(
                                            "${getTranslated(context, "Gallery")}",
                                            textAlign: TextAlign.center,

                                            //   maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: white, fontSize: 16)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      AppRoutes.pop(context);
                                      BaseHelper()
                                          .chooseImage(false)
                                          .then((value) {
                                        if (value != null) {
                                          setState(() {
                                            final bytes = Io.File(value.path)
                                                .readAsBytesSync();
                                            var img64 = base64Encode(bytes);
                                            base64Images = img64;
                                            image = value;
                                            // images.add(img64);
                                            // _image.value.add(value);
                                          });

                                          //   setState(() {
                                          //     if (id == 1) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       idFront = img64;
                                          //       qataridFront = value;
                                          //     } else if (id == 2) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       idBack = img64;
                                          //       qataridBack = value;
                                          //     } else if (id == 3) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       pasport = img64;
                                          //       passport = value;
                                          //     } else if (id == 4) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       licence = img64;
                                          //       lic = value;
                                          //     }
                                          //   });
                                          //   print("selectedc images: $value");
                                          //   final bytes = Io.File(value.path)
                                          //       .readAsBytesSync();
                                          //   final img = base64Encode(bytes);
                                          //   setState(() {
                                          //     _img = img;
                                          //   });
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  mainColor.withOpacity(0.2)),
                                          color: mainColor),
                                      child: Center(
                                          child: Text(
                                              "${getTranslated(context, "camera")}",
                                              textAlign: TextAlign.center,
                                              //   maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: white, fontSize: 16))),
                                    ),
                                  ),
                                ],
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
                          FontAwesomeIcons.image,
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
}
