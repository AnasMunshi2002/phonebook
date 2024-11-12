import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/theme/common.dart';
import '../../../view_model/theme/theme.dart';
import '../../widgets/call_log/call_log.dart';
import '../../widgets/fav_grid_tile/fav_grid_tile.dart';
import '../../widgets/icons/appicons.dart';

class Highlights extends StatefulWidget {
  const Highlights({super.key});

  @override
  State<Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> {
  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<CtTheme>().currentTheme.colorScheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: themeColor.secondary,
      appBar: AppBar(
        title: const Text("Highlights"),
        backgroundColor: themeColor.onSecondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    "Favourites",
                    style: TextStyle(fontSize: 15),
                  ),
                  AppIcons.fav
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height * 0.6),
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: themeColor.onSecondary),
                    width: width,
                    child: const FGT()),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recents",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "last 20 calls",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  AppIcons.error,
                  Text(
                    " Tap to call",
                    style: TextStyle(fontSize: 11, color: CommonColors.blueC),
                  )
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: themeColor.onSecondary,
                  ),
                  width: width,
                  child: const CallLogs()),
            ],
          ),
        ),
      ),
    );
  }
}
