import 'package:flutter/material.dart';

class NavigateRoute {
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static pop(BuildContext context) {
    Navigator.pop(context);
  }
}
