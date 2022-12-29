import 'package:flutter/material.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/models/propertiesmodel.dart';
import 'package:property_broker/models/staffmodel.dart';

class AppointmentNotifier extends ChangeNotifier {
  static List<StaffResult> staffResult = [];
  static List<StaffResult> archivepropertyResult = [];
  static ValueNotifier<List<StaffResult>> dataNotifier =
      ValueNotifier<List<StaffResult>>(null);
  static ValueNotifier<List<StaffResult>> archivedataNotifier =
      ValueNotifier<List<StaffResult>>(null);

  void fetchData(context, callingScreen, startDate, endDate, status) {
    staffResult = [];
    dataNotifier = ValueNotifier<List<StaffResult>>(null);
    if (callingScreen == 0) {
      BaseHelper()
          .getAppointment(dataNotifier, startDate, endDate, status, context)
          .then((value) {
        staffResult = value;
        print("my properties: ${dataNotifier.value.length}");
        dataNotifier.value = staffResult;
      });
    } else {
      BaseHelper()
          .getcontactRequest(dataNotifier, startDate, endDate, status, context)
          .then((value) {
        staffResult = value;
        print("my properties: ${dataNotifier.value.length}");
        dataNotifier.value = staffResult;
      });
    }

    notifyListeners();
  }

  // void fetchArchiveProperties(context) {
  //   BaseHelper()
  //       .getArchiveProperties(archivedataNotifier, context)
  //       .then((value) {
  //     archivepropertyResult = value;
  //     // print("my properties: ${dataNotifier.value.length}");
  //     archivedataNotifier.value = archivepropertyResult;
  //   });

  //   notifyListeners();
  // }

  Future<List<PropertyResult>> setEmpty(context) {
    dataNotifier = ValueNotifier<List<StaffResult>>(null);
    notifyListeners();
    // return _dataNotifier;
  }
}

final appointmentNotifier = AppointmentNotifier();
