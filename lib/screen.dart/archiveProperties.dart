import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/propertynotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';
import 'package:property_broker/widgets/customdrawer.dart';
import 'package:property_broker/widgets/propertyCard.dart';

class ArchiveProperties extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreen();
  }
}

class _HomeScreen extends State<ArchiveProperties> {
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
    // PropertyNotifier().fetchProperties(context);
    PropertyNotifier().fetchArchiveProperties(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    archivedataNotifier = PropertyNotifier.archivedataNotifier;

    // _dataNotifier = PropertyNotifier.dataNotifier;
    // print("property length: ${_dataNotifier.value}");
    int count = NotificationNotifier.count;
    return Scaffold(
      key: scaffoldKey,
      // drawer: BuyerDrawer(),
      backgroundColor: white,
      appBar: CustomAppBar(
        height: height * .08,
        notificationCount: count,
        count: 0,
        title: "${getTranslated(context, "archiveProperties")}",
        screen: 0,
        notifications: true,
        home: false,
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
            ValueListenableBuilder(
                valueListenable: archivedataNotifier,
                // ignore: missing_return
                builder: (context, value, child) {
                  if (value == null) {
                    return Container(
                      width: width,
                      height: height * .7,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          radius: height * .03,
                          iOSVersionStyle:
                              CupertinoActivityIndicatorIOSVersionStyle.iOS14,
                        ),
                      ),
                    );
                  } else {
                    // print("eadsadfsafsaf");
                    //           archivedataNotifier.value == null
                    // ? Center(
                    //     child: Text(
                    //     "No Property Found",
                    //     style: headingStyle.copyWith(
                    //         fontSize: 18, fontWeight: FontWeight.bold),
                    //   ))
                    // :
                    if (value.length == 0) {
                      print("eadsadfsafsaf");
                      return Container(
                        width: width,
                        height: height * .7,
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
                                  context: context,
                                  index: index,
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
}
