import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/contact/person.dart';
import '../../../view_model/all_data_provider/all_data_provider.dart';
import '../../../view_model/theme/common.dart';
import '../../screens/common_functions/commmon_functions.dart';
import '../../screens/mains/add/add_contact.dart';
import '../../screens/mains/view_contact/view_contact.dart';
import '../avatar/avatar.dart';
import '../icons/appicons.dart';
import '../navigator/navigator.dart';

class CTile extends StatelessWidget {
  final Person person;
  final AllDataProvider consumer;

  const CTile({required this.person, super.key, required this.consumer});

  Future dialog(BuildContext context, Person person) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () {
                      NavigateRoute.pop(context);
                      NavigateRoute.push(
                          context,
                          AddContact(
                            contacts: consumer.contacts,
                            person: person,
                          ));
                    },
                    trailing: AppIcons.edit,
                    title: const Text("Update Contact"),
                  ),
                  ListTile(
                    onTap: () async {
                      int result = await deleteContact(person);
                      if (result == 1 && context.mounted) {
                        NavigateRoute.pop(context);
                        Provider.of<AllDataProvider>(context, listen: false)
                            .refresh();
                      }
                    },
                    iconColor: CommonColors.redC,
                    textColor: CommonColors.redC,
                    trailing: AppIcons.delete,
                    title: const Text("Delete Contact"),
                  ),
                  ListTile(
                    onTap: () {
                      Person send = Person(
                          addDate: person.addDate,
                          firstname: person.firstname,
                          phone: person.phone,
                          prefix: person.prefix,
                          fav: person.fav,
                          birthday: person.birthday,
                          lastname: person.lastname,
                          image: person.image,
                          email: person.email,
                          address: person.address,
                          id: person.id);
                      !person.blocked!
                          ? Provider.of<AllDataProvider>(context, listen: false)
                              .toggleBlock(context, send, true)
                          : Provider.of<AllDataProvider>(context, listen: false)
                              .toggleBlock(context, send, false);
                      NavigateRoute.pop(context);
                    },
                    trailing: AppIcons.block,
                    title: Text(
                        "${(person.blocked!) ? "Unblock" : "Block"} Contact"),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    String fullName = "${person.firstname} ${person.lastname!}";
    final width = MediaQuery.of(context).size.width;

    return ListTile(
      onLongPress: () {
        dialog(context, person);
      },
      onTap: () {
        NavigateRoute.push(
            context,
            ViewContact(
              person: person,
            ));
      },
      title: Text(
        fullName,
        style: TextStyle(
          color: person.blocked! ? CommonColors.redC : null,
        ),
      ),
      subtitle: Text(
        person.phone,
        style: TextStyle(
          color: person.blocked! ? CommonColors.redC : null,
        ),
      ),
      leading: (person.blocked ?? false)
          ? CA(
              radius: width * 0.07,
              child: AppIcons.redBlock,
            )
          : person.image != null
              ? Hero(
                  tag: person.image! + person.id!.toString(),
                  child: CA(
                    image: Image.file(File(person.image!)).image,
                    radius: width * 0.07,
                  ),
                )
              : Hero(
                  tag: "profile${person.firstname}",
                  child: CA(
                    radius: width * 0.07,
                    child: AppIcons.person,
                  ),
                ),
      trailing: person.blocked ?? false
          ? null
          : person.fav!
              ? AppIcons.star
              : null,
    );
  }
}
