import 'package:flutter/material.dart';

class SortProvider extends ChangeNotifier {
  String sortType = "asc";
  String pref = "name";

  change(String newPrf, String newType) {
    sortType = newType;
    pref = newPrf;
    notifyListeners();
  }
}
