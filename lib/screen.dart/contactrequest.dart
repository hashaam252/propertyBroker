import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:property_broker/helper/appointmentorrequestnotifier.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/main.dart';
import 'package:property_broker/models/staffmodel.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';
import 'package:property_broker/widgets/custombutton.dart';
import 'package:property_broker/widgets/customdrawer.dart';
import 'package:property_broker/widgets/expansionCard.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ContactRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactRequest();
  }
}

class _ContactRequest extends State<ContactRequest> {
  var width, height;
  var startDate;
  //  DateTime.now();
  var endDate;
  // = DateTime.now().add(Duration(days: 2));
  var selectedStatus = 0, selectedStatusName = "New";
  ValueNotifier<List<StaffResult>> _dataNotifier =
      ValueNotifier<List<StaffResult>>(null);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppointmentNotifier().fetchData(
        context,
        1,
        startDate == null
            ? null
            : "${startDate.year}-${startDate.month}-${startDate.day}",
        endDate == null
            ? null
            : "${endDate.year}-${endDate.month}-${endDate.day}",
        selectedStatus);
  }

  List status = [1, 2, 3, 4, 5, 6, 7, 8];
  List statusName = [
    "New",
    "Open",
    "In Progress",
    "Open Deal",
    "Unqualified",
    "Attempt to contact",
    "Connected",
    "Bad Timing"
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    int cou = NotificationNotifier.count;
    _dataNotifier = AppointmentNotifier.dataNotifier;
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      drawer: BuyerDrawer(),
      appBar: CustomAppBar(
        height: height * .08,
        screen: 0,
        notificationCount: cou,
        count: count,
        title: "${getTranslated(context, "contactRequest")}",
        appointment: true,
        support: false,
        width: width,
        notifications: true,
        home: false,
      ),
      body: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          startDate = date;
                        });

                        // dateNotifier.setDate(
                        //     "${date.day.toString()}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(2, '0')} ${date.hour.toString()}:${date.minute.toString()}:${date.second.toString()}");
                        // String stringDate = dateFormat.format(timeSchedule);
                        // print(stringDate);
                        // String convertedDateTime =
                        //     "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString()}:${date.minute.toString()}";
                        // print('lele $convertedDateTime');
                      }, currentTime: DateTime.now());
                    },
                    child: Container(
                      width: width * .4,
                      height: height * .06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * .03),
                        color: Colors.grey[350],
                      ),
                      padding: EdgeInsets.all(width * .02),
                      child: Center(
                        child: Text(
                          startDate == null
                              ? "${getTranslated(context, "startDate")}"
                              : "${startDate.day}/${startDate.month}/${startDate.year}",
                          style: headingStyle.copyWith(
                              fontSize: 16, color: mainColor),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          endDate = date;
                        });
                        EasyLoading.show();
                        AppointmentNotifier().fetchData(
                            context,
                            1,
                            startDate == null
                                ? null
                                : "${startDate.year}-${startDate.month}-${startDate.day}",
                            endDate == null
                                ? null
                                : "${endDate.year}-${endDate.month}-${endDate.day}",
                            selectedStatus);
                        // dateNotifier.setDate(
                        //     "${date.day.toString()}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(2, '0')} ${date.hour.toString()}:${date.minute.toString()}:${date.second.toString()}");
                        // String stringDate = dateFormat.format(timeSchedule);
                        // print(stringDate);
                        // String convertedDateTime =
                        //     "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString()}:${date.minute.toString()}";
                        // print('lele $convertedDateTime');
                      }, currentTime: DateTime.now());
                    },
                    child: Container(
                      width: width * .4,
                      height: height * .06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * .03),
                        color: Colors.grey[350],
                      ),
                      padding: EdgeInsets.all(width * .02),
                      child: Center(
                        child: Text(
                          endDate == null
                              ? "${getTranslated(context, "endDate")}"
                              : "${endDate.day}/${endDate.month}/${endDate.year}",
                          style: headingStyle.copyWith(
                              fontSize: 16, color: mainColor),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        _showModal();
                      },
                      child: Image.asset(
                        "images/sort.png",
                        color: mainColor,
                        width: width * .12,
                        height: height * .06,
                      ))
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       margin: EdgeInsets.only(top: height * .02),
              //       width: width * .9,
              //       height: height * .06,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(
              //             MediaQuery.of(context).size.width * .02),
              //         color: Colors.white,
              //         border: Border.all(color: Colors.grey[200]),
              //       ),
              //       padding: EdgeInsets.only(
              //           left: MediaQuery.of(context).size.width * .03,
              //           right: MediaQuery.of(context).size.width * .02),
              //       child: DropdownButtonHideUnderline(
              //         child: DropdownButton(
              //           isExpanded: true,
              //           iconEnabledColor: mainColor,
              //           hint: Row(
              //             children: [
              //               Text(
              //                 "Select Status",
              //               ),
              //               Text(
              //                 "*",
              //                 style: headingStyle.copyWith(color: Colors.red),
              //               )
              //             ],
              //           ),
              //           items: statusName.map((item) {
              //             return new DropdownMenuItem(
              //               child: Row(
              //                 mainAxisSize: MainAxisSize.min,
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   Text("$item"),
              //                 ],
              //               ),
              //               value: item,
              //             );
              //           }).toList(),
              //           onChanged: (newVal) {
              //             setState(() {
              //               selectedStatusName = newVal;
              //               var ind = statusName.indexOf(newVal);
              //               print("index: $ind");
              //               selectedStatus = ind;
              //               // EasyLoading.show();
              //               AppointmentNotifier().fetchData(
              //                   context,
              //                   0,
              //                   "${startDate.year}-${startDate.month}-${startDate.day}",
              //                   "${endDate.year}-${endDate.month}-${endDate.day}",
              //                   selectedStatus);
              //               // selectedZoneLocation = null;
              //             });

              //             // print(_propertyTypeSelected);
              //           },
              //           value: selectedStatusName == null
              //               ? null
              //               : selectedStatusName,
              //           dropdownColor: Colors.white,
              //         ),
              //       ),
              //     )
              //   ],
              // ),

              ValueListenableBuilder(
                  valueListenable: _dataNotifier,
                  // ignore: missing_return
                  builder: (context, value, child) {
                    if (value == null) {
                      return Container(
                        width: width,
                        height: height * .6,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            radius: height * .03,
                            iOSVersionStyle:
                                CupertinoActivityIndicatorIOSVersionStyle.iOS14,
                          ),
                        ),
                      );
                    } else {
                      count = value.length;
                      if (value.length == 0) {
                        return Container(
                          width: width,
                          height: height * .6,
                          child: Center(
                              child: Text(
                            "${getTranslated(context, "nodata")}",
                            textAlign: TextAlign.center,
                            style: headingStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: mainColor),
                          )),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, int index) {
                                return ExpansionCard(
                                  startDate: startDate,
                                  endDate: endDate,
                                  staff: false,
                                  staffCard: false,
                                  staffResult: value[index],
                                );
                              }),
                        );
                      }
                    }
                  }),
            ],
          )),
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
                top: height * .03,
                right: 10,
                left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, int index) {
                      return InkWell(
                        splashColor: mainColor,
                        onTap: () {
                          setState(() {
                            AppRoutes.pop(context);
                            selectedStatusName = statusName[index];
                            // var ind = statusName.indexOf(newVal);
                            // print("index: $ind");
                            selectedStatus = index;
                            // EasyLoading.show();
                            AppointmentNotifier().fetchData(
                                context,
                                1,
                                startDate == null
                                    ? null
                                    : "${startDate.year}-${startDate.month}-${startDate.day}",
                                endDate == null
                                    ? null
                                    : "${endDate.year}-${endDate.month}-${endDate.day}",
                                selectedStatus);
                            // selectedZoneLocation = null;
                          });
                        },
                        child: Container(
                          width: width * .85,
                          padding: EdgeInsets.all(width * .02),
                          decoration: BoxDecoration(color: white),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${statusName[index]}",
                                    style: headingStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: mainColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              Divider(
                                color: mainColor,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: statusName.length,
                  ),
                )
              ],
            ));
      },
    );
  }
}
