import 'package:flutter/material.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/models/propertiesmodel.dart';

class PropertyNotifier extends ChangeNotifier {
  static List<PropertyResult> propertyResult = [];
  static List<PropertyResult> archivepropertyResult = [];
  static ValueNotifier<List<PropertyResult>> dataNotifier =
      ValueNotifier<List<PropertyResult>>(null);
  static ValueNotifier<List<PropertyResult>> archivedataNotifier =
      ValueNotifier<List<PropertyResult>>(null);

  Future fetchProperties(context, search) {
    propertyResult = [];
    // dataNotifier = ValueNotifier<List<PropertyResult>>(null);
    BaseHelper().getProperties(dataNotifier, search, context).then((value) {
      propertyResult = value;
      print("my properties: ${dataNotifier.value.length}");
      dataNotifier.value = propertyResult;
      notifyListeners();
      return dataNotifier.value;
    });

    notifyListeners();
  }

  void fetchArchiveProperties(context) {
    BaseHelper()
        .getArchiveProperties(archivedataNotifier, context)
        .then((value) {
      archivepropertyResult = value;
      // print("my properties: ${dataNotifier.value.length}");
      archivedataNotifier.value = archivepropertyResult;
    });

    notifyListeners();
  }

  Future<List<PropertyResult>> setEmpty(context) {
    dataNotifier = ValueNotifier<List<PropertyResult>>(null);
    notifyListeners();
    // return _dataNotifier;
  }
}

final addressNotifier = PropertyNotifier();
