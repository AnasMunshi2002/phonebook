import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../models/contact/person.dart';
import '../../services/database/contacts/add/add_contact.dart';
import '../filter_provider/filter_provider.dart';
import '../sort_provider/sort_provider.dart';

class AllDataProvider extends ChangeNotifier {
  List<Person> contacts = [];
  List<Person> filteredList = [];

  updateContactList(List<Person> newList) {
    contacts = newList;
    notifyListeners();
  }

  updateFilteredList(List<Person> newList) {
    filteredList = newList;
    notifyListeners();
  }

  refresh() async {
    var dbManager = DBManager();
    var list = await dbManager.getAllContacts();

    list.sort(
      (a, b) => a.firstname.toLowerCase().compareTo(b.firstname.toLowerCase()),
    );
    updateContactList(list);
    updateFilteredList(list);
    notifyListeners();
  }

  changePref(String newPref, String newType, BuildContext context) {
    Provider.of<SortProvider>(context, listen: false).change(newPref, newType);
    if (Provider.of<SortProvider>(context, listen: false).pref == "name") {
      if (Provider.of<SortProvider>(context, listen: false).sortType == "asc") {
        filteredList.sort((a, b) =>
            a.firstname.toLowerCase().compareTo(b.firstname.toLowerCase()));
      } else {
        filteredList.sort((a, b) =>
            b.firstname.toLowerCase().compareTo(a.firstname.toLowerCase()));
      }
    } else if (Provider.of<SortProvider>(context, listen: false).pref ==
        "number") {
      if (Provider.of<SortProvider>(context, listen: false).sortType == "asc") {
        filteredList.sort((a, b) => a.phone.compareTo(b.phone));
      } else {
        filteredList.sort((a, b) => b.phone.compareTo(a.phone));
      }
    } else if (Provider.of<SortProvider>(context, listen: false).pref ==
        "date") {
      if (Provider.of<SortProvider>(context, listen: false).sortType == "asc") {
        filteredList.sort((a, b) => a.addDate.compareTo(b.addDate));
      } else {
        filteredList.sort((a, b) => b.addDate.compareTo(a.addDate));
      }
    }
    notifyListeners();
  }

  filter(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    bool blocked = filterProvider.isBlocked;
    bool noName = filterProvider.noName;
    bool fav = filterProvider.isFav;

    filteredList = filteredList.where((element) {
      if (blocked && !element.blocked!) {
        return false;
      }
      if (noName &&
          (element.firstname.isNotEmpty && element.lastname != null)) {
        return false;
      }
      if (fav && !element.fav!) {
        return false;
      }
      return true;
    }).toList();

    if (!blocked && !noName && !fav) {
      refresh();
    }
    notifyListeners();
  }

  toggleBlock(BuildContext context, Person person, bool bool) async {
    final DBManager dbManager = DBManager();
    int result = await dbManager.toggleBlock(person, bool);
    if (result > 0) {
      refresh();
    }
    notifyListeners();
  }

  toggleFav(BuildContext context, Person person, bool bool) async {
    final DBManager dbManager = DBManager();
    int result = await dbManager.toggleFav(person, bool);
    if (result > 0) {
      refresh();
    }
    notifyListeners();
  }
}
