import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  bool isFav = false;
  bool isBlocked = false;
  bool noName = false;

  changeBlock(bool value) {
    isBlocked = value;
    notifyListeners();
  }

  changeFav(bool value) {
    isFav = value;
    notifyListeners();
  }

  changeNoName(bool value) {
    noName = value;
    notifyListeners();
  }
}
