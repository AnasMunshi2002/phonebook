import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/contact/person.dart';
import '../../../services/database/bin/bin_db.dart';
import '../../../view_model/bin_provider/bin_provider.dart';
import '../../../view_model/theme/theme.dart';
import '../../widgets/contact_list_tile/contact_list_tile.dart';

class BinPage extends StatefulWidget {
  const BinPage({super.key});

  @override
  State<BinPage> createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> {
  final BinDB binDB = BinDB();
  @override
  void initState() {
    super.initState();
    fetchBin();
  }

  void fetchBin() {
    Provider.of<BinProvider>(context, listen: false).fetchBinData();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<CtTheme>().currentTheme.colorScheme;

    return Scaffold(
      backgroundColor: themeColor.secondary,
      appBar: AppBar(
        backgroundColor: themeColor.onSecondary,
        title: const Text("Bin"),
        actions: [
          PopupMenuButton(
              menuPadding: const EdgeInsets.all(0),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text("Restore All"),
                      onTap: () {
                        Provider.of<BinProvider>(context, listen: false)
                            .restoreAll(context);
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Empty Bin"),
                      onTap: () {
                        Provider.of<BinProvider>(context, listen: false)
                            .empty();
                      },
                    ),
                  ])
        ],
      ),
      body: Consumer<BinProvider>(
        builder: (context, consumer, child) {
          if (consumer.binData.isEmpty) {
            return const Center(
              child: Text("Bin is empty!"),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: consumer.binData.length,
            itemBuilder: (context, index) {
              Person person = consumer.binData[index];
              if (person.firstname.isNotEmpty || person.lastname!.isNotEmpty) {
                String? name =
                    person.firstname == "" ? person.lastname : person.firstname;
              }
              return CTile(
                person: person,
                binProvider: consumer,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
          );
        },
      ),
    );
  }
}
