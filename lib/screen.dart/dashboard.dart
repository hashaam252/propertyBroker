import 'package:bezier_chart/bezier_chart.dart';
import 'package:fl_chart/fl_chart.dart' as prefix;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/dashboardmodel.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';
import 'package:property_broker/widgets/customdrawer.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DashBoard();
  }
}

class _DashBoard extends State<DashBoard> {
  var width, height;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final fromDate = DateTime(DateTime.now().year, 1, 1);
  final toDate = DateTime(DateTime.now().year, 12, 30);
  ValueNotifier<DashboardModel> _dataNotifier =
      ValueNotifier<DashboardModel>(null);

  // final date1 = DateTime.now().subtract(Duration(days: 2));
  // final date2 = DateTime.now().subtract(Duration(days: 3));

  // final date3 = DateTime.now().subtract(Duration(days: 35));
  // final date4 = DateTime.now().subtract(Duration(days: 36));

  // final date5 = DateTime.now().subtract(Duration(days: 65));
  // final date6 = DateTime.now().subtract(Duration(days: 64));
  List<DataPoint<dynamic>> rentData = [];
  List<DataPoint<dynamic>> saleData = [];
  List<double> rentCount = List<double>();
  List<double> saleCount = List<double>();
  List<String> label = List<String>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("from date: $fromDate");
    print("To date: $toDate");
    BaseHelper().getDashboardData(_dataNotifier, context).then((value) {
      // setState(() {
      //   label = _dataNotifier.value.barchartModel.name;
      // });
      for (int i = 0; i < _dataNotifier.value.rentResult.length; i++) {
        setState(() {
          rentData.add(DataPoint<DateTime>(
              value: double.parse(
                  _dataNotifier.value.rentResult[i].value.toString()),
              xAxis: DateTime.parse(
                  _dataNotifier.value.rentResult[i].date.toString())));
        });
      }
      for (int i = 0; i < _dataNotifier.value.saleResult.length; i++) {
        setState(() {
          saleData.add(DataPoint<DateTime>(
              value: double.parse(
                  _dataNotifier.value.saleResult[i].value.toString()),
              xAxis: DateTime.parse(
                  _dataNotifier.value.saleResult[i].date.toString())));
        });
      }
      for (int i = 0; i < _dataNotifier.value.barchartModel.name.length; i++) {
        setState(() {
          label.add(_dataNotifier.value.barchartModel.name[i].toString());
        });
      }
      for (int i = 0;
          i < _dataNotifier.value.barchartModel.rentCount.length;
          i++) {
        setState(() {
          rentCount.add(double.parse(
              _dataNotifier.value.barchartModel.rentCount[i].toString()));
        });
      }
      for (int i = 0;
          i < _dataNotifier.value.barchartModel.saleCount.length;
          i++) {
        setState(() {
          saleCount.add(double.parse(
              _dataNotifier.value.barchartModel.saleCount[i].toString()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    int count = NotificationNotifier.count;
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      drawer: BuyerDrawer(),
      backgroundColor: white,
      appBar: CustomAppBar(
        height: height * .08,
        title: "${getTranslated(context, "Dashboard")}",
        notificationCount: count,
        count: 0,
        screen: 0,
        appointment: false,
        support: false,
        width: width,
        notifications: true,
        home: false,
      ),
      body: Container(
        width: width,
        // height: height,
        padding: EdgeInsets.all(width * .03),
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
              valueListenable: _dataNotifier,
              // ignore: missing_return
              builder: (context, value, child) {
                if (value == null) {
                  return Container(
                    width: width,
                    height: height * .8,
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: height * .03,
                        iOSVersionStyle:
                            CupertinoActivityIndicatorIOSVersionStyle.iOS14,
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${getTranslated(context, "publication")}",
                            style: headingStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .05,
                      ),
                      Row(
                        children: [
                          Text(
                            "${getTranslated(context, "sale")}",
                            style: headingStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .06,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .88,
                            height: height * .15,
                            child: PieChart(
                              showLegend: true,
                              values: saleCount,
                              //  [15, 70, 20],
                              labels: label,
                              labelColor: Colors.white,
                              // [
                              //   "Label1",
                              //   "Label2",
                              //   "Label3",
                              //   "Label4",
                              //   "Label5"
                              // ],
                              sliceFillColors: [
                                Colors.orange,
                                mainColor,
                                Colors.teal[700],
                              ],
                              legendTextSize: 6,
                              animationDuration: Duration(milliseconds: 1500),
                              legendPosition: LegendPosition.Right,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${getTranslated(context, "Rent")}",
                            style: headingStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .06,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .85,
                            height: height * .15,
                            child: PieChart(
                              showLegend: true,
                              values: rentCount,
                              //  [15, 70, 20],
                              labels: label,
                              // [
                              //   "Label1",
                              //   "Label2",
                              //   "Label3",
                              //   "Label4",
                              //   "Label5"
                              // ],
                              sliceFillColors: [
                                Colors.orange,
                                mainColor,
                                Colors.teal[700],
                              ],
                              legendTextSize: 6,
                              animationDuration: Duration(milliseconds: 1500),
                              legendPosition: LegendPosition.Right,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      Row(
                        children: [
                          Text(
                            "${getTranslated(context, "listingType")}",
                            style: headingStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      bottomOptions(),
                      SizedBox(
                        height: height * .03,
                      ),
                      Row(
                        children: [
                          Text(
                            "${getTranslated(context, "topLead")}",
                            style: headingStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      Row(
                        children: [
                          Text(
                            "${getTranslated(context, "sale")}",
                            style: headingStyle.copyWith(
                                fontSize: height * .015, color: Colors.grey),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * .02),
                            width: width * .04,
                            height: height * .04,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.blue),
                          ),
                          SizedBox(
                            width: width * .03,
                          ),
                          Text(
                            "${getTranslated(context, "listingType")}",
                            style: headingStyle.copyWith(
                                fontSize: height * .015, color: Colors.grey),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * .02),
                            width: width * .04,
                            height: height * .04,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.purple),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * .02),
                            width: width * .92,
                            height: height * .4,
                            child: BezierChart(
                              bezierChartScale: BezierChartScale.MONTHLY,
                              fromDate: fromDate,
                              toDate: toDate,
                              selectedDate: fromDate,
                              series: [
                                BezierLine(
                                    label: "Rent",
                                    lineColor: Colors.purple,
                                    onMissingValue: (dateTime) {
                                      if (dateTime.year.isEven) {
                                        return 0.0;
                                      }
                                      return 5.0;
                                    },
                                    data: rentData
                                    // [
                                    //   DataPoint<DateTime>(
                                    //       value: 10, xAxis: date1),
                                    //   DataPoint<DateTime>(
                                    //       value: 100, xAxis: date2),
                                    //   DataPoint<DateTime>(
                                    //       value: 200, xAxis: date3),
                                    //   DataPoint<DateTime>(value: 0, xAxis: date4),
                                    //   DataPoint<DateTime>(
                                    //       value: 10, xAxis: date5),
                                    //   DataPoint<DateTime>(
                                    //       value: 47, xAxis: date6),
                                    // ],
                                    ),
                                BezierLine(
                                    label: "Sale",
                                    lineColor: Colors.blue,
                                    onMissingValue: (dateTime) {
                                      if (dateTime.month.isEven) {
                                        return 0.0;
                                      }
                                      return 3.0;
                                    },
                                    data: saleData
                                    // [
                                    //   DataPoint<DateTime>(
                                    //       value: 20, xAxis: date1),
                                    //   DataPoint<DateTime>(
                                    //       value: 100, xAxis: date2),
                                    //   DataPoint<DateTime>(
                                    //       value: 150, xAxis: date3),
                                    //   DataPoint<DateTime>(
                                    //       value: 30, xAxis: date4),
                                    //   DataPoint<DateTime>(
                                    //       value: 45, xAxis: date5),
                                    //   DataPoint<DateTime>(
                                    //       value: 45, xAxis: date6),
                                    // ],
                                    ),
                              ],
                              config: BezierChartConfig(
                                displayYAxis: true,
                                stepsYAxis: 10,
                                updatePositionOnTap: true,
                                showDataPoints: true,
                                verticalLineFullHeight: true,
                                backgroundColor: Colors.white,
                                verticalIndicatorStrokeWidth: 3.0,
                                displayLinesXAxis: true,
                                xAxisTextStyle: headingStyle.copyWith(
                                    fontSize: 10, color: Colors.black),
                                yAxisTextStyle: headingStyle.copyWith(
                                    fontSize: 10, color: Colors.black),
                                verticalIndicatorColor: Colors.black26,
                                showVerticalIndicator: true,
                                verticalIndicatorFixedPosition: true,
                                backgroundGradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                footerHeight: height * .08,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget bottomOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "${getTranslated(context, "sale")}: ${saleCount.length}",
          style: headingStyle.copyWith(
              fontSize: height * .015, color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.only(left: width * .01, right: width * .01),
          color: Colors.grey,
          height: height * .02,
          width: 1.5,
        ),
        Text(
          "${getTranslated(context, "Rent")}: ${rentCount.length}",
          style: headingStyle.copyWith(
              fontSize: height * .015, color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.only(left: width * .01, right: width * .01),
          color: Colors.grey,
          height: height * .02,
          width: 1.5,
        ),
        Text(
          "${getTranslated(context, "cRent")}: ${_dataNotifier.value.barchartModel.commercialrentCount.length}",
          style: headingStyle.copyWith(
              fontSize: height * .015, color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.only(left: width * .01, right: width * .01),
          color: Colors.grey,
          height: height * .02,
          width: 1.5,
        ),
        Text(
          "${getTranslated(context, "cSell")}: ${_dataNotifier.value.barchartModel.commercialsaleCount.length}",
          style: headingStyle.copyWith(
              fontSize: height * .015, color: Colors.grey),
        ),
      ],
    );
  }
}
