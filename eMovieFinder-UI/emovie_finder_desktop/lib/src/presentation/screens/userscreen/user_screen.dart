import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/userscreen/user_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../models/dtos/requests/user/user_insert_request.dart';
import '../../../models/dtos/requests/user/user_update_request.dart';
import '../../../models/entities/user.dart';
import 'package:collection/collection.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/base_validator.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/helpers/image_helper.dart';
import '../../../utils/providers/constant_colors.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredUsers = [];

  late UserController userProvider;
  late BaseValidator validator;

  @override
  void initState() {
    super.initState();
    validator = BaseValidator();
    userProvider = UserController();
    userProvider.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _filterUsers(String query) {
    userProvider.getSearchResults(query);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserController>(
      create: (context) => userProvider,
      child: BlocConsumer<UserController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            if (state.message == "User has been updated successfully") {
              MyDialogUtils.showSuccessDialog(
                  context: context,
                  message: state.message,
                  posActionTitle: "Ok",
                  posAction: () {
                    Navigator.of(context).pop();
                    userProvider.fetchData();
                  });
            } else {
              MyDialogUtils.showSuccessDialog(
                context: context,
                message: state.message,
                posActionTitle: "Ok",
              );
            }
          } else if (state is ShowErrorMessageState) {
            MyDialogUtils.showErrorDialog(
              context: context,
              message: state.message,
              posActionTitle: "Try Again",
            );
          } else if (state is ShowQuestionMessageState) {
            MyDialogUtils.showQuestionDialog(
                context: context,
                message: state.message,
                posActionTitle: "Yes",
                posAction: () async {
                  userProvider.softDeleteUser(state.id as int);
                },
                negActionTitle: "No");
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is UserLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is UserLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is UserLoadedState) ||
              (previous is ShowSuccessMessageState &&
                  current is EmptyListState) ||
              (previous is LoadingState && current is ShowErrorMessageState);
        },
        builder: (context, state) {
          if (state is EmptyListState) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showAddUserDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add User",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: "Search user by username",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              String query = searchController.text;
                              _filterUsers(query);
                            },
                            icon: const Icon(Icons.search, color: Colors.white),
                            label: const Text(
                              "Search User",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              searchController.clear();
                              _filterUsers("");
                            },
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text(
                              "Reset Filter",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'No users available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoadedState) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: "Search user by username",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              String query = searchController.text;
                              _filterUsers(query);
                            },
                            icon: const Icon(Icons.search, color: Colors.white),
                            label: const Text(
                              "Search User",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              searchController.clear();
                              _filterUsers("");
                            },
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text(
                              "Reset Filter",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showAddUserDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add User",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        child: DataTable(
                          columnSpacing: 16,
                          columns: [
                            DataColumn(label: Text("Image")),
                            DataColumn(label: Text("Username")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Roles")),
                            DataColumn(label: Text("Account Banned")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: List.generate(
                            state.users?.length ?? 0,
                            (index) => userDataRow(
                              state.users![index],
                              context,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(
              child: Text(
                'Could Not Load The Users Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  DataRow userDataRow(User user, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          user.image != null
              ? Image.memory(
                  base64Decode(user.image),
                  width: 40,
                  height: 40,
                )
              : Image.asset(
                  'assets/images/user.png',
                  width: 40,
                  height: 40,
                ),
        ),
        DataCell(Text(user.identityUser?.userName ?? "No username")),
        DataCell(Text(user.identityUser?.email ?? "No email")),
        DataCell(
          Text(user.combinedRoles!.isNotEmpty
              ? user.combinedRoles!
              : 'No Roles'),
        ),
        DataCell(Text(
          user.identityUser?.lockoutEnd == null ? 'Not Banned' : 'Banned',
          style: TextStyle(
            color: user.identityUser?.lockoutEnd == null
                ? Colors.green
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        )),
        DataCell(
          DropdownButton<String>(
            hint: const Text(
              "Actions",
              style: TextStyle(fontSize: 14),
            ),
            items: [
              DropdownMenuItem(
                value: "Update",
                child: Container(
                  color: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text("Update",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
              DropdownMenuItem(
                value: "Soft Delete",
                child: Container(
                  color: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text("Soft Delete",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == "Update") {
                showEditUserDialog(context, user);
              } else if (value == "Soft Delete") {
                userProvider.onDeleteUserPress(
                    "Are You Sure You Want To Soft Delete This User?",
                    user.id!);
              }
            },
            underline: Container(),
            icon: Icon(Icons.arrow_drop_down, size: 20),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  void showAddUserDialog(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String currentImage = '';

    final controller = MultiSelectController<String>();

    List<Map<String, dynamic>> roles = [
      {"name": "Administrator", "value": 1},
      {"name": "User", "value": 2},
      {"name": "Customer ", "value": 3},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Add User",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                  key: _formKey,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormField<String>(
                            validator: (value) {
                              if (currentImage.isEmpty) {
                                return "Please select an image";
                              }
                              return null;
                            },
                            builder: (state) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                currentImage.isNotEmpty
                                    ? Image.memory(base64Decode(currentImage),
                                    width: 100, height: 100)
                                    : Icon(Icons.image, size: 100, color: Colors.grey),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    String? newImage = await ImageHelper.getImage(context);
                                    if (newImage != null) {
                                      setState(() {
                                        currentImage = newImage;
                                        imageController.text = currentImage;
                                      });
                                      state.didChange(currentImage);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: Text(
                                    "Change Image",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      state.errorText!,
                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(thickness: 1, color: Colors.grey),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: userNameController,
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Username mustn't be empty";
                              }
                              if (value.length > 10) {
                                return "Username Mustn't Exceed 10 Characters";
                              }
                              if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(value)){
                                return "Username Mustn't Have Special Characters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email mustn't be empty";
                              }
                              if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
                              r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(value)) {
                                return "Please Enter A Valid Email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password mustn't be empty";
                              }
                              if (value.length < 8) {
                                return "The Password Must be At Least 8 Characters Long";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Roles",
                            style: TextStyle(fontSize: 16),
                          ),
                          MultiDropdown<String>(
                            items: roles
                                .map((role) => DropdownItem<String>(
                                      label: role["name"],
                                      value: role["name"],
                                    ))
                                .toList(),
                            controller: controller,
                            enabled: true,
                            searchEnabled: false,
                            chipDecoration: const ChipDecoration(
                              backgroundColor: Colors.red,
                              wrap: true,
                              runSpacing: 2,
                              spacing: 10,
                            ),
                            fieldDecoration: FieldDecoration(
                              hintText: 'Select Roles',
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.white),
                              showClearIcon: false,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            dropdownDecoration: const DropdownDecoration(
                              marginTop: 2,
                              maxHeight: 500,
                              header: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Select roles from the list',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                            dropdownItemDecoration: DropdownItemDecoration(
                              backgroundColor: secondaryColor,
                              selectedBackgroundColor: secondaryColor,
                              selectedIcon: const Icon(Icons.check_box,
                                  color: Colors.green),
                              disabledIcon:
                                  Icon(Icons.lock, color: Colors.grey.shade300),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a role';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ));
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()) {
                  List<String> selectedRoles = controller.selectedItems
                      .map((item) => (item as DropdownItem<String>).value)
                      .toList();

                  var request = UserInsertRequest(
                      username: userNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      roles: selectedRoles,
                      imagePlainText: imageController.text);

                  await userProvider.insertUser(request);

                  userNameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text("Insert", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void showEditUserDialog(BuildContext context, User user) {
    TextEditingController userNameControllerUpdate = TextEditingController(text: user.identityUser?.userName);
    TextEditingController emailControllerUpdate = TextEditingController(text: user.identityUser?.email);
    TextEditingController passwordControllerUpdate = TextEditingController();
    TextEditingController imageControllerUpdate = TextEditingController(text: user.image ?? "");

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String currentImage = user.image ?? "";
    dynamic selectedValue = user.identityUser?.lockoutEnd == null ? "No" : "Yes";

    final controller = MultiSelectController<String>();

    List<Map<String, dynamic>> roles = [
      {"name": "Administrator", "value": 1},
      {"name": "User", "value": 2},
      {"name": "Customer", "value": 3},
    ];

    final List<String> selectedRoleNames =
    (user.combinedRoles ?? "").split(',').map((e) => e.trim()).toList();

    final List<DropdownItem<String>> dropdownRoleItems = roles.map((role) {
      bool isSelected = selectedRoleNames.contains(role["name"].toString().trim());

      return DropdownItem<String>(
        label: role["name"],
        value: role["name"],
        selected: isSelected,
      );
    }).toList();

    controller.setItems(dropdownRoleItems);

    controller.selectWhere((item) => selectedRoleNames.contains(item.value));

    List<Map<String, dynamic>> yesOrNo = [
      {"name": "Yes", "value": 1},
      {"name": "No", "value": 2},
    ];

    bool isPasswordChange = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Edit User",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                  key: _formKey,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormField<String>(
                            builder: (state) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                currentImage.isNotEmpty
                                    ? Image.memory(base64Decode(currentImage),
                                    width: 100, height: 100)
                                    : Icon(Icons.image, size: 100, color: Colors.grey),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    String? newImage = await ImageHelper.getImage(context);
                                    if (newImage != null) {
                                      setState(() {
                                        currentImage = newImage;
                                        imageControllerUpdate.text = currentImage;
                                      });
                                      state.didChange(currentImage);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: Text(
                                    "Change Image",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(thickness: 1, color: Colors.grey),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: userNameControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure username is not empty field";
                              }
                              if (value.length > 10) {
                                return "Username Mustn't Exceed 10 Characters";
                              }if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(value)){
                                return "Username Mustn't Have Special Characters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: emailControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure email is not empty field";
                              }
                              if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
                              r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(value)) {
                                return "Please Enter A Valid Email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: isPasswordChange,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isPasswordChange = value ?? false;
                                  });
                                },
                              ),
                              Text("Do you want to change user account password?")
                            ],
                          ),
                          if (isPasswordChange)
                          TextFormField(
                            controller: passwordControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure password is not empty field";
                              }
                              if (value.length < 8) {
                                return "The Password Must be At Least 8 Characters Long";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Roles",
                            style: TextStyle(fontSize: 16),
                          ),
                          MultiDropdown<String>(
                            items: dropdownRoleItems,
                            controller: controller,
                            enabled: true,
                            searchEnabled: false,
                            chipDecoration: const ChipDecoration(
                              backgroundColor: Colors.red,
                              wrap: true,
                              runSpacing: 2,
                              spacing: 10,
                            ),
                            fieldDecoration: FieldDecoration(
                              hintText: 'Select Roles',
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.white),
                              showClearIcon: false,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            dropdownDecoration: const DropdownDecoration(
                              marginTop: 2,
                              maxHeight: 500,
                              header: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Select roles from the list',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                            dropdownItemDecoration: DropdownItemDecoration(
                              backgroundColor: secondaryColor,
                              selectedBackgroundColor: secondaryColor,
                              selectedIcon: const Icon(Icons.check_box,
                                  color: Colors.green),
                              disabledIcon:
                                  Icon(Icons.lock, color: Colors.grey.shade300),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a role';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "User banned",
                            style: TextStyle(fontSize: 16),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<dynamic>(
                              isExpanded: true,
                              value: selectedValue,
                              hint: Text("Is user banned?",
                                  style: TextStyle(color: Colors.white)),
                              items: yesOrNo
                                  .map<DropdownMenuItem<dynamic>>((yesOrNo) {
                                return DropdownMenuItem<dynamic>(
                                  value: yesOrNo["name"],
                                  child: Text(
                                    yesOrNo["name"],
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  selectedValue = newValue;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey),
                                  color: secondaryColor,
                                ),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ));
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
    if(_formKey.currentState!.validate()) {
      List<String> selectedRoles = controller.selectedItems
          .map((item) => (item as DropdownItem<String>).value)
          .toList();

      bool isLockoutEnabled = selectedValue == "Yes";

      var request = UserUpdateRequest(
          username: userNameControllerUpdate.text,
          email: emailControllerUpdate.text,
          password: passwordControllerUpdate.text.isNotEmpty
              ? passwordControllerUpdate.text
              : "",
          roles:
          controller.selectedItems.isEmpty ? [] : selectedRoles,
          imagePlainText: imageControllerUpdate.text.isNotEmpty
              ? imageControllerUpdate.text
              : "",
          isLockoutEnabled: isLockoutEnabled);

      await userProvider.updateUser(user.id!, request);

      userNameControllerUpdate.clear();
      emailControllerUpdate.clear();
      passwordControllerUpdate.clear();
    }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
