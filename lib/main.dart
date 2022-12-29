import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:property_broker/firebasenotification/firebasenotification.dart';
import 'package:property_broker/helper/profilenotifier.dart';
import 'package:property_broker/localization/appLocalizatin.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/screen.dart/homescreen.dart';
import 'package:property_broker/screen.dart/splash.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void dialogBox() {
  EasyLoading.instance
    ..backgroundColor = Colors.white.withOpacity(0.4)
    ..progressColor = mainColor
    ..loadingStyle = EasyLoadingStyle.custom
    ..radius = 10
    ..textColor = Colors.white
    ..indicatorColor = mainColor
    ..dismissOnTap = true
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..indicatorSize = 100;
}

void main() async {
  dialogBox();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Firebase_Notification(context).setupfirebase(_scaffoldkey, navigatorKey);
    setState(() {
      User.userData.navigatorKey = navigatorKey;
    });
    getUser();
    // Firebase_Notification(context)
    //     .setupfirebase(_scaffoldkey, User.userData.navigatorKey);
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    if (token != null) {
      setState(() {
        User.userData.token = token;
      });
      ProfileNotifier().setProfile(context);
    }
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      User.userData.lang = locale.languageCode;

      print(User.userData.lang);
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
        User.userData.lang = locale.languageCode;

        print(User.userData.lang);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: mainColor, systemNavigationBarColor: mainColor));
    return OverlaySupport(
        child: MaterialApp(
      navigatorKey: navigatorKey,
      builder: EasyLoading.init(),
      locale: _locale,
      supportedLocales: [
        Locale("en", "US"),
        Locale("ar", "SA"),
      ],
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        fontFamily: 'cream',
        //primarySwatch: Colors.green,
        primaryColor: mainColor,
        accentColor: maintextColor,

        accentTextTheme: TextTheme(
            subtitle1: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            bodyText1: headingStyle.copyWith(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            bodyText2: subHeading.copyWith(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w300)),
      ),
      debugShowCheckedModeBanner: false,
      home: User.userData.token != null
          ? HomeScreen()
          : Splash(
              navigatorKey: navigatorKey,
            ),
      // home: NotificationClick(),
    ));
  }
}
