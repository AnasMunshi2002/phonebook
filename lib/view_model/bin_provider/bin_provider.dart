import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contact/person.dart';
import '../../services/database/bin/bin_db.dart';
import '../../services/database/contacts/add/add_contact.dart';
import '../all_data_provider/all_data_provider.dart';

class BinProvider extends ChangeNotifier {
  List<Person> binData = [];

  fetchBinData() async {
    final BinDB binDB = BinDB();
    var list = await binDB.getAllBin();
    list.sort(
      (a, b) => a.firstname.toLowerCase().compareTo(b.firstname.toLowerCase()),
    );
    updateBinList(list);
    notifyListeners();
  }

  void updateBinList(List<Person> list) {
    binData = list;
    notifyListeners();
  }

  removeOne(Person person) {
    binData.removeWhere((element) => element.phone == person.phone);
    final BinDB binDB = BinDB();
    binDB.removeOne(person);
    notifyListeners();
  }

  empty() {
    binData.clear();
    final BinDB binDB = BinDB();
    binDB.empty();
    notifyListeners();
  }

  restoreOne(Person person, BuildContext context) async {
    binData.removeWhere((element) => element.phone == person.phone);
    final BinDB binDB = BinDB();
    binDB.removeOne(person);
    final DBManager dbManager = DBManager();
    int result = await dbManager.addContact(person);
    if (context.mounted) {
      Provider.of<AllDataProvider>(context, listen: false).refresh();
    }
    notifyListeners();
    if (result > 0) {
      print("Removed from bin and added to db");
    } else {
      print("ERROR BIN");
    }
  }

  restoreAll(BuildContext context) async {
    final DBManager dbManager = DBManager();
    int result = await dbManager.addBin(binData);
    binData.clear();
    final BinDB binDB = BinDB();
    binDB.empty();
    if (context.mounted) {
      Provider.of<AllDataProvider>(context, listen: false).refresh();
    }
    notifyListeners();
  }
}
