import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/shared_pref/theme_manager/theme_pref_manager.dart';
import '../../../view_model/theme/common.dart';
import '../../../view_model/theme/theme.dart';
import '../avatar/avatar.dart';
import '../icons/appicons.dart';

class PButton extends StatefulWidget {
  const PButton({super.key});

  @override
  State<PButton> createState() => _PButtonState();
}

class _PButtonState extends State<PButton> {
  profileDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) =>
            Consumer<CtTheme>(builder: (context, consumer, child) {
              return Dialog(
                backgroundColor: consumer.currentTheme.colorScheme.secondary,
                child: Container(
                  padding: const EdgeInsets.all(25),
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
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(5),
      color: Colors.transparent,
      onPressed: () {
        profileDialog(context);
      },
      icon: CA(
        radius: 19,
        backColor: CommonColors.profile,
        child: AppIcons.person,
      ),
    );
  }
}
