import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/contact/person.dart';
import '../../../../view_model/all_data_provider/all_data_provider.dart';
import '../../../../view_model/theme/common.dart';
import '../../../../view_model/theme/theme.dart';
import '../../../widgets/avatar/avatar.dart';
import '../../../widgets/buttons/circle_button.dart';
import '../../../widgets/icons/appicons.dart';
import '../../../widgets/navigator/navigator.dart';
import '../../common_functions/commmon_functions.dart';
import '../../view_image/view_image.dart';
import '../add/add_contact.dart';

class ViewContact extends StatefulWidget {
  final Person person;

  const ViewContact({required this.person, super.key});

  @override
  State<ViewContact> createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  @override
  Widget build(BuildContext context) {
    final tag = ("${widget.person.image}${widget.person.id}");
    final themeColor = Provider.of<CtTheme>(context).currentTheme.colorScheme;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<AllDataProvider>(builder: (context, consumer, child) {
      Person person = consumer.filteredList
          .firstWhere((element) => element.id == widget.person.id);
      return Scaffold(
        backgroundColor: themeColor.secondary,
        appBar: AppBar(
          backgroundColor: themeColor.secondary,
          actions: [
            IconButton(
                onPressed: () {
                  NavigateRoute.push(
                      context,
                      AddContact(
                        contacts: consumer.contacts,
                        person: person,
                      ));
                },
                icon: AppIcons.edit),
            IconButton(
                onPressed: () {
                  if (person.fav!) {
                    consumer.toggleFav(context, person, false);
                  } else {
                    consumer.toggleFav(context, person, true);
                  }
                },
                icon: person.fav! ? AppIcons.star : AppIcons.starOutlined),
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: ListTile(
                        onTap: () {
                          shareContact(person);
                        },
                        title: const Text("Share"),
                        leading: AppIcons.share,
                      )),
                      PopupMenuItem(
                          child: ListTile(
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
                              ? Provider.of<AllDataProvider>(context,
                                      listen: false)
                                  .toggleBlock(context, send, true)
                              : Provider.of<AllDataProvider>(context,
                                      listen: false)
                                  .toggleBlock(context, send, false);
                          NavigateRoute.pop(context);
                        },
                        title: Text((person.blocked!) ? "Unblock" : "Block"),
                        leading: AppIcons.block,
                      )),
                      PopupMenuItem(
                          child: ListTile(
                        onTap: () async {
                          int result = await deleteContact(person);
                          if (result == 1 && context.mounted) {
                            NavigateRoute.pop(context);
                            NavigateRoute.pop(context);
                            Provider.of<AllDataProvider>(context, listen: false)
                                .refresh();
                          }
                        },
                        title: Text(
                          "Delete",
                          style: TextStyle(color: CommonColors.redC),
                        ),
                        leading: AppIcons.delete,
                      )),
                    ])
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                person.image != null
                    ? GestureDetector(
                        onTap: () {
                          NavigateRoute.push(
                              context,
                              ViewImage(
                                image: person.image!,
                                tag: tag,
                              ));
                        },
                        child: Hero(
                          tag: tag,
                          child: CA(
                            image: Image.file(File(person.image!)).image,
                            radius: width * 0.25,
                          ),
                        ),
                      )
                    : Hero(
                        tag: "profile${person.firstname}",
                        child: CA(
                          radius: width * 0.25,
                          child: Icon(
                            Icons.person,
                            size: width * 0.3,
                          ),
                        ),
                      ),
                SizedBox(
                  height: height * 0.03,
                ),
                Visibility(
                  visible: person.firstname != "" || person.lastname != "",
                  child: Text(
                    "${person.firstname} ${person.lastname}",
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CButton(
                        text: "Call",
                        event: () {
                          callNumber(person.phone, context);
                        },
                        icon: AppIcons.call),
                    CButton(
                        event: () {
                          message(person.phone);
                        },
                        icon: AppIcons.sms,
                        text: "Text"),
                    CButton(
                        text: "Video Call", event: () {}, icon: AppIcons.vCall),
                    CButton(
                        text: "Email",
                        event: () {
                          if (person.email!.isNotEmpty) {
                            email(person.email!);
                          } else {
                            showSnack("Email is not provided!!", context);
                          }
                        },
                        icon: AppIcons.email)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                      color: themeColor.onSecondary,
                      borderRadius: BorderRadius.circular(15)),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Contact Info",
                        style: TextStyle(fontSize: 17),
                      ),
                      ListTile(
                        onTap: () {
                          callNumber(person.phone, context);
                        },
                        contentPadding: const EdgeInsets.all(0),
                        leading: AppIcons.call,
                        title: Text(person.phone),
                        subtitle: const Text("Mobile-Default"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: () {}, icon: AppIcons.vCall),
                            IconButton(
                                onPressed: () {
                                  message(person.phone);
                                },
                                icon: AppIcons.sms)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
