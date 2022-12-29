import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_chip_select/flutter_multi_chip_select.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:property_broker/helper/addressnotifier.dart';
import 'package:property_broker/helper/notificationnotifier.dart';
import 'package:property_broker/helper/profilenotifier.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/models/typesmodel.dart';
import 'package:property_broker/models/userdatamodel.dart';
import 'package:property_broker/screen.dart/homescreen.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/const.dart';
import 'package:property_broker/utils/routes.dart';
import 'package:property_broker/utils/textstyle.dart';
import 'package:property_broker/widgets/customAppbar.dart';
import 'package:property_broker/widgets/custombutton.dart';
import 'package:property_broker/widgets/customdrawer.dart';
import 'package:property_broker/widgets/customtextfield.dart';
import 'package:property_broker/widgets/propertytextfield.dart';

class EditProperty extends StatefulWidget {
  var propertyId;
  EditProperty({@required this.propertyId});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactRequest();
  }
}

class _ContactRequest extends State<EditProperty> {
  var width, height;
  var selectedListing,
      selectedProperty,
      selectedZone,
      selectedZoneLocation,
      selectedFurnish;
  List amenetiesId = List();
  List<ZoneResult> zone = [];
  List<ZoneLocationResult> zoneLocation = [];
  List<ListinTypes> listingType = [];
  List<FurnishTypes> furnishType = [];
  File imageFile;
  var _apiProvider;
  ValueNotifier<List> _image = ValueNotifier<List>([]);
  List<String> images = List<String>();
  List<String> imagesId = List<String>();
  List<PropertyTypes> propertyTypes = [];
  //  amenetyTypes = [];
  final multiSelectKey = GlobalKey<MultiSelectDropdownState>();
  List<AmenetiesTypes> menuItems = [];
  ValueNotifier<TypesModel> _dataNotifier = ValueNotifier<TypesModel>(null);
  ValueNotifier<PropertyResult> propertyNotifier =
      ValueNotifier<PropertyResult>(null);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  ScrollController _scrollController = ScrollController();
  bool loading;
  BitmapDescriptor sourceIcon;
  double _lat, _lng;
  Completer<GoogleMapController> _mapController = Completer();
  TextEditingController title = TextEditingController();
  TextEditingController titleAr = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController descriptionAr = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController bed = TextEditingController();
  TextEditingController bath = TextEditingController();
  TextEditingController ref = TextEditingController();
  TextEditingController youtube = TextEditingController();
  TextEditingController threesixty = TextEditingController();
  TextEditingController address = TextEditingController();
  bool publish = false, requestTranslation = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("property id: ${widget.propertyId}");
    // ProfileNotifier().setProfile(context);
    BaseHelper().getTypes(_dataNotifier, context).then((value) {
      setState(() {
        listingType = value.listingType;
        propertyTypes = value.propertyType;
        menuItems = value.amenityType;
        furnishType = value.furnishType;
        zoneLocation = value.zoneLocation;
        zone = value.zone;
      });
      BaseHelper()
          .getPropertydetail(
              context: context,
              id: widget.propertyId,
              notifier: propertyNotifier)
          .then((value) {
        setState(() {
          title.text = propertyNotifier.value.title.toString();
          titleAr.text = propertyNotifier.value.titleAr.toString();
          description.text = propertyNotifier.value.description.toString();
          descriptionAr.text = propertyNotifier.value.descriptionAr.toString();
          price.text = propertyNotifier.value.price.toString();
          area.text = propertyNotifier.value.area.toString();
          bed.text = propertyNotifier.value.beds.toString();
          bath.text = propertyNotifier.value.baths.toString();
          ref.text = propertyNotifier.value.refNo.toString();
          youtube.text = propertyNotifier.value.youtubeLink.toString();
          address.text = propertyNotifier.value.address.toString();
          _lat = double.parse(propertyNotifier.value.lat.toString());
          _lng = double.parse(propertyNotifier.value.lng.toString());
          setState(() {
            var id = new Random();

            var markerIdVal = id.toString();
            final MarkerId markerId = MarkerId(markerIdVal);
            markers[markerId] = Marker(
              markerId: markerId,
              icon: sourceIcon,
              position: LatLng(
                _lat,
                _lng,
              ),
            );
          });
          if (propertyNotifier.value.productImages == null ||
              propertyNotifier.value.productImages.toString().isEmpty) {
          } else {
            for (int i = 0;
                i < propertyNotifier.value.productImages.length;
                i++) {
              _image.value.add(
                  "${propertyNotifier.value.baseUrl}${propertyNotifier.value.productImages[i].imagePath}");
              images.add(
                  "${propertyNotifier.value.baseUrl}${propertyNotifier.value.productImages[i].imagePath}");
              imagesId.add("${propertyNotifier.value.productImages[i].id}");
            }
          }

          if (propertyNotifier.value.ameneties == null) {
          } else {
            for (int i = 0; i < propertyNotifier.value.ameneties.length; i++) {
              multiSelectKey.currentState.result.add(User.userData.lang == "en"
                  ? propertyNotifier.value.ameneties[i].name
                  : propertyNotifier.value.ameneties[i].arName);
            }
          }

          for (int i = 0; i < _dataNotifier.value.listingType.length; i++) {
            if (_dataNotifier.value.listingType[i].id ==
                propertyNotifier.value.listingId) {
              selectedListing = _dataNotifier.value.listingType[i];
              break;
            }
          }
          for (int i = 0; i < _dataNotifier.value.zone.length; i++) {
            if (_dataNotifier.value.zone[i].id ==
                propertyNotifier.value.zoneId) {
              selectedZone = _dataNotifier.value.zone[i];
              break;
            }
          }
          for (int i = 0; i < _dataNotifier.value.zoneLocation.length; i++) {
            if (_dataNotifier.value.zoneLocation[i].id ==
                propertyNotifier.value.zoneLocationId) {
              selectedZoneLocation = _dataNotifier.value.zoneLocation[i];
              break;
            }
          }
          for (int i = 0; i < _dataNotifier.value.propertyType.length; i++) {
            if (_dataNotifier.value.propertyType[i].id ==
                propertyNotifier.value.propertyTypeId) {
              selectedProperty = _dataNotifier.value.propertyType[i];
              break;
            }
          }
          for (int i = 0; i < _dataNotifier.value.furnishType.length; i++) {
            if (_dataNotifier.value.furnishType[i].id ==
                propertyNotifier.value.furnishTypeId) {
              selectedFurnish = _dataNotifier.value.furnishType[i];
              break;
            }
          }
          // selectedProperty=propertyNotifier.value.pr

          // _center = LatLng(double.parse(_dataNotifier.value.lat.toString()),
          //     double.parse(_dataNotifier.value.lng.toString()));
          // _kGooglePlex = CameraPosition(
          //   target: LatLng(double.parse(_dataNotifier.value.lat.toString()),
          //       double.parse(_dataNotifier.value.lng.toString())),
          //   zoom: 18.4746,
          // );
        });
      });
    });
  }

  static ValueNotifier<UserDataModel> profileNotifiers =
      ValueNotifier<UserDataModel>(null);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    int count = NotificationNotifier.count;
    profileNotifiers.value = ProfileNotifier.profileNotifiers.value;
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: CustomAppBar(
        notificationCount: count,
        height: height * .08,
        screen: 0,
        count: 0,
        title: "${getTranslated(context, "editProperty")}",
        appointment: false,
        support: false,
        width: width,
        notifications: true,
        home: false,
      ),
      drawer: BuyerDrawer(),
      body: propertyNotifier.value == null
          ? Center(
              child: CupertinoActivityIndicator(
                radius: height * .03,
                iOSVersionStyle:
                    CupertinoActivityIndicatorIOSVersionStyle.iOS14,
              ),
            )
          : Container(
              width: width,
              // height: height,
              padding: EdgeInsets.all(width * .03),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * .03,
                        ),
                        header(),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${getTranslated(context, "Publish")}",
                              style: headingStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor),
                            ),
                            Switch(
                              onChanged: (bool value) {
                                setState(() {
                                  publish = value;
                                });
                              },
                              activeColor: mainColor,
                              // inactiveThumbColor: Colors.grey,
                              activeTrackColor: mainColor,
                              inactiveTrackColor: Colors.grey,
                              value: publish,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${getTranslated(context, "requestTranslation")}",
                              style: headingStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor),
                            ),
                            Switch(
                              onChanged: (bool value) {
                                setState(() {
                                  requestTranslation = value;
                                });
                              },
                              activeColor: mainColor,
                              // inactiveThumbColor: Colors.grey,
                              activeTrackColor: mainColor,
                              inactiveTrackColor: Colors.grey,
                              value: requestTranslation,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          children: [
                            Text(
                              "${getTranslated(context, "selectZone")}",
                              style: headingStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: mainColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(top: height * .02),
                              width: width * .9,
                              height: height * .06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * .02),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]),
                              ),
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .03,
                                  right:
                                      MediaQuery.of(context).size.width * .02),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  iconEnabledColor: mainColor,
                                  hint: Row(
                                    children: [
                                      Text(
                                        "${getTranslated(context, "selectZone")}",
                                      ),
                                      Text(
                                        "*",
                                        style: headingStyle.copyWith(
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                  items: zone.map((item) {
                                    return new DropdownMenuItem(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(User.userData.lang == "en"
                                              ? "${item.name}"
                                              : "${item.arName}"),
                                        ],
                                      ),
                                      value: item,
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      selectedZone = newVal;
                                      selectedZoneLocation = null;
                                    });
                                    // print(_propertyTypeSelected);
                                  },
                                  value: selectedZone == null
                                      ? null
                                      : selectedZone,
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        selectedZone == null
                            ? Container()
                            : SizedBox(
                                height: height * .02,
                              ),
                        selectedZone == null
                            ? Container()
                            : Row(
                                children: [
                                  Text(
                                    "${getTranslated(context, "selectZoneLocation")}",
                                    style: headingStyle.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: mainColor),
                                  ),
                                ],
                              ),
                        selectedZone == null
                            ? Container()
                            : SizedBox(
                                height: height * .02,
                              ),
                        selectedZone == null
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(top: height * .02),
                                    width: width * .9,
                                    height: height * .06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              .02),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[200]),
                                    ),
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                .02),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        iconEnabledColor: mainColor,
                                        hint: Row(
                                          children: [
                                            Text(
                                              "${getTranslated(context, "selectZoneLocation")}",
                                            ),
                                            Text(
                                              "*",
                                              style: headingStyle.copyWith(
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                        items: zoneLocation.where((element) {
                                          if (element.id == selectedZone.id) {
                                            return true;
                                          } else {
                                            return false;
                                          }
                                        }).map((item) {
                                          return new DropdownMenuItem(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(User.userData.lang == "en"
                                                    ? "${item.name}"
                                                    : "${item.arName}"),
                                              ],
                                            ),
                                            value: item,
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            selectedZoneLocation = newVal;
                                          });
                                          // print(_propertyTypeSelected);
                                        },
                                        value: selectedZoneLocation == null
                                            ? null
                                            : selectedZoneLocation,
                                        dropdownColor: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          children: [
                            Text(
                              "${getTranslated(context, "selectListing")}",
                              style: headingStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: mainColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(top: height * .02),
                              width: width * .9,
                              height: height * .06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * .02),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]),
                              ),
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .03,
                                  right:
                                      MediaQuery.of(context).size.width * .02),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  iconEnabledColor: mainColor,
                                  hint: Row(
                                    children: [
                                      Text(
                                          "${getTranslated(context, "selectListing")}"),
                                      Text(
                                        "*",
                                        style: headingStyle.copyWith(
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                  items: listingType.map((item) {
                                    return new DropdownMenuItem(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(User.userData.lang == "en"
                                              ? "${item.name}"
                                              : "${item.arName}"),
                                        ],
                                      ),
                                      value: item,
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      selectedListing = newVal;
                                    });
                                    // print(_propertyTypeSelected);
                                  },
                                  value: selectedListing == null
                                      ? null
                                      : selectedListing,
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          children: [
                            Text(
                              "${getTranslated(context, "selectProperty")}",
                              style: headingStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: mainColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(top: height * .02),
                              width: width * .9,
                              height: height * .06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * .02),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]),
                              ),
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .03,
                                  right:
                                      MediaQuery.of(context).size.width * .02),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  iconEnabledColor: mainColor,
                                  hint: Row(
                                    children: [
                                      Text(
                                          "${getTranslated(context, "selectProperty")}"),
                                      Text(
                                        "*",
                                        style: headingStyle.copyWith(
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                  items: propertyTypes.map((item) {
                                    return new DropdownMenuItem(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(User.userData.lang == "en"
                                              ? "${item.name}"
                                              : "${item.arName}"),
                                        ],
                                      ),
                                      value: item,
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      selectedProperty = newVal;
                                    });
                                    // print(_propertyTypeSelected);
                                  },
                                  value: selectedProperty == null
                                      ? null
                                      : selectedProperty,
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          children: [
                            Text(
                              "${getTranslated(context, "selectFurnish")}",
                              style: headingStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: mainColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(top: height * .02),
                              width: width * .9,
                              height: height * .06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * .02),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]),
                              ),
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .03,
                                  right:
                                      MediaQuery.of(context).size.width * .02),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  iconEnabledColor: mainColor,
                                  hint: Row(
                                    children: [
                                      Text(
                                          "${getTranslated(context, "selectFurnish")}"),
                                      Text(
                                        "*",
                                        style: headingStyle.copyWith(
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                  items: furnishType.map((item) {
                                    return new DropdownMenuItem(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(User.userData.lang == "en"
                                              ? "${item.name}"
                                              : "${item.arName}"),
                                        ],
                                      ),
                                      value: item,
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      selectedFurnish = newVal;
                                    });
                                    // print(_propertyTypeSelected);
                                  },
                                  value: selectedFurnish == null
                                      ? null
                                      : selectedFurnish,
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              controller: title,
                              width: width * .9,
                              description: false,
                              keyboardTypenumeric: false,
                              number: false,
                              title: "${getTranslated(context, "Title")}*",
                              height: height * .06,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              description: false,
                              controller: titleAr,
                              width: width * .9,
                              keyboardTypenumeric: false,
                              number: false,
                              title: "${getTranslated(context, "titleArabic")}",
                              height: height * .06,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              controller: description,
                              width: width * .9,
                              description: true,
                              keyboardTypenumeric: false,
                              number: false,
                              title:
                                  "${getTranslated(context, "Description")}*",
                              height: height * .15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              controller: descriptionAr,
                              width: width * .9,
                              description: true,
                              keyboardTypenumeric: false,
                              number: false,
                              title:
                                  "${getTranslated(context, "descriptionArabic")}",
                              height: height * .15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              description: false,
                              controller: price,
                              width: width * .9,
                              keyboardTypenumeric: true,
                              number: false,
                              title: "${getTranslated(context, "Price")}*",
                              height: height * .06,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              description: false,
                              controller: area,
                              width: width * .9,
                              keyboardTypenumeric: true,
                              number: false,
                              title: "${getTranslated(context, "Area sq")}*",
                              height: height * .06,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PropertyTextField(
                              controller: bed,
                              width: width * .42,
                              description: false,
                              keyboardTypenumeric: true,
                              number: false,
                              title: "${getTranslated(context, "Beds")}",
                              height: height * .06,
                            ),
                            PropertyTextField(
                              controller: bath,
                              width: width * .42,
                              description: false,
                              keyboardTypenumeric: true,
                              number: false,
                              title: "${getTranslated(context, "Baths")}",
                              height: height * .06,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              description: false,
                              controller: ref,
                              width: width * .9,
                              keyboardTypenumeric: true,
                              number: false,
                              title:
                                  "${getTranslated(context, "brokerReference")}",
                              height: height * .06,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: width * .9,
                                height: height * .08,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * .02),
                                    border:
                                        Border.all(color: Colors.grey[200])),
                                padding: EdgeInsets.all(width * .02),
                                child: FlutterMultiChipSelect(
                                  key: multiSelectKey,
                                  elements: List.generate(
                                    menuItems.length,
                                    (index) => MultiSelectItem<String>.simple(
                                        actions: [
                                          // IconButton(
                                          //   icon: Icon(Icons.delete),
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       amenetiesId.removeAt(index);
                                          //       menuItems
                                          //           .remove(menuItems[index]);
                                          //     });
                                          //     print("Delete Call at: " +
                                          //         menuItems[index].toString());
                                          //   },
                                          // )
                                        ],
                                        title: User.userData.lang == "en"
                                            ? "${menuItems[index].name}"
                                            : "${menuItems[index].arName}",
                                        value:
                                            menuItems[index].name.toString()),
                                  ),
                                  label:
                                      "${getTranslated(context, "Select amentities")}",
                                  values: [],
                                )),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              description: false,
                              controller: youtube,
                              width: width * .9,
                              keyboardTypenumeric: false,
                              number: false,
                              title: "${getTranslated(context, "youtubeUrl")}",
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
                            PropertyTextField(
                              description: false,
                              controller: threesixty,
                              width: width * .9,
                              keyboardTypenumeric: false,
                              number: false,
                              title: "${getTranslated(context, "threeSixty")}",
                              height: height * .06,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: height * 0.04,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            getTranslated(context, "Upload Images"),
                            textScaleFactor: 1.1,
                            style: labelTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        ValueListenableBuilder(
                          valueListenable: _image,
                          builder: (context, value, child) {
                            return value.isEmpty
                                ? GestureDetector(
                                    child: Container(
                                      height: MediaQuery.of(context)
                                              .size
                                              .aspectRatio *
                                          90,
                                      width: MediaQuery.of(context)
                                              .size
                                              .aspectRatio *
                                          90,
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      _showDialog(context);
                                    },
                                  )
                                : Theme(
                                    data: ThemeData(
                                      highlightColor: mainColor,
                                      platform: TargetPlatform.android,
                                    ),
                                    child: Scrollbar(
                                      controller: _scrollController,
                                      isAlwaysShown: true,
                                      radius: Radius.circular(10),
                                      thickness: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height * 0.05),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              7,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 5),
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            itemCount: _image.value.length + 1,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return index == 0
                                                  ? GestureDetector(
                                                      child: Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius
                                                                .circular(MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .aspectRatio *
                                                                    5)),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    2.5),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7.5,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            8,
                                                        child: Icon(
                                                          Icons.add_a_photo,
                                                          color: mainColor,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        _showDialog(context);
                                                      },
                                                    )
                                                  : Container(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          borderRadius: BorderRadius
                                                              .circular(MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .aspectRatio *
                                                                  5)),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.5),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              7,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: Stack(
                                                        fit: StackFit.expand,
                                                        children: [
                                                          _image.value
                                                                  .toString()
                                                                  .contains(
                                                                      propertyNotifier
                                                                          .value
                                                                          .baseUrl)
                                                              ? Image.network(
                                                                  _image.value[
                                                                      index -
                                                                          1],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  _image.value[
                                                                      index -
                                                                          1],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child:
                                                                GestureDetector(
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        mainColor,
                                                                    borderRadius:
                                                                        BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(5))),
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                List<File>
                                                                    tempValue =
                                                                    [];
                                                                // tempValue.addAll(
                                                                //     _image.value);
                                                                // tempValue.removeAt(
                                                                //     index - 1);
                                                                if (_image
                                                                    .value[
                                                                        index -
                                                                            1]
                                                                    .contains(propertyNotifier
                                                                        .value
                                                                        .baseUrl)) {
                                                                  BaseHelper()
                                                                      .removeImage(
                                                                          imagesId[index -
                                                                              1],
                                                                          context)
                                                                      .then(
                                                                          (value) {
                                                                    print(
                                                                        "delete response: $value");
                                                                    if (value[
                                                                            'error'] ==
                                                                        false) {
                                                                      setState(
                                                                          () {
                                                                        _image
                                                                            .value
                                                                            .removeAt(index -
                                                                                1);
                                                                        images.removeAt(
                                                                            index -
                                                                                1);
                                                                        imagesId.removeAt(
                                                                            index -
                                                                                1);
                                                                      });
                                                                      // constValues().toast("${value['message']}", context);
                                                                    } else {
                                                                      constValues().toast(
                                                                          "${value['message']}",
                                                                          context);
                                                                    }
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    _image.value
                                                                        .removeAt(
                                                                            index -
                                                                                1);
                                                                    images.removeAt(
                                                                        index -
                                                                            1);
                                                                  });
                                                                }

                                                                // _image.value =
                                                                //     tempValue;
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PropertyTextField(
                              description: false,
                              controller: address,
                              width: width * .9,
                              keyboardTypenumeric: false,
                              number: false,
                              title: "${getTranslated(context, "Location")}*",
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
                            GestureDetector(
                                child: Container(
                                  width: width * .9,
                                  height: height * .25,
                                  child: AbsorbPointer(
                                    child: SizedBox(
                                      height: 180,
                                      child: GoogleMap(
                                        tiltGesturesEnabled: false,
                                        rotateGesturesEnabled: false,
                                        scrollGesturesEnabled: false,
                                        mapType: MapType.normal,
                                        myLocationEnabled: false,
                                        myLocationButtonEnabled: false,
                                        zoomControlsEnabled: false,
                                        zoomGesturesEnabled: false,
                                        markers: Set<Marker>.of(markers.values),
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(25.28545, 51.53096),
                                          zoom: 12.0000,
                                        ),
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _mapController.complete(controller);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  AppRoutes.push(
                                      context,
                                      PlacePicker(
                                        apiKey:
                                            "AIzaSyDruBo_2bXpTSTl7cb71GCqHueSV2jX30g",
                                        initialPosition:
                                            LatLng(25.28545, 51.53096),
                                        useCurrentLocation: true,
                                        selectInitialPosition: true,
                                        onPlacePicked: (result) async {
                                          _lat = result.geometry.location.lat;
                                          _lng = result.geometry.location.lng;
                                          var id = new Random();

                                          var markerIdVal = id.toString();
                                          final MarkerId markerId =
                                              MarkerId(markerIdVal);
                                          setState(() {
                                            markers[markerId] = Marker(
                                              markerId: markerId,
                                              icon: sourceIcon,
                                              position: LatLng(
                                                _lat,
                                                _lng,
                                              ),
                                            );
                                          });

                                          Navigator.of(context).pop();
                                          // addressTextEditingController.text =
                                          //     result.formattedAddress;

                                          addressNotifier.setAddress(result
                                              .formattedAddress
                                              .toString());
                                          setState(() {
                                            address.text =
                                                addressNotifier.address == null
                                                    ? ""
                                                    : addressNotifier.address;
                                          });
                                          final GoogleMapController controller =
                                              await _mapController.future;
                                          controller.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(
                                                  _lat,
                                                  _lng,
                                                ),
                                                zoom: 15.0),
                                          ));
                                        },
                                      ));
                                }),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              splashColor: lightmainColor,
                              onTap: () {
                                List ids = List();
                                List imgs = List();

                                print(
                                    "ameneties: ${multiSelectKey.currentState.result}");
                                for (int i = 0; i < menuItems.length; i++) {
                                  if (multiSelectKey.currentState.result
                                          .contains("${menuItems[i].name}") ||
                                      multiSelectKey.currentState.result
                                          .contains("${menuItems[i].arName}")) {
                                    ids.add(menuItems[i].id);
                                  }
                                }
                                for (int i = 0; i < images.length; i++) {
                                  if (images[i].toString().contains(
                                      propertyNotifier.value.baseUrl)) {
                                  } else {
                                    imgs.add(images[i]);
                                  }
                                }
                                print(imgs);
                                // AppRoutes.push(context, HomeScreen());
                                if (title.text.trim().isEmpty ||
                                    // titleAr.text.trim().isEmpty ||
                                    description.text.trim().isEmpty ||
                                    // descriptionAr.text.trim().isEmpty ||
                                    price.text.trim().isEmpty ||
                                    area.text.trim().isEmpty ||
                                    bed.text.trim().isEmpty ||
                                    bath.text.trim().isEmpty ||
                                    // ref.text.trim().isEmpty ||
                                    address.text.trim().isEmpty) {
                                  constValues().toast(
                                      "${getTranslated(context, "fieldEmptyText")}",
                                      context);
                                } else if (title.text.trim().length < 10) {
                                  constValues().toast(
                                      "${getTranslated(context, "titleCheck")}",
                                      context);
                                } else if (description.text.trim().length <
                                    10) {
                                  constValues().toast(
                                      "${getTranslated(context, "descriptionCheck")}",
                                      context);
                                } else if (selectedListing == null) {
                                  constValues().toast(
                                      "${getTranslated(context, "selectListing")}!",
                                      context);
                                } else if (selectedProperty == null) {
                                  constValues().toast(
                                      "${getTranslated(context, "selectProperty")}!",
                                      context);
                                } else if (selectedZone == null) {
                                  constValues().toast(
                                      "${getTranslated(context, "selectZone")}",
                                      context);
                                } else if (selectedZoneLocation == null) {
                                  constValues().toast(
                                      "${getTranslated(context, "selectZoneLocation")}",
                                      context);
                                } else if (selectedFurnish == null) {
                                  constValues().toast(
                                      "${getTranslated(context, "selectFurnish")}!",
                                      context);
                                } else if (_image == null) {
                                  constValues().toast(
                                      "${getTranslated(context, "selectImage")}!",
                                      context);
                                } else {
                                  print("Call api");
                                  // BaseHelper()
                                  //     .uploadImages(
                                  //         context: context,
                                  //         images: _image,
                                  //         propertyId: propertyNotifier.value.id)
                                  //     .then((value) {
                                  //   print("upload images response: $value");
                                  // });
                                  BaseHelper()
                                      .updateProperty(
                                    context: context,
                                    propertyId: widget.propertyId,
                                    zoneId: selectedZone.id,
                                    zoneLocationId: selectedZoneLocation.id,
                                    title: "${title.text}",
                                    titleAr: "${titleAr.text}",
                                    description: "${description.text}",
                                    descriptionAr: "${descriptionAr.text}",
                                    propertyTypeId: "${selectedProperty.id}",
                                    price: "${price.text}",
                                    listingId: "${selectedListing.id}",
                                    amenities: ids,
                                    bed: "${bed.text}",
                                    bath: "${bath.text}",
                                    lat: "$_lat",
                                    long: "$_lng",
                                    area: "${area.text}",
                                    publish: publish == true ? "1" : "0",
                                    youtubeLink: "${youtube.text}",
                                    address: "${address.text}",
                                    threesixty: "${threesixty.text}",
                                    furnishId: "${selectedFurnish.id}",
                                    requestTranslation:
                                        requestTranslation == true ? "1" : "0",
                                  )
                                      .then((value) {
                                    print("add property response: $value");
                                    if (value['error'] == false) {
                                      constValues().toast(
                                          "${value['message']}", context);
                                      // AppRoutes.push(context, HomeScreen());
                                      BaseHelper()
                                          .uploadImages(
                                              context: context,
                                              images: imgs,
                                              //  images,
                                              //  _image.value,
                                              propertyId:
                                                  propertyNotifier.value.id)
                                          .then((value) {
                                        if (value['error'] == false) {
                                          AppRoutes.makeFirst(
                                              context, HomeScreen());
                                        } else {
                                          constValues().toast(
                                              "${value['message']}", context);
                                        }
                                        print("upload images response: $value");
                                      });
                                    } else {
                                      constValues().toast(
                                          "${value['message']}", context);
                                    }
                                  });
                                }
                              },
                              child: CustomButton(
                                width: width * .9,
                                height: height * .06,
                                color: mainColor,
                                textColor: Colors.white,
                                title: "${getTranslated(context, "update")}",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * .93,
          height: height * .12,
          padding: EdgeInsets.all(width * .03),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "${getTranslated(context, "accountStatus")}",
                    style: headingStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${getTranslated(context, "subcriptionStatus")}: ${profileNotifiers.value.subscriptionStatus}",
                    maxLines: 1,
                    style: headingStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontSize: height * .012),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * .005, right: width * .005),
                    color: Colors.grey,
                    height: height * .02,
                    width: 1,
                  ),
                  Text(
                    "${getTranslated(context, "activeProperties")}: ${profileNotifiers.value.activeProperties}",
                    maxLines: 1,
                    style: headingStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontSize: height * .012),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * .005, right: width * .005),
                    color: Colors.grey,
                    height: height * .02,
                    width: 1,
                  ),
                  Text(
                    "${getTranslated(context, "Feature Properties")}: ${profileNotifiers.value.featuredProperties}",
                    maxLines: 1,
                    style: headingStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontSize: height * .012),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
              width: MediaQuery.of(context).size.width * .7,
              height: MediaQuery.of(context).size.height * .3,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          width: MediaQuery.of(context).size.width * .7,
                          height: MediaQuery.of(context).size.height * .25,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      AppRoutes.pop(context);
                                      BaseHelper()
                                          .chooseImage(true)
                                          .then((value) {
                                        if (value != null) {
                                          setState(() {
                                            final bytes = Io.File(value.path)
                                                .readAsBytesSync();
                                            var img64 = base64Encode(bytes);
                                            images.add(img64);
                                            _image.value.add(value);
                                          });
                                          //   setState(() {
                                          //     if (id == 1) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       idFront = img64;
                                          //       qataridFront = value;
                                          //     } else if (id == 2) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       idBack = img64;
                                          //       qataridBack = value;
                                          //     } else if (id == 3) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       pasport = img64;
                                          //       passport = value;
                                          //     } else if (id == 4) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       licence = img64;
                                          //       lic = value;
                                          //     }
                                          //   });
                                          //   print("selectedc images: $value");
                                          //   final bytes = Io.File(value.path)
                                          //       .readAsBytesSync();
                                          //   final img = base64Encode(bytes);
                                          //   setState(() {
                                          //     _img = img;
                                          //   });
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  mainColor.withOpacity(0.2)),
                                          color: mainColor),
                                      child: Center(
                                        child: Text(
                                            "${getTranslated(context, "Gallery")}",
                                            textAlign: TextAlign.center,

                                            //   maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: white, fontSize: 16)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      AppRoutes.pop(context);
                                      BaseHelper()
                                          .chooseImage(false)
                                          .then((value) {
                                        if (value != null) {
                                          setState(() {
                                            final bytes = Io.File(value.path)
                                                .readAsBytesSync();
                                            var img64 = base64Encode(bytes);
                                            images.add(img64);
                                            _image.value.add(value);
                                          });

                                          //   setState(() {
                                          //     if (id == 1) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       idFront = img64;
                                          //       qataridFront = value;
                                          //     } else if (id == 2) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       idBack = img64;
                                          //       qataridBack = value;
                                          //     } else if (id == 3) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       pasport = img64;
                                          //       passport = value;
                                          //     } else if (id == 4) {
                                          //       final bytes = Io.File(value.path)
                                          //           .readAsBytesSync();
                                          //       var img64 = base64Encode(bytes);
                                          //       licence = img64;
                                          //       lic = value;
                                          //     }
                                          //   });
                                          //   print("selectedc images: $value");
                                          //   final bytes = Io.File(value.path)
                                          //       .readAsBytesSync();
                                          //   final img = base64Encode(bytes);
                                          //   setState(() {
                                          //     _img = img;
                                          //   });
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  mainColor.withOpacity(0.2)),
                                          color: mainColor),
                                      child: Center(
                                          child: Text(
                                              "${getTranslated(context, "camera")}",
                                              textAlign: TextAlign.center,
                                              //   maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: white, fontSize: 16))),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .2,
                      height: MediaQuery.of(context).size.height * .1,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor),
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.image,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
