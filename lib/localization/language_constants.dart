import 'package:flutter/material.dart';
import 'package:property_broker/localization/appLocalizatin.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';

const String ARABIC = 'ar';

Future<Locale> setLocale(String languageCode) async {
  print(languageCode);
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  print(languageCode);
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');

    case ARABIC:
      return Locale(ARABIC, "SA");

    default:
      return Locale(ENGLISH, 'US');
  }
}

String getTranslated(BuildContext context, String key) {
  return AppLocalization.of(context).translate(key);
}
