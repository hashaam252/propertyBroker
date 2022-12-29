import 'package:flutter/material.dart';

class AddressNotifier extends ChangeNotifier {
  String address;
  String lat;

  void setAddress(value) {
    address = value;

    notifyListeners();
  }
}

final addressNotifier = AddressNotifier();
