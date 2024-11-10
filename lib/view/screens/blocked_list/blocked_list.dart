import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/contact/person.dart';
import '../../../view_model/all_data_provider/all_data_provider.dart';
import '../../../view_model/theme/common.dart';
import '../../../view_model/theme/theme.dart';
import '../../widgets/avatar/avatar.dart';

class BList extends StatefulWidget {
  const BList({super.key});

  @override
  State<BList> createState() => _BListState();
}

class _BListState extends State<BList> {
  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<CtTheme>().currentTheme.colorScheme;
    return Scaffold(
      backgroundColor: themeColor.secondary,
      appBar: AppBar(
        backgroundColor: themeColor.secondary,
        title: const Text("Block List"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Consumer<AllDataProvider>(
          builder: (context, consumer, child) {
            List<Person> blockedList = consumer.contacts
                .where((element) => element.blocked == true)
                .toList();
            if (blockedList.isEmpty) {
              return const Center(
                child: Text("No Blocked Contacts."),
              );
            }
            return ListView.builder(
                itemCount: blockedList.length,
                itemBuilder: (context, index) {
                  Person person = blockedList[index];
                  return ListTile(
                    textColor: CommonColors.redC,
                    contentPadding: const EdgeInsets.all(0),
                    leading: CA(
                      radius: 30,
                      image: Image.file(
                        File(person.image!),
                      ).image,
                    ),
                    title: Text(person.firstname),
                    subtitle: Text(person.phone),
                  );
                });
          },
        ),
      ),
    );
  }
}