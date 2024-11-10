import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/contact/person.dart';
import '../../../view_model/all_data_provider/all_data_provider.dart';
import '../../screens/mains/view_contact/view_contact.dart';
import '../avatar/avatar.dart';
import '../navigator/navigator.dart';

class FGT extends StatefulWidget {
  const FGT({super.key});

  @override
  State<FGT> createState() => _FGTState();
}

class _FGTState extends State<FGT> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<AllDataProvider>(builder: (context, consumer, child) {
      List<Person> favList =
          consumer.contacts.where((element) => element.fav == true).toList();
      if (favList.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("No Favourites"),
            ],
          ),
        );
      }
      return Scrollbar(
        controller: _scrollController,
        child: GridView.builder(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(14),
            itemCount: favList.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                crossAxisSpacing: 13,
                mainAxisExtent: width * 0.4,
                maxCrossAxisExtent: width * 0.24),
            itemBuilder: (context, index) {
              Person person = favList[index];
              return GestureDetector(
                onTap: () {
                  NavigateRoute.push(
                      context,
                      ViewContact(
                        person: person,
                      ));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    person.image != null
                        ? Hero(
                            tag: person.image! + person.id!.toString(),
                            child: CA(
                              image: Image.file(File(person.image!)).image,
                              radius: width * 0.15,
                            ),
                          )
                        : Hero(
                            tag: "profile${person.firstname}",
                            child: CA(
                              radius: width * 0.15,
                              child: Icon(
                                Icons.person,
                                size: width * 0.15,
                              ),
                            ),
                          ),
                    Text(person.firstname),
                  ],
                ),
              );
            }),
      );
    });
  }
}
