import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_broker/helper/profilenotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/models/userdatamodel.dart';
import 'package:property_broker/screen.dart/homescreen.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/const.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/custombutton.dart';
import 'package:property_broker/widgets/customtextfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  var width, height;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainColor,
      body: Container(
        width: width,
        height: height,
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: EdgeInsets.only(top: height * .12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/splash.png",
                          width: width * .5,
                          height: height * .14,
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
                              fontSize: height * .03,
                              color: white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: width,
              height: height * .6,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(width * .04),
                      topRight: Radius.circular(width * .04))),
              padding: EdgeInsets.all(width * .02),
              child: Column(
                children: [
                  Divider(
                    thickness: 2,
                    endIndent: width * .33,
                    indent: width * .33,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${getTranslated(context, "Login")}",
                        style: headingStyle.copyWith(
                            fontSize: height * .04,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * .12,
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
                        title: "${getTranslated(context, "Email")}",
                        height: height * .06,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: password,
                        email: false,
                        phone: false,
                        whatapp: false,
                        width: width * .85,
                        pass: true,
                        keyboardTypenumeric: false,
                        number: false,
                        title: "${getTranslated(context, "password")}",
                        height: height * .06,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: lightmainColor,
                        onTap: () {
                          bool isValid = EmailValidator.validate(email.text);
                          if (email.text.trim().isEmpty ||
                              password.text.trim().isEmpty) {
                            constValues().toast(
                                "${getTranslated(context, "fieldEmptyText")}",
                                context);
                          } else if (!isValid) {
                            constValues().toast(
                                "${getTranslated(context, "invalid_email")}",
                                context);
                          } else {
                            BaseHelper()
                                .loginUser(email.text, password.text, context)
                                .then((value) {
                              print("login response: $value");
                              if (value['error'] == false) {
                                UserDataModel userDataModel = UserDataModel();
                                setState(() {
                                  userDataModel = UserDataModel.fromJson(value);
                                  User.userData.userResult =
                                      userDataModel.result;
                                  User.userData.token = value['token'];
                                  constValues().setsharedpreferencedata(
                                      "${User.userData.token}", "en");
                                });

                                AppRoutes.push(context, HomeScreen());
                              } else {
                                constValues()
                                    .toast("${value['message']}", context);
                              }
                            });
                          }
                          // AppRoutes.push(context, HomeScreen());
                        },
                        child: CustomButton(
                          width: width * .85,
                          height: height * .06,
                          color: mainColor,
                          textColor: Colors.white,
                          title: "${getTranslated(context, "Login")}",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
