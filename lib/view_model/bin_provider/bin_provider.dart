import 'package:flutter/material.dart';

import '../../models/contact/person.dart';

class BinProvider extends ChangeNotifier {
  List<Person> binData = [];

  addToBin(Person person) {
    binData.add(person);
    notifyListeners();
  }

  restore(Person person) {
    binData.remove(person);
    notifyListeners();
  }

  deletePermanently(Person person) {
    binData.remove(person);
    notifyListeners();
  }

  restoreAll() {
    binData.clear();
    notifyListeners();
  }

  deleteAll() {
    binData.clear();
    notifyListeners();
  }
}
