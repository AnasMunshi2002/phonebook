import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/all_data_provider/all_data_provider.dart';
import '../../../../view_model/navigation_provider/navigation_provider.dart';
import '../../../../view_model/theme/theme.dart';
import '../../../widgets/icons/appicons.dart';
import '../../../widgets/navigator/navigator.dart';
import '../../common_functions/commmon_functions.dart';
import '../../highlights/highlights.dart';
import '../../organise/organise.dart';
import '../add/add_contact.dart';
import 'home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    requestPermissions(context);
  }

  List<Widget> navItems = [
    const HomeBody(),
    const Highlights(),
    const Organise()
  ];

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);
    final themeColor = context.watch<CtTheme>().currentTheme.colorScheme;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarBrightness: themeColor.brightness,
          statusBarIconBrightness: themeColor.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            backgroundColor: themeColor.onSecondary,
            onTap: (index) {
              nav.changePage(index);
            },
            elevation: 10,
            selectedItemColor: themeColor.primary,
            currentIndex: nav.page,
            items: [
              BottomNavigationBarItem(icon: AppIcons.person, label: "Contacts"),
              BottomNavigationBarItem(
                  icon: AppIcons.highlights, label: "Highlights"),
              BottomNavigationBarItem(
                  icon: AppIcons.organise, label: "Organise")
            ]),
        floatingActionButton: nav.page == 2
            ? null
            : Consumer<AllDataProvider>(builder: (context, consumer, child) {
                return FloatingActionButton(
                  backgroundColor: themeColor.onSecondary,
                  onPressed: () async {
                    NavigateRoute.push(
                        context,
                        AddContact(
                          contacts: consumer.contacts,
                        ));
                  },
                  child: Icon(
                    Icons.add,
                    color: themeColor.primary,
                  ),
                );
              }),
        backgroundColor: themeColor.secondary,
        body: navItems[nav.page],
      ),
    );
  }
}
