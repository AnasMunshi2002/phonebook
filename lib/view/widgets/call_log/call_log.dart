import 'package:call_e_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../view_model/call_log_provider/call_log_provider.dart';
import '../../../view_model/theme/common.dart';
import '../../screens/common_functions/commmon_functions.dart';
import '../icons/appicons.dart';

class CallLogs extends StatefulWidget {
  const CallLogs({super.key});

  @override
  CallLogsState createState() => CallLogsState();
}

class CallLogsState extends State<CallLogs> {
  @override
  void initState() {
    super.initState();
    fetchRecent();
  }

  fetchRecent() async {
    final callLogProvider =
        Provider.of<CallLogProvider>(context, listen: false);
    await callLogProvider.fetchRecent();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallLogProvider>(builder: (context, consumer, child) {
      return consumer.recentCalls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: consumer.recentCalls.length,
              itemBuilder: (context, index) {
                final call = consumer.recentCalls[index];

                String formattedDate = DateFormat('HH:mm:ss dd-MM-yyy').format(
                  DateTime.fromMillisecondsSinceEpoch(call.timestamp!),
                );
                String time = formattedDate.split(" ")[0];
                String date = formattedDate.split(" ")[1];
                return ListTile(
                  onTap: () {
                    callNumber(call.number!, context);
                  },
                  title: Text(
                    call.name?.isNotEmpty == true ? call.name! : 'Unknown',
                  ),
                  subtitle: Text(call.number ?? 'Unknown'),
                  leading: Icon(
                    call.callType == CallType.incoming
                        ? AppIcons.received
                        : (call.callType == CallType.outgoing
                            ? AppIcons.called
                            : AppIcons.missed),
                    color: call.callType == CallType.missed
                        ? CommonColors.redC
                        : CommonColors.greenC,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(time),
                      Text(date),
                    ],
                  ),
                );
              },
            );
    });
  }
}
