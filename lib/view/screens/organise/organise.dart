import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/shared_pref/theme_manager/theme_pref_manager.dart';
import '../../../view_model/theme/common.dart';
import '../../../view_model/theme/theme.dart';
import '../../widgets/icons/appicons.dart';
import '../../widgets/navigator/navigator.dart';
import '../../widgets/profile_button/profile_button.dart';
/*
import '../bin_page/bin.dart';
*/
import '../bin_page/bin.dart';
import '../blocked_list/blocked_list.dart';

class Organise extends StatefulWidget {
  const Organise({super.key});

  @override
  State<Organise> createState() => _OrganiseState();
}

class _OrganiseState extends State<Organise> {
  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<CtTheme>().currentTheme.colorScheme;
    return Scaffold(
      backgroundColor: themeColor.secondary,
      appBar: AppBar(
        backgroundColor: themeColor.onSecondary,
        title: const Text("Organise"),
        actions: const [
          PButton(),
          SizedBox(
            width: 14,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Text("This device"),
          ),
          ListTile(
            leading: AppIcons.sim,
            title: const Text("Manage SIM"),
            subtitle: const Text("Import or delete contacts from SIM"),
          ),
          ListTile(
            onTap: () {
              NavigateRoute.push(context, const BinPage());
            },
            leading: AppIcons.bin,
            title: const Text("Bin"),
            subtitle: const Text("Recently deleted contacts"),
          ),
          ListTile(
            onTap: () {
              NavigateRoute.push(context, const BList());
            },
            leading: AppIcons.block,
            title: const Text("Blocked numbers"),
            subtitle: const Text(
                "Numbers that you won't receive calls or texts from "),
          ),
          ListTile(
            leading: AppIcons.settings,
            title: const Text("Settings"),
          ),
          Divider(
            color: CommonColors.greyC,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Text("App setting"),
          ),
          Consumer<CtTheme>(builder: (context, consumer, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Dark Theme"),
                  CupertinoSwitch(
                    value: ThemeManager.getTheme(),
                    onChanged: (value) {
                      consumer.toggleTheme();
                      ThemeManager.storeTheme(value);
                    },
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
