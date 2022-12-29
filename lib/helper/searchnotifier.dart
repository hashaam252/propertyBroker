import 'package:flutter/material.dart';

class SearchNotifier extends ChangeNotifier {
  static TextEditingController search = TextEditingController();
  // String lat;

  void setSearch(value) {
    search.text = value;

    notifyListeners();
  }
}

final searchNotifier = SearchNotifier();
