import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:property_broker/helper/apisscreen.dart';
import 'package:property_broker/helper/appointmentorrequestnotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/staffmodel.dart';
import 'package:property_broker/screen.dart/addStaff.dart';
import 'package:property_broker/screen.dart/propertyDetail.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/const.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/custombutton.dart';

class ExpansionCard extends StatefulWidget {
  bool staff = false;
  bool staffCard = false;
  var startDate, endDate;
  StaffResult staffResult;
  ExpansionCard(
      {@required this.staff,
      @required this.staffCard,
      @required this.startDate,
      @required this.endDate,
      @required this.staffResult});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _card();
  }
}

class _card extends State<ExpansionCard> {
  var width, height;

  List status = [1, 2, 3, 4, 5, 6, 7, 8];
  var selectedStatus = 1, selectedStatusName = "";
  List statusName = [
    "Select Status",
    "New",
    "Open",
    "In Progress",
    "Open Deal",
    "Unqualified",
    "Attempt to contact",
    "Connected",
    "Bad Timing"
  ];
  bool val = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: height * .02),
      width: width * .85,
      color: Colors.white,
      child: ExpansionTile(
        trailing: Icon(
          val == true ? Icons.arrow_drop_down_sharp : Icons.arrow_right,
          color: Colors.grey,
        ),
        leading: widget.staffCard == false
            ? null
            : Container(
                width: width * .15,
                height: height * .18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * .03),
                  image: DecorationImage(
                      image: widget.staffResult.profileImage == null ||
                              widget.staffResult.profileImage.toString().isEmpty
                          ? AssetImage("images/logoName.png")
                          : NetworkImage(
                              "${API.Image_Path}${widget.staffResult.profileImage}"),
                      fit: BoxFit.fill),
                ),
              ),
        onExpansionChanged: (value) {
          setState(() {
            value = !value;
            val = !val;
          });
        },
        subtitle: Text(
            // "${widget.staffResult.date.toString()}"
            widget.staffCard == true
                ? ""
                : "${DateTime.parse(widget.staffResult.date.toString()).day}/${DateTime.parse(widget.staffResult.date.toString()).month}/${DateTime.parse(widget.staffResult.date.toString()).year}"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width * .25,
              child: Text(
                "${widget.staffResult.name}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: headingStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: height * .02),
              ),
            ),
            Flexible(
              flex: 2,
              child: Text(
                "${widget.staffResult.phone}",
                style: headingStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: height * .015),
              ),
            ),
            widget.staffCard == true
                ? SizedBox(
                    height: 0,
                    width: 0,
                  )
                : Flexible(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        _showModal(widget.staffResult.id);
                      },
                      child: Text(
                        widget.staffResult.status == "1"
                            ? "New"
                            : widget.staffResult.status == "2"
                                ? "Open"
                                : widget.staffResult.status == "3"
                                    ? "In Progress"
                                    : widget.staffResult.status == "4"
                                        ? "Open Deal"
                                        : widget.staffResult.status == "5"
                                            ? "Unqualifies"
                                            : widget.staffResult.status == "6"
                                                ? "Attempted to Contact"
                                                : widget.staffResult.status ==
                                                        "7"
                                                    ? "Connected"
                                                    : "Bad Timing",
                        style: headingStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontSize: height * .015),
                      ),
                    ),
                  ),
            Flexible(
              flex: 1,
              child: Text(
                "${widget.staffResult.zone}",
                style: headingStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: height * .015),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: height * .01, left: width * .04, right: width * .04),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${widget.staffResult.email}",
                      style: headingStyle.copyWith(
                          color: Colors.black, fontSize: height * .015),
                    ),
                  ],
                ),
                widget.staffResult.address.toString().isEmpty
                    ? Container()
                    : SizedBox(
                        height: height * .02,
                      ),
                widget.staffResult.address.toString().isEmpty
                    ? Container()
                    : Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${widget.staffResult.address}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: headingStyle.copyWith(
                                  color: Colors.black, fontSize: height * .015),
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "${widget.staffResult.detail}",
                        style: headingStyle.copyWith(
                            color: Colors.black, fontSize: height * .015),
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
                    widget.staff == true
                        ? InkWell(
                            splashColor: mainColor,
                            onTap: () {
                              AppRoutes.push(
                                  context,
                                  AddStaff(
                                      screen: 1,
                                      staffResult: widget.staffResult));
                            },
                            child: Card(
                              color: white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * .02),
                              ),
                              child: Container(
                                  width: width * .4,
                                  height: height * .06,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              .02),
                                      color: white,
                                      border: Border.all(color: white)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.edit,
                                            color: mainColor,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: width * .015,
                                          ),
                                          Text(
                                            "${getTranslated(context, "edit")}",
                                            style: headingStyle.copyWith(
                                                color: mainColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              AppRoutes.push(
                                  context,
                                  PropertyDetail(
                                    id: widget.staffResult.propertyId,
                                  ));
                            },
                            child: CustomButton(
                              width: width * .4,
                              height: height * .06,
                              textColor: mainColor,
                              color: Colors.white,
                              title:
                                  "${getTranslated(context, "viewProperty")}",
                            ),
                          ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showModal(id) {
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

                            // selectedZoneLocation = null;
                          });
                          BaseHelper()
                              .changeLead(id, selectedStatus, context)
                              .then((value) {
                            print("delete response: $value");
                            if (value['error'] == false) {
                              AppointmentNotifier().fetchData(
                                  context,
                                  0,
                                  "${widget.startDate.year}-${widget.startDate.month}-${widget.startDate.day}",
                                  "${widget.endDate.year}-${widget.endDate.month}-${widget.endDate.day}",
                                  selectedStatus);

                              // constValues().toast("${value['message']}", context);
                            } else {
                              constValues()
                                  .toast("${value['message']}", context);
                            }
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
