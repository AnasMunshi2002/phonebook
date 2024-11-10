import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/contact/person.dart';
import '../../../services/database/contacts/add/add_contact.dart';
import '../../../view_model/all_data_provider/all_data_provider.dart';
import '../../../view_model/filter_provider/filter_provider.dart';
import '../../widgets/icons/appicons.dart';
import '../../widgets/navigator/navigator.dart';
import '../mains/add/add_contact.dart';

////////// H   O   M   E      B   O   D   Y      M   E   T   H   O   D   S\\\\\\\\\\\\\\\\\\\\\\\\\
Future<void> requestPermissions(BuildContext context) async {
  var storageStatus = await Permission.storage.request();
  var callLogStatus = await Permission.phone.request();
  if (context.mounted) {
    if (storageStatus.isGranted) {
      showSnack('Storage permission granted', context);
    } else if (storageStatus.isDenied) {
      showSnack('Storage permission denied', context);
    }
    if (callLogStatus.isGranted) {
      showSnack('Call permission granted', context);
    } else if (callLogStatus.isDenied) {
      showSnack("Call permission denied", context);
    }
  }
}

showBirthdayReminder(
    BuildContext context, Person person, ColorScheme themeColor, String? name) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: themeColor.secondary,
            title: const Text("Reminder!"),
            content: Text("Today is $name's birthday. Wish him/her."),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    NavigateRoute.pop(context);
                  },
                  child: const Text("Later")),
              FilledButton(
                  onPressed: () {
                    _sendBirthdayMsg(person, name);
                  },
                  child: const Text("Wish"))
            ],
          ));
}

_sendBirthdayMsg(Person person, String? name) async {
  if (await canLaunchUrlString("sms:${person.phone}")) {
    await launchUrlString("sms:${person.phone}?body=Happy Birthday $name");
  }
}

search(
  String value,
  AllDataProvider allDataProvider,
) {
  List<Person> tempList = [];
  if (value.isNotEmpty) {
    tempList = allDataProvider.contacts
        .where((element) =>
            element.firstname.toLowerCase().contains(value.toLowerCase()) ||
            element.lastname!.toLowerCase().contains(value.toLowerCase()) ||
            element.phone.contains(value))
        .toList();
  } else {
    tempList = allDataProvider.contacts;
  }
  allDataProvider.updateFilteredList(tempList);
}

Future filterDialog(BuildContext context, ColorScheme themeColor) {
  return showDialog(
      context: context,
      builder: (context) => Consumer<FilterProvider>(
            builder: (context, consumer, child) => Dialog(
                backgroundColor: themeColor.secondary,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      value: consumer.isFav,
                      onChanged: (value) {
                        consumer.changeFav(value!);
                        context.read<AllDataProvider>().filter(context);
                      },
                      title: const Text("Favourites"),
                    ),
                    CheckboxListTile(
                      value: consumer.isBlocked,
                      onChanged: (value) {
                        consumer.changeBlock(value!);
                        context.read<AllDataProvider>().filter(context);
                      },
                      title: const Text("Blocked"),
                    ),
                    CheckboxListTile(
                      value: consumer.noName,
                      onChanged: (value) {
                        consumer.changeNoName(value!);
                        context.read<AllDataProvider>().filter(context);
                      },
                      title: const Text("Nameless"),
                    ),
                  ],
                )),
          ));
}

//////////    A   D   D      C   O   N   T   A   C   T   S\\\\\\\\\\\\\\\\\\\\\\\\\
Future<ImageSource?> showOptions(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Select image from"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    onTap: () {
                      Navigator.pop(context, ImageSource.gallery);
                    },
                    leading: AppIcons.gallery,
                    title: const Text("Gallery")),
                ListTile(
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                  leading: AppIcons.camera,
                  title: const Text("Camera"),
                )
              ],
            ),
          ));
}

Future<int> deleteContact(Person person) async {
  final DBManager dbManager = DBManager();
  int result = await dbManager.deleteContact(person);
  return result;
}

Future<XFile?> pickImage(BuildContext context) async {
  ImageSource? source = await showOptions(context);
  if (source != null) {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 30);
    return image;
  }
  return null;
}

Future<DateTime?> getDOB(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
      });
}

bool validatePhone(String phone, BuildContext context) {
  const String phonePattern =
      r"^\+?(\d{1,3})?[-.\s]?(\(?\d{1,4}?\)?)[-.\s]?(\d{1,4})[-.\s]?(\d{1,4})[-.\s]?(\d{1,9})\b";
  RegExp regex = RegExp(phonePattern);
  if (phone.isEmpty || phone == "") {
    showSnack("Enter phone number", context);
    return false;
  } else if (!regex.hasMatch(phone)) {
    showSnack("Please enter valid phone", context);
    return false;
  } else {
    return true;
  }
}

//////////    CALL  SMS    SHARE    FUNCTIONALITIES   \\\\\\\\\\\\\\\\\\\\\\\\\

callNumber(String num, BuildContext context) async {
  if (Platform.isAndroid) {
    PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      final intent = AndroidIntent(
        action: 'android.intent.action.CALL',
        data: Uri.parse('tel:$num').toString(),
      );
      await intent.launch();
    } else {
      if (context.mounted) {
        showSnack("Permission denied.", context);
      }
    }
  } else if (Platform.isIOS) {
    if (await canLaunchUrlString("tel:$num")) {
      await launchUrlString("tel:$num");
    }
  }
}

message(String num) async {
  var intent = AndroidIntent(
    action: 'android.intent.action.SENDTO',
    data: 'sms:$num?body=Hello there!',
    package: 'com.google.android.apps.messaging',
    arguments: {'address': num, 'sms_body': 'Hello there!'},
  );
  intent.launch();
}

email(String email) {
  var intent = AndroidIntent(
    action: 'android.intent.action.SEND',
    arguments: const {'android.intent.extra.SUBJECT': 'SUBJECT HERE'},
    arrayArguments: {
      'android.intent.extra.EMAIL': [email],
    },
    package: 'com.google.android.gm',
    type: 'message/rfc822',
  );
  intent.launch();
}

shareContact(Person person) async {
  AndroidIntent intent = AndroidIntent(
    action: 'android.intent.action.SEND',
    package: 'com.google.android',
    type: 'text/plain',
    flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    arguments: <String, dynamic>{
      'android.intent.extra.TEXT':
          "Name: ${person.firstname}\nphone no: ${person.phone}"
    },
  );
  intent.launch();
}
