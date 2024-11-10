import 'dart:io';

import 'package:call_e_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CallLogProvider with ChangeNotifier {
  List<CallLogEntry> recentCalls = [];

  fetchRecent() async {
    if (Platform.isAndroid) {
      if (await Permission.phone.request().isGranted) {
        Iterable<CallLogEntry> fetchedCalls = await CallLog.get();
        recentCalls = fetchedCalls.take(20).toList();
        notifyListeners();
        print("Recent calls fetched");
      } else {
        print("Permission not granted for phone access");
      }
    } else if (Platform.isIOS) {
      recentCalls = [
        CallLogEntry(
          name: "NOT SUPPORTED IN IOS DEVICES",
          number: "+0000000000",
          callType: CallType.blocked,
          timestamp: 000000000000,
        )
      ];
    }
  }
}
