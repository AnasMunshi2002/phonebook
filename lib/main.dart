import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/database/contacts/add/add_contact.dart';
import 'services/shared_pref/profile_store/profile_store.dart';
import 'services/shared_pref/theme_manager/theme_pref_manager.dart';
import 'view/screens/mains/home/home_page.dart';
import 'view_model/all_data_provider/all_data_provider.dart';
import 'view_model/call_log_provider/call_log_provider.dart';
import 'view_model/contact_provider/contact_provider.dart';
import 'view_model/filter_provider/filter_provider.dart';
import 'view_model/navigation_provider/navigation_provider.dart';
import 'view_model/sort_provider/sort_provider.dart';
import 'view_model/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.initThemePref();
  await ProfileStoreManager.initProfilePref();
  DBManager dbManager = DBManager();
  await dbManager.database;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CtTheme()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => AllDataProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SortProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => CallLogProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<CtTheme>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      title: "Contact App",
      home: const HomePage(),
    );
  }
}
