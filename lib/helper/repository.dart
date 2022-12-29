import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_broker/helper/apisscreen.dart';
import 'package:property_broker/helper/archivenotifier.dart';
import 'package:property_broker/helper/profilenotifier.dart';
import 'package:property_broker/localization/language_constants.dart';
import 'package:property_broker/models/appointmentModel.dart';
import 'package:property_broker/models/brokermodel.dart';
import 'package:property_broker/models/contactrequestmodel.dart';
import 'package:property_broker/models/dashboardmodel.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/models/pushNotificationModel.dart';
import 'package:property_broker/models/singleproductmodel.dart';
import 'package:property_broker/models/singleton.dart';
import 'package:property_broker/models/staffmodel.dart';
import 'package:property_broker/models/supportcontactModel.dart';
import 'package:property_broker/models/typesmodel.dart';
import 'package:property_broker/models/userdatamodel.dart';
import 'package:property_broker/utils/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BaseHelper {
  chooseImage(bool selectImage) async {
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: selectImage == true ? ImageSource.gallery : ImageSource.camera,
        maxHeight: 400,
        maxWidth: 400);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print(_image);
      return _image;
    } else {
      return null;
      print('No image selected.');
    }
    //                     .then((value) {
    //   print(value.path);
    //   if (value != null) {
    //     return value;
    //   } else {
    //     return null;
    //   }
    // });
    //print('Image file from gallery is $file ');
  }

  Future<dynamic> loginUser(var email, var pass, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        "email": "$email",
        "fcm_token": "${User.userData.notificationToken}",
        "password": "$pass"
      };
      print("body: $body");
      print("header $header");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.loginApi}",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<List<StaffResult>> getStaff(ValueNotifier notifier, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    var url = "${API.API_URL}${API.getStaff}";
    print("$url");

    try {
      var body = {
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      // print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      // print("ALl Departments:$Json");
      if (response.statusCode == 200) {
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        StaffModel staffModel = StaffModel.fromJson(Json);
        notifier.value = staffModel.result;
        return staffModel.result;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<List<StaffResult>> getAppointment(
      ValueNotifier notifier, startDate, endDate, status, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    var url = status == 0 && startDate == null && endDate == null
        ? "${API.API_URL}${API.getAppointment}"
        : startDate == null || endDate == null
            ? "${API.API_URL}${API.getAppointment}?status=$status"
            : status == 0
                ? "${API.API_URL}${API.getAppointment}?from=$startDate&to=$endDate"
                : "${API.API_URL}${API.getAppointment}?from=$startDate&to=$endDate&status=$status";
    print("$url");

    try {
      var body = {
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      // print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      // print("ALl Departments:$Json");
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        AppointmentModel staffModel = AppointmentModel.fromJson(Json);
        notifier.value = staffModel.result;
        return staffModel.result;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<List<StaffResult>> getcontactRequest(
      ValueNotifier notifier, startDate, endDate, status, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    print("header: $header");
    var url = status == 0 && startDate == null && endDate == null
        ? "${API.API_URL}${API.getContactRequest}"
        : startDate == null || endDate == null
            ? "${API.API_URL}${API.getContactRequest}?status=$status"
            : status == 0
                ? "${API.API_URL}${API.getContactRequest}?from=$startDate&to=$endDate"
                : "${API.API_URL}${API.getContactRequest}?from=$startDate&to=$endDate&status=$status";
    print("$url");

    try {
      var body = {
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      // print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      // print("ALl Departments:$Json");
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        ContactRequestModel staffModel = ContactRequestModel.fromJson(Json);
        notifier.value = staffModel.result;
        return staffModel.result;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> updateStaff(
      {@required context,
      @required id,
      @required name,
      @required phone,
      @required profileImage,
      @required email,
      @required whatsApp,
      @required password,
      @required staffType}) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        'name': '$name',
        'phone': '$phone',
        "profile_image": "$profileImage",
        'whatsapp_no': '$whatsApp',
        'email': '$email',
        'password': '$password',
        'staff_type': '$staffType',
      };
      print("body: $body");
      print("header $header");
      print("${API.API_URL}${API.updateStaff}$id");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.updateStaff}$id",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      print("Couldn't find the post 😱");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
    } on FormatException catch (error) {
      print(error);
      print("DSadsadad");
      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      print("errrrrrr");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> createStaff(
      {@required context,
      @required id,
      @required name,
      @required phone,
      @required email,
      @required whatsApp,
      @required password,
      @required staffType}) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        'name': '$name',
        'phone': '$phone',
        'whatsapp_no': '$whatsApp',
        'email': '$email',
        'password': '$password',
        'staff_type': '$staffType',
      };
      print("body: $body");
      print("header $header");
      print("${API.API_URL}${API.updateStaff}$id");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.updateStaff}$id",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      print("Couldn't find the post 😱");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
    } on FormatException catch (error) {
      print(error);
      print("DSadsadad");
      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      print("errrrrrr");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> addStaff(
      {@required context,
      @required name,
      @required phone,
      @required email,
      @required whatsApp,
      @required profileImage,
      @required password,
      @required staffType}) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        'name': '$name',
        "profile_image": "$profileImage",
        'phone': '$phone',
        'whatsapp_no': '$whatsApp',
        'email': '$email',
        'password': '$password',
        'staff_type': '$staffType',
      };
      print("body: $body");
      print("header $header");
      print("${API.API_URL}${API.addStaff}");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.addStaff}",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      print("Couldn't find the post 😱");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
    } on FormatException catch (error) {
      print(error);
      print("DSadsadad");
      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      print("errrrrrr");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> getSupport({
    @required context,
    @required ValueNotifier notifier,
  }) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {};
      print("body: $body");
      print("header $header");
      print("${API.API_URL}${API.addStaff}");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.support}",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(response.statusCode);
      SupportModel supportModel = SupportModel();
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        supportModel = SupportModel.fromJson(Json['data']);
        notifier.value = supportModel.result;
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      print("Couldn't find the post 😱");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
    } on FormatException catch (error) {
      print(error);
      print("DSadsadad");
      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      print("errrrrrr");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<List<PropertyResult>> getProperties(
      ValueNotifier notifier, search, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    var url = "${API.API_URL}${API.getProperties}";
    print("property url $url");

    try {
      var body = {
        "search": "$search"
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      // print("ALl Departments:$Json");
      if (response.statusCode == 200) {
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        PropertyModel staffModel = PropertyModel.fromJson(Json);
        notifier.value = staffModel.result;
        return staffModel.result;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<List<PropertyResult>> getArchiveProperties(
      ValueNotifier notifier, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    var url = "${API.API_URL}${API.getArchive}";
    print("$url");

    try {
      var body = {
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      // print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      // print("ALl Departments:$Json");
      if (response.statusCode == 200) {
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        PropertyModel staffModel = PropertyModel.fromJson(Json);
        notifier.value = staffModel.result;
        return staffModel.result;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> getPropertydetail({
    @required context,
    @required id,
    @required ValueNotifier notifier,
  }) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {};
      print("body: $body");
      print("header $header");
      print("${API.API_URL}${API.propertyDetail}$id");
      // EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.propertyDetail}$id",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(response.statusCode);
      SingleProductModel supportModel = SingleProductModel();
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        supportModel = SingleProductModel.fromJson(Json['property']);
        notifier.value = supportModel.result;
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      print("Couldn't find the post 😱");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
    } on FormatException catch (error) {
      print(error);
      print("DSadsadad");
      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      print("errrrrrr");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<TypesModel> getTypes(ValueNotifier notifier, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    var url = "${API.API_URL}${API.types}";
    print("$url");

    try {
      var body = {
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      // print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      print("types response :$Json");
      if (response.statusCode == 200) {
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        TypesModel staffModel = TypesModel.fromJson(Json);
        notifier.value = staffModel;
        print("types again response :${notifier.value.listingType.length}");
        return staffModel;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> addProperty({
    @required context,
    @required title,
    @required titleAr,
    @required description,
    @required descriptionAr,
    @required propertyTypeId,
    @required price,
    @required listingId,
    @required amenities,
    @required bed,
    @required bath,
    @required lat,
    @required zoneId,
    @required zoneLocationId,
    @required long,
    @required area,
    @required publish,
    @required youtubeLink,
    @required address,
    @required threesixty,
    @required furnishId,
    @required requestTranslation,
  }) async {
    var header = {
      // 'Content-type': 'application/json',
      // 'Accept': 'application/json',
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        "title": "$title",
        "titlear": "$titleAr",
        "description": "$description",
        "descriptionar": "$descriptionAr",
        "property_type_id": "$propertyTypeId",
        "listing_type_id": "$listingId",
        "price": "$price",
        "zone_id": "$zoneId",
        "zone_location_id": "$zoneLocationId",
        "beds": "$bed",
        "lng": "$long",
        "lat": "$lat",
        "amenities": "$amenities",
        "baths": "$bath",
        "furnish_type_id": "$furnishId",
        "address": "$address",
        "area": "$area",
        "published": "$publish",
        "youtube_link": "$youtubeLink",
        "three_sixty_link": "$threesixty",
        "request_translation": "0"
        //  "$requestTranslation",
      };
      print("body: $body");
      print("header $header");
      print("${API.API_URL}${API.saveProperty}");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.saveProperty}",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(response.statusCode);
      print("response status code: $Json");
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();
        if (Json['errors']['title']
            .toString()
            .contains("The title has already been taken")) {
          constValues().toast("The title has already been taken", context);
        } else {
          constValues().toast("${Json['errors']['title']}", context);
        }
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      print("Couldn't find the post 😱");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
    } on FormatException catch (error) {
      print(error);
      print("DSadsadad");
      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      print("errrrrrr");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> updateProperty({
    @required context,
    @required title,
    @required titleAr,
    @required description,
    @required descriptionAr,
    @required propertyTypeId,
    @required price,
    @required listingId,
    @required propertyId,
    @required amenities,
    @required bed,
    @required bath,
    @required lat,
    @required zoneId,
    @required zoneLocationId,
    @required long,
    @required area,
    @required publish,
    @required youtubeLink,
    @required address,
    @required threesixty,
    @required furnishId,
    @required requestTranslation,
  }) async {
    var header = {
      // 'Content-type': 'application/json',
      // 'Accept': 'application/json',
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        "title": "$title",
        "owner_id": "${ProfileNotifier.profileNotifiers.value.result.id}",
        "id": "$propertyId",
        "titlear": "$titleAr",
        "description": "$description",
        "descriptionar": "$descriptionAr",
        "property_type_id": "$propertyTypeId",
        "listing_type_id": "$listingId",
        "price": "$price",
        "zone_id": "$zoneId",
        "zone_location_id": "$zoneLocationId",
        "beds": "$bed",
        "lng": "$long",
        "lat": "$lat",
        "amenities": "$amenities",
        "baths": "$bath",
        "furnish_type_id": "$furnishId",
        "address": "$address",
        "area": "$area",
        "published": "$publish",
        "youtube_link": "$youtubeLink",
        "three_sixty_link": "$threesixty",
        "request_translation": "0"
        //  "$requestTranslation",
      };
      print("body: $body");
      print("header $header");
      print("${API.API_URL}${API.updateProperty}");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.updateProperty}",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(response.statusCode);
      print("response status code: $Json");
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();
        if (Json['errors']['title']
            .toString()
            .contains("The title has already been taken")) {
          constValues().toast("The title has already been taken", context);
        } else {
          constValues().toast("${Json['errors']['title']}", context);
        }
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      print("Couldn't find the post 😱");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
    } on FormatException catch (error) {
      print(error);
      print("DSadsadad");
      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      print("errrrrrr");
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> duplicate(var id, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.duplicate}$id",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> deleteProperty(var id, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.deleteProperty}$id",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> publishProperty(var id, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      print("url: ${API.API_URL}${API.publish}$id");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.publish}$id",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> featureProperty(var id, type, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      print("url: ${API.API_URL}${API.featureProperty}$id&featured=$type");
      EasyLoading.show();
      final response = await http.post(
          "${API.API_URL}${API.featureProperty}$id&featured=$type",
          headers: header,
          body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> archiveProperty(var id, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      print("url: ${API.API_URL}${API.archive}$id");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.archive}$id",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> removeImage(var id, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        "id": "$id"
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      print("url: ${API.API_URL}${API.removeImage}");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.removeImage}",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> uploadImages(
      {@required images, @required propertyId, @required context}) async {
    var header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        "id": "$propertyId",
        "images": "$images"
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      print("url: ${API.API_URL}${API.uploadImages}");
      EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.uploadImages}",
          headers: header, body: jsonEncode(body));
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> getUserProfile(ValueNotifier profileNotifier, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      print("url: ${API.API_URL}${API.getUserProfile}");
      // EasyLoading.show();
      final response = await http.post("${API.API_URL}${API.getUserProfile}",
          headers: header, body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        UserDataModel userDataModel = UserDataModel();
        userDataModel = UserDataModel.fromJson(Json["user"]);
        userDataModel.activeProperties = Json['active_properties'];
        userDataModel.featuredProperties = Json['feature_properties'];
        userDataModel.subscriptionStatus = Json['subscription_status'];
        print("subscription: ${userDataModel.subscriptionStatus}");
        profileNotifier.value = userDataModel;
        print("profile response: ${userDataModel.result.name}");
        return userDataModel;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      // constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      // constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      // constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<DashboardModel> getDashboardData(
      ValueNotifier notifier, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    var url = "${API.API_URL}${API.dashboard}";
    print("$url");

    try {
      var body = {
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      // print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      // print("ALl Departments:$Json");
      if (response.statusCode == 200) {
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        DashboardModel staffModel = DashboardModel.fromJson(Json);
        for (int i = 0; i < staffModel.saleResult.length; i++) {
          var year = staffModel.saleResult[i].date.toString().split("-")[0];
          var month = staffModel.saleResult[i].date.toString().split("-")[1];
          print("yeaarrrrr: $year");
          print("monthssssssss: $month");
          var date = DateTime(
              int.parse(year.toString()), int.parse(month.toString()), 1);
          staffModel.saleResult[i].date = "$date";
          print("rental date: $date");
        }
        for (int i = 0; i < staffModel.rentResult.length; i++) {
          var year = staffModel.rentResult[i].date.toString().split("-")[0];
          var month = staffModel.rentResult[i].date.toString().split("-")[1];
          print("yeaarrrrr: $year");
          print("monthssssssss: $month");
          var date = DateTime(
              int.parse(year.toString()), int.parse(month.toString()), 1);
          staffModel.rentResult[i].date = "$date";
          print("rental date: $date");
        }
        notifier.value = staffModel;
        return staffModel;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<List<BrokerResult>> getBrokers(ValueNotifier notifier, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    var url = "${API.API_URL}${API.getBrokerList}";
    print("$url");

    try {
      var body = {
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      // print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      print("types response :$Json");
      if (response.statusCode == 200) {
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        BrokerModel staffModel = BrokerModel.fromJson(Json);
        notifier.value = staffModel.result;

        return staffModel.result;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> assignProperty(var propertyId, brokerId, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      print(
          "url: ${API.API_URL}${API.assignProperty}property_id=$propertyId&broker_id=$brokerId");
      EasyLoading.show();
      final response = await http.post(
          "${API.API_URL}${API.assignProperty}property_id=$propertyId&broker_id=$brokerId",
          headers: header,
          body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<List<NotificationResult>> getNotificaitons(
      ValueNotifier notifier, context) async {
    // Math.max();
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    var url = "${API.API_URL}${API.notificationList}";
    print("$url");

    try {
      var body = {
        // "phone": "${User.userData.mobile}",
        // "password": "$password",
      };
      // print("body: $body");
      // print("header $header");
      // EasyLoading.show();
      final response = await http.post(url, headers: header, body: body);
      var Json = json.decode(response.body);
      print("types response :$Json");
      if (response.statusCode == 200) {
        // print("response status code: ${response.statusCode}");
        // print(json.decode(response.body));
        // print("dfsdfdsgdsS:$Json");
        NotificationModel staffModel = NotificationModel.fromJson(Json);
        notifier.value = staffModel.result;

        return staffModel.result;
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();

        // showAlertDialog(
        //     context,
        //     User.userData.lang == "en"
        //         ? "${Json['message']}"
        //         : "${Json['messagear']}");
        constValues().toast("${Json['message']}", context);
      } else {
        EasyLoading.dismiss();
        constValues().toast("${Json['message']}", context);
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> readNotificaiton(var id, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      print("url: ${API.API_URL}${API.readNotification}$id");
      // EasyLoading.show();
      final response = await http.post(
          "${API.API_URL}${API.readNotification}$id",
          headers: header,
          body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        // constValues()
        //     .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      // constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      // constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      // constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      // constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }

  Future<dynamic> changeLead(var id, status, context) async {
    var header = {
      "content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.userData.token}",
    };
    // print(url);
    try {
      var body = {
        // "owner_id": "${ProfileNotifier.profileNotifiers.value.result.id}",
        // "fcm_token": "${User.userData.notificationToken}",
      };
      print("body: $body");
      print("header $header");
      EasyLoading.show();
      final response = await http.post(
          "${API.API_URL}${API.changeLead}?id=$id&status=$status",
          headers: header,
          body: body);
      var Json = json.decode(response.body);
      print(Json);
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");
        print(json.decode(response.body));
        EasyLoading.dismiss();
        return Json;
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();

        constValues()
            .toast("${getTranslated(context, "maintainance")}", context);
      } else {
        EasyLoading.dismiss();

        constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      constValues().toast("${getTranslated(context, "no_internet")}", context);
      EasyLoading.dismiss();
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);

      constValues().toast("${getTranslated(context, "bad_format")}", context);
      EasyLoading.dismiss();
      print("Bad response format 👎");
    } catch (value) {
      constValues().toast("${getTranslated(context, "wrong")}", context);
      EasyLoading.dismiss();
      print(value);
    }
  }
}
