import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int page = 0;

  changePage(int newPage) {
    page = newPage;
    notifyListeners();
  }
}
