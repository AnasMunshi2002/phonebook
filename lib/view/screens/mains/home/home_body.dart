import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/contact/person.dart';
import '../../../../view_model/all_data_provider/all_data_provider.dart';
import '../../../../view_model/filter_provider/filter_provider.dart';
import '../../../../view_model/theme/theme.dart';
import '../../../widgets/contact_list_tile/contact_list_tile.dart';
import '../../../widgets/icons/appicons.dart';
import '../../../widgets/profile_button/profile_button.dart';
import '../../common_functions/commmon_functions.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final ScrollController _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initContacts();
  }

  Future<void> _initContacts() async {
    final allDataProvider =
        Provider.of<AllDataProvider>(context, listen: false);
    await allDataProvider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final allDataProvider = Provider.of<AllDataProvider>(context);
    final themeColor = context.watch<CtTheme>().currentTheme.colorScheme;
    final height = MediaQuery.of(context).size.height;
    final String today = DateTime.now().toString().split(" ")[0];
    final todayDate = "${today.split("-")[1]}-${today.split("-")[2]}";

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 14, bottom: 3),
        child: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool isScrolled) {
            return [
              SliverAppBar(
                scrolledUnderElevation: 0,
                snap: true,
                floating: true,
                backgroundColor: themeColor.secondary,
                title: SizedBox(
                  height: height * 0.07,
                  child: SearchBar(
                    onChanged: (value) {
                      search(value, allDataProvider);
                    },
                    trailing: const [PButton()],
                    elevation: const WidgetStatePropertyAll(0),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 15)),
                    hintText: "Search contacts",
                    backgroundColor:
                        WidgetStatePropertyAll(themeColor.onSecondary),
                    controller: _searchController,
                    leading: AppIcons.search,
                  ),
                ),
                bottom: PreferredSize(
                    preferredSize: Size(double.maxFinite, height * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextButton(
                              autofocus: true,
                              style: ButtonStyle(
                                  padding: const WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(horizontal: 6)),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7)))),
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: themeColor.secondary,
                                    showDragHandle: true,
                                    context: context,
                                    enableDrag: true,
                                    builder: (context) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              trailing: Text(allDataProvider
                                                  .filteredList.length
                                                  .toString()),
                                              title: const Text("All contacts"),
                                              leading: AppIcons.people,
                                            ),
                                          ],
                                        ));
                              },
                              child: Row(
                                children: [
                                  AppIcons.people,
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text("All Contacts"),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  AppIcons.arrowDown,
                                ],
                              )),
                        ),
                        Row(
                          children: [
                            PopupMenuButton(
                              menuPadding: const EdgeInsets.all(0),
                              icon: AppIcons.aToZ,
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () {
                                      context
                                          .read<AllDataProvider>()
                                          .changePref("name", "asc", context);
                                    },
                                    child: const ListTile(
                                      title: Text("Sort by Name"),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      context
                                          .read<AllDataProvider>()
                                          .changePref("number", "asc", context);
                                    },
                                    child: const ListTile(
                                      title: Text("Sort by number"),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      context
                                          .read<AllDataProvider>()
                                          .changePref("date", "asc", context);
                                    },
                                    child: const ListTile(
                                      title: Text("Sort by Date"),
                                    ),
                                  ),
                                ];
                              },
                            ),
                            PopupMenuButton(
                              menuPadding: const EdgeInsets.all(0),
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    padding: const EdgeInsets.all(0),
                                    child: Consumer<FilterProvider>(
                                        builder: (context, consumer, child) {
                                      return CheckboxListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 7),
                                        value: consumer.isFav,
                                        onChanged: (value) {
                                          consumer.changeFav(value!);
                                          context
                                              .read<AllDataProvider>()
                                              .filter(context);
                                        },
                                        title: const Text(
                                          "Favourites",
                                          overflow: TextOverflow.visible,
                                          softWrap: false,
                                        ),
                                      );
                                    }),
                                  ),
                                  PopupMenuItem(
                                    padding: const EdgeInsets.all(0),
                                    child: Consumer<FilterProvider>(
                                        builder: (context, consumer, child) {
                                      return CheckboxListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 7),
                                        value: consumer.isBlocked,
                                        onChanged: (value) {
                                          consumer.changeBlock(value!);
                                          context
                                              .read<AllDataProvider>()
                                              .filter(context);
                                        },
                                        title: const Text(
                                          "Blocked",
                                          overflow: TextOverflow.visible,
                                          softWrap: false,
                                        ),
                                      );
                                    }),
                                  ),
                                  PopupMenuItem(
                                    padding: const EdgeInsets.all(0),
                                    child: Consumer<FilterProvider>(
                                        builder: (context, consumer, child) {
                                      return CheckboxListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 7),
                                        value: consumer.noName,
                                        onChanged: (value) {
                                          consumer.changeNoName(value!);
                                          context
                                              .read<AllDataProvider>()
                                              .filter(context);
                                        },
                                        title: const Text(
                                          "Nameless",
                                          overflow: TextOverflow.visible,
                                          softWrap: false,
                                        ),
                                      );
                                    }),
                                  )
                                ];
                              },
                              child: AppIcons.filter,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ];
          },
          body: Consumer<AllDataProvider>(
            builder: (context, consumer, child) {
              return Scrollbar(
                interactive: true,
                thumbVisibility: true,
                controller: _scrollController,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: consumer.filteredList.length,
                  itemBuilder: (context, index) {
                    Person person = consumer.filteredList[index];
                    if (person.firstname.isNotEmpty ||
                        person.lastname!.isNotEmpty) {
                      String? name = person.firstname == ""
                          ? person.lastname
                          : person.firstname;
                      WidgetsBinding.instance.addPostFrameCallback(
                        (timeStamp) {
                          if (person.birthday?.contains(todayDate) ?? false) {
                            showBirthdayReminder(
                                context, person, themeColor, name);
                          }
                        },
                      );
                    }
                    return CTile(person: person, consumer: consumer);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
