import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';

class PropertyDetail extends StatefulWidget {
  var id;
  PropertyDetail({@required this.id});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PropertyDetail();
  }
}

class _PropertyDetail extends State<PropertyDetail> {
  var width, height;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<PropertyResult> _dataNotifier =
      ValueNotifier<PropertyResult>(null);
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(231313, 321321),
    zoom: 18.4746,
  );
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = LatLng(321, 321);
  Set<Marker> marker = new Set();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationNotifier().fetchNotifications(context);
    print("properrt id: ${widget.id}");
    BaseHelper()
        .getPropertydetail(
            context: context, id: widget.id, notifier: _dataNotifier)
        .then((value) {
      setState(() {
        _center = LatLng(double.parse(_dataNotifier.value.lat.toString()),
            double.parse(_dataNotifier.value.lng.toString()));
        _kGooglePlex = CameraPosition(
          target: LatLng(double.parse(_dataNotifier.value.lat.toString()),
              double.parse(_dataNotifier.value.lng.toString())),
          zoom: 18.4746,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      // appBar: CustomAppBar(
      //   height: height * .08,
      //   screen: 0,
      //   count: 0,
      //   title: "Property Detail",
      //   appointment: false,
      //   support: true,
      //   width: width,
      //   home: false,
      // ),
      backgroundColor: white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            brightness: Brightness.light,
            leading: GestureDetector(
              onTap: () {
                AppRoutes.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: white,
                size: height * .035,
              ),
            ),
            elevation: 0,
            iconTheme: IconThemeData(
              color: mainColor,
            ),
            backgroundColor: white,
            expandedHeight: height * 0.34,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(
              //   '\Ref Id: 2131',
              //   style: headingStyle.copyWith(
              //     color: Colors.black,
              //   ),
              // ),
              centerTitle: true,
              background: _buildPortfolio(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * .04,
                  right: width * .04,
                  top: height * .02,
                  bottom: height * .02),
              child: Container(
                width: width,
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
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    User.userData.lang == "en"
                                        ? "${value.title}"
                                        : value.titleAr == null ||
                                                value.titleAr == "null" ||
                                                value.titleAr.toString().isEmpty
                                            ? "${value.title}"
                                            : "${value.titleAr}",
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: headingStyle.copyWith(
                                        fontSize: height * .02,
                                        color: mainColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${value.price} QAR / ${value.rentalPeriod}",
                                  maxLines: 2,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.center,
                                  style: headingStyle.copyWith(
                                      fontSize: height * .022,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                // Text(
                                //   "For Rent",
                                //   maxLines: 2,
                                //   textAlign: TextAlign.center,
                                //   style: headingStyle.copyWith(
                                //     fontSize: height * .018,
                                //     color: Colors.black,
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 1,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width * .02)),
                                  child: Container(
                                    width: width * .89,
                                    height: height * .15,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(width * .03),
                                        color: Colors.white),
                                    padding: EdgeInsets.all(width * .02),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            types(
                                                "images/home.png",
                                                User.userData.lang == "en"
                                                    ? "${value.propertyTypeName}"
                                                    : value.propertyTypeAr ==
                                                            null
                                                        ? "${value.propertyTypeName}"
                                                        : "${value.propertyTypeAr}"),
                                            types("images/area.png",
                                                "${value.area} Sqm"),
                                            types("images/bed.png",
                                                "${getTranslated(context, "Beds")}: ${value.beds}"),
                                            types("images/bath.png",
                                                "${getTranslated(context, "Baths")}: ${value.baths}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: height * .02,
                            // ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * .02,
                                ),
                                Text(
                                  "${getTranslated(context, "amenities")}",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: headingStyle.copyWith(
                                      fontSize: height * .022,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            value.ameneties == null ||
                                    value.ameneties.toString().isEmpty
                                ? Container()
                                : Row(
                                    children: [
                                      Container(
                                        width: width * .89,
                                        // padding: EdgeInsets.all(width * .02),
                                        // margin: EdgeInsets.only(
                                        //     left: width * .02, right: width * .02),
                                        color: Colors.white,
                                        // height: MediaQuery.of(context).size.height * .15,
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            mainAxisSpacing: height * .01,
                                            crossAxisSpacing: height * .01,
                                            childAspectRatio:
                                                height / width * .78,
                                          ),
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                                height: height * .04,
                                                padding: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  border: Border.all(
                                                      color: mainColor),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //       color: Colors.black,
                                                  //       spreadRadius: 0.2,
                                                  //       blurRadius: 0.2)
                                                  // ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * .02),
                                                  // border: Border.all(
                                                  //     color:
                                                  //         Theme.of(context).primaryColor,
                                                  //     width: 2),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    User.userData.lang == "en"
                                                        ? "${value.ameneties[index].name}"
                                                        : value.ameneties[index]
                                                                    .arName ==
                                                                null
                                                            ? "${value.ameneties[index].name}"
                                                            : "${value.ameneties[index].arName}",
                                                    maxLines: 2,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        headingStyle.copyWith(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: mainColor),
                                                  ),
                                                ));
                                          },
                                          itemCount: value.ameneties.length,
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * .02,
                                ),
                                Text(
                                  "${getTranslated(context, "Description")}",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: headingStyle.copyWith(
                                      fontSize: height * .022,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              textDirection: User.userData.lang == "en"
                                  ? TextDirection.ltr
                                  : value.descriptionAr == null
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                              children: [
                                SizedBox(
                                  width: width * .02,
                                ),
                                Flexible(
                                    child: Text(
                                  User.userData.lang == "en"
                                      ? "${value.description}"
                                      : value.descriptionAr == null
                                          ? "${value.description}"
                                          : "${value.descriptionAr}",
                                  style: headingStyle.copyWith(
                                      fontSize: height * .015,
                                      color: Colors.grey),
                                ))
                              ],
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * .02,
                                ),
                                Text(
                                  "${getTranslated(context, "callDescription")}",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: headingStyle.copyWith(
                                      fontSize: height * .022,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset(
                                //   "images/map.png",
                                //   width: width * .88,
                                //   fit: BoxFit.fill,
                                //   height: height * .2,
                                // )
                                googleMap()
                              ],
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                          ],
                        );
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget googleMap() {
    return Container(
      height: height * .22,
      width: width * .88,
      child: GoogleMap(
        mapType: MapType.normal,

        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .25),
        markers: marker,
        onCameraMove: (move) async {
          // setState(() {
          //   _center = move.target;
          // });
          // var first;
          // final coordinates =
          //     new Coordinates(_center.latitude, _center.longitude);
          // var addresses = await Geocoder.local
          //     .findAddressesFromCoordinates(coordinates);
          // setState(() {
          //   first = addresses.first;
          //   address.text = first.addressLine;
          //   // User.userData.address =
          //   //     addresses.first.addressLine;
          //   User.userData.homeLat = _center.latitude;
          //   User.userData.homeLong = _center.longitude;
          // });
          // print(address);
          setState(() {
            // marker.clear();

            // marker.add(
            //   Marker(
            //     markerId: MarkerId("Property Location"),
            //     position: _center,
            //   ),
            // );
            // circles
            //   ..add(Circle(
            //       circleId: CircleId("abcd"),
            //       radius: slidervalue,
            //       strokeColor: Colors.green,
            //       center: move.target));
          });
        },
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            marker.clear();

            marker.add(
              Marker(
                markerId: MarkerId("Product Location"),
                position: _center,
              ),
            );
            // circles
            //   ..add(Circle(
            //       circleId: CircleId("abcd"),
            //       radius: slidervalue,
            //       strokeColor: Colors.green,
            //       center: move.target));
          });
          _controller.complete(controller);
        },
        //circles: circles,
      ),
    );
  }

  Widget _propertyDescription(value1) {
    return Container(
      margin: EdgeInsets.only(right: width * .03, left: width * .03),
      width: width * .4,
      color: Colors.white,
      height: height * .06,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: width * .03),
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black),
          ),
          Flexible(
            child: Text(
              "$value1",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: headingStyle.copyWith(
                  fontSize: height * .017,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }

  Widget types(image, value) {
    return Column(
      children: [
        Image.asset(
          "$image",
          color: mainColor,
          fit: BoxFit.contain,
          width: width * .15,
          height: height * .05,
        ),
        SizedBox(
          height: height * .02,
        ),
        Text(
          "$value",
          style: headingStyle.copyWith(
              fontSize: height * .013,
              color: Colors.grey,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _buildPortfolio() {
    return Container(
      // margin: EdgeInsets.only(top: height * .0),
      height: height * 0.45,
      width: width,
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     // Colors.black.withOpacity(0.4),
          //     // Colors.black.withOpacity(0.4),
          //   ],
          // ),
          color: white),
      // margin: EdgeInsets.only(top: 15),
      child: _dataNotifier.value == null
          ? Center(
              child: CupertinoActivityIndicator(
                radius: height * .02,
                iOSVersionStyle:
                    CupertinoActivityIndicatorIOSVersionStyle.iOS14,
              ),
            )
          : _dataNotifier.value.productImages == null ||
                  _dataNotifier.value.productImages.toString().isEmpty
              ? Container(
                  width: width,
                  margin: EdgeInsets.only(top: height * .03),
                  height: height * .12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * .02),
                      image: DecorationImage(
                        image: AssetImage("images/property.jpg"),
                        fit: BoxFit.fill,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.1), BlendMode.darken),
                      )),
                  padding: EdgeInsets.all(width * .02),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            // margin: EdgeInsets.only(top: ),
                            width: width * .25,
                            height: height * .04,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * .02),
                                color: white),
                            child: Center(
                              child: Text(
                                _dataNotifier.value.published == 0
                                    ? "${getTranslated(context, "active")}"
                                    : "${getTranslated(context, "inActive")}",
                                style: headingStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: mainColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : Swiper(
                  loop: false,
                  itemWidth: width,

                  itemHeight: height * 0.40,
                  // index: 1,
                  itemCount: _dataNotifier.value.productImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // open(context, index);
                      },
                      child: Container(
                        width: width,
                        margin: EdgeInsets.only(top: height * .03),
                        height: height * .12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * .02),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "${_dataNotifier.value.baseUrl}${_dataNotifier.value.productImages[index].imagePath}"),
                              //  AssetImage("images/property.jpg"),
                              fit: BoxFit.fill,
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.1),
                                  BlendMode.darken),
                            )),
                        padding: EdgeInsets.all(width * .02),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * .04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: width * .25,
                                  height: height * .04,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * .02),
                                      color: white),
                                  child: Center(
                                    child: Text(
                                      _dataNotifier.value.published == 0
                                          ? "${getTranslated(context, "active")}"
                                          : "${getTranslated(context, "inActive")}",
                                      style: headingStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: mainColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  viewportFraction: 1,
                  pagination: new SwiperPagination(
                      alignment: Alignment(0, 0.9),
                      builder: DotSwiperPaginationBuilder(
                          color: Colors.white, activeColor: mainColor)),
                  scale: 0.8,
                  layout: SwiperLayout.DEFAULT,
                ),
    );
  }
}
