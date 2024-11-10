import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactProvider extends ChangeNotifier {
  Image? profileImage;
  String? birthdate;
  bool isFav = false;

  setProfile(XFile image) {
    profileImage = Image.file(
      File(image.path),
      fit: BoxFit.contain,
    );
    notifyListeners();
  }

  changeFav(bool value) {
    isFav = value;
    notifyListeners();
  }

  setBirthdate(String newString) {
    birthdate = newString;
    notifyListeners();
  }
}
