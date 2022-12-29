import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/staffmodel.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';
import 'package:property_broker/widgets/custombutton.dart';
import 'package:property_broker/widgets/customdrawer.dart';
import 'package:property_broker/widgets/expansionCard.dart';

class StaffScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactRequest();
  }
}

class _ContactRequest extends State<StaffScreen> {
  var width, height;
  ValueNotifier<List<StaffResult>> _dataNotifier =
      ValueNotifier<List<StaffResult>>(null);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BaseHelper().getStaff(_dataNotifier, context);
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
        notificationCount: count,
        height: height * .08,
        count: 0,
        screen: 0,
        title: "${getTranslated(context, "staff")}",
        appointment: false,
        support: false,
        width: width,
        notifications: false,
        home: false,
      ),
      body: Container(
          width: width,
          height: height,
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
                  if (value.length == 0) {
                    return Center(
                        child: Text(
                      "${getTranslated(context, "nodata")}",
                      textAlign: TextAlign.center,
                      style: headingStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ));
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, int index) {
                                return ExpansionCard(
                                  staff: true,
                                  staffCard: true,
                                  staffResult: value[index],
                                );
                              }),
                        )
                      ],
                    );
                  }
                }
              })),
    );
  }
}
