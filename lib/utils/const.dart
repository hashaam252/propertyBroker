import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class constValues {
  void toast(String text, BuildContext context) {
    showToast('$text',
        context: context,
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
        textStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.black,
        animation: StyledToastAnimation.slideFromLeft,
        axis: Axis.horizontal,
        alignment: Alignment.topCenter,
        position: StyledToastPosition.top);
  }

  void changeLanguage(String language, BuildContext context) async {
    Locale _locale = await setLocale(language);
    MyApp.setLocale(context, _locale);
  }

  void setsharedpreferencedata(String token, String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setString("language", language);
  }
}
