import 'package:flutter/material.dart';
import 'package:property_broker/helper/repository.dart';
import 'package:property_broker/models/propertiesmodel.dart';

class PropertyNotifier extends ChangeNotifier {
  static List<PropertyResult> propertyResult = [];
  static ValueNotifier<List<PropertyResult>> dataNotifier =
      ValueNotifier<List<PropertyResult>>(null);
  void fetchProperties(context, search) {
    BaseHelper().getProperties(dataNotifier, search, context).then((value) {
      propertyResult = value;
      print("my properties: ${dataNotifier.value.length}");
      dataNotifier.value = propertyResult;
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
