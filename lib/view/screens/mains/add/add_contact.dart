import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../models/contact/person.dart';
import '../../../../services/database/contacts/add/add_contact.dart';
import '../../../../view_model/all_data_provider/all_data_provider.dart';
import '../../../../view_model/contact_provider/contact_provider.dart';
import '../../../../view_model/theme/common.dart';
import '../../../../view_model/theme/theme.dart';
import '../../../widgets/avatar/avatar.dart';
import '../../../widgets/icons/appicons.dart';
import '../../../widgets/navigator/navigator.dart';
import '../../../widgets/tf/tf.dart';
import '../../common_functions/commmon_functions.dart';

class AddContact extends StatefulWidget {
  final List<Person> contacts;
  final Person? person;

  const AddContact({required this.contacts, super.key, this.person});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final DBManager _dbManager = DBManager();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _prefixController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  XFile? image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.person != null) {
        _firstNameController.text = widget.person!.firstname;
        _lastNameController.text = widget.person!.lastname!;
        _prefixController.text = widget.person!.prefix!;
        _phoneController.text = widget.person!.phone;
        _emailController.text = widget.person!.email!;
        _addressController.text = widget.person!.address!;
        if (widget.person?.image != null) {
          image = XFile(widget.person!.image!);
          if (context.mounted) {
            Provider.of<ContactProvider>(context, listen: false)
                .setProfile(image!);
          }
        }
        Provider.of<ContactProvider>(context, listen: false)
            .changeFav(widget.person!.fav ?? false);

        Provider.of<ContactProvider>(context, listen: false)
            .setBirthdate(widget.person!.birthday ?? "Select DOB");
      }
    });
  }

  void _clearControllers(ContactProvider contactProvider) {
    _emailController.clear();
    _lastNameController.clear();
    _firstNameController.clear();
    _phoneController.clear();
    _prefixController.clear();
    _addressController.clear();
    contactProvider.isFav = false;
    contactProvider.birthdate = "Select DOB";
    contactProvider.profileImage = null;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<CtTheme>().currentTheme.colorScheme;
    final contactProvider = Provider.of<ContactProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (context, dynamic) {
        _clearControllers(contactProvider);
      },
      child: Scaffold(
        backgroundColor: themeColor.secondary,
        appBar: AppBar(
          backgroundColor: themeColor.secondary,
          leading: IconButton(
              onPressed: () {
                NavigateRoute.pop(context);
              },
              icon: AppIcons.close),
          title: const Text("Create contact"),
          actions: [
            FilledButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(CommonColors.profile)),
              onPressed: () async {
                String firstName = _firstNameController.text.trim();
                String lastName = _lastNameController.text.trim();
                String prefix = _prefixController.text.trim();
                String phone = _phoneController.text.trim();
                String email = _emailController.text.trim();
                String address = _addressController.text.trim();
                if (firstName.isEmpty && phone.isEmpty) {
                  showSnack("Name or phone cannot be empty!", context);
                  return;
                }
                if (widget.person == null) {
                  if (widget.contacts
                      .any((element) => element.phone == phone)) {
                    showSnack("Already present in contact list!", context);
                    return;
                  }
                }
                if (!validatePhone(phone, context)) {
                  showSnack("Invalid phone number!", context);
                  return;
                }
                Person person = Person(
                    id: widget.person?.id,
                    firstname: firstName,
                    lastname: lastName,
                    prefix: prefix,
                    phone: phone,
                    email: email,
                    address: address,
                    addDate: DateTime.now().toString(),
                    image: image?.path,
                    birthday: contactProvider.birthdate,
                    fav: contactProvider.isFav,
                    blocked: false);

                int result = widget.person != null
                    ? await _dbManager.updateContact(person)
                    : await _dbManager.addContact(person);
                if (context.mounted) {
                  if (result > 0) {
                    widget.person != null
                        ? showSnack("Successfully Updated", context)
                        : showSnack("Successfully Added", context);

                    Provider.of<AllDataProvider>(context, listen: false)
                        .refresh();

                    Navigator.pop(context, true);
                    _clearControllers(contactProvider);
                  }
                }
              },
              child: const Text("Save"),
            ),
            PopupMenuButton(
              menuPadding: const EdgeInsets.all(0),
              itemBuilder: (context) =>
                  [const PopupMenuItem(child: Text("Help & feedback"))],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: width,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.07,
                ),
                SizedBox(
                  height: width * 0.4,
                  width: width * 0.4,
                  child: FilledButton(
                      style: ButtonStyle(
                          alignment: Alignment.center,
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.all(0),
                          ),
                          backgroundColor:
                              WidgetStatePropertyAll(themeColor.secondaryFixed),
                          shape: const WidgetStatePropertyAll(CircleBorder())),
                      onPressed: () async {
                        image = await pickImage(context);
                        if (image != null) {
                          contactProvider.setProfile(image!);
                        }
                      },
                      child: contactProvider.profileImage != null
                          ? CA(
                              radius: double.infinity,
                              image: contactProvider.profileImage!.image,
                            )
                          : AppIcons.photoPlaceholder),
                ),
                FilledButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(themeColor.secondaryFixed)),
                  child: Text(
                    "Add picture",
                    style: TextStyle(color: CommonColors.blackC),
                  ),
                  onPressed: () async {
                    XFile? image = await pickImage(context);
                    if (image != null) {
                      contactProvider.setProfile(image);
                    }
                  },
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: contactProvider.isFav,
                      onChanged: (value) {
                        contactProvider.changeFav(value!);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Add to Favourites"),
                  ],
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Tf(
                  controller: _prefixController,
                  hint: "prefix",
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Tf(
                  hint: "First Name",
                  controller: _firstNameController,
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Tf(
                  controller: _lastNameController,
                  hint: "Last Name",
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Tf(
                  type: TextInputType.phone,
                  hint: "Phone",
                  controller: _phoneController,
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Tf(
                  type: TextInputType.emailAddress,
                  hint: "Email",
                  controller: _emailController,
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () async {
                              DateTime? result = await getDOB(context);
                              if (result != null) {
                                contactProvider.setBirthdate(
                                    result.toString().split(" ")[0]);
                              }
                            },
                            child: Text(
                                contactProvider.birthdate ?? "Select DOB"))),
                  ],
                ),
                SizedBox(
                  height: width * 0.06,
                ),
                Tf(
                  hint: "Address",
                  controller: _addressController,
                ),
                SizedBox(
                  height: height * 0.08,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _prefixController.dispose();
    _addressController.dispose();
    image = null;
    super.dispose();
  }
}

showSnack(String message, BuildContext context) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
