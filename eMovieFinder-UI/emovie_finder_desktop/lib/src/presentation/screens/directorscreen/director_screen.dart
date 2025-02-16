import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/director/director_insert_request.dart';
import '../../../models/dtos/requests/director/director_update_request.dart';
import '../../../models/entities/director.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/providers/constant_colors.dart';
import 'package:intl/intl.dart';
import 'director_screen_view_model.dart';

class DirectorScreen extends StatefulWidget {
  const DirectorScreen({Key? key}) : super(key: key);

  @override
  State<DirectorScreen> createState() => _DirectorScreenState();
}

class _DirectorScreenState extends State<DirectorScreen> {
  late DirectorController directorProvider;

  @override
  void initState() {
    super.initState();
    directorProvider = DirectorController();
    directorProvider.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DirectorController>(
      create: (context) => directorProvider,
      child: BlocConsumer<DirectorController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            if (state.message == "Director has been updated successfully") {
              MyDialogUtils.showSuccessDialog(
                  context: context,
                  message: state.message,
                  posActionTitle: "Ok",
                  posAction: () {
                    Navigator.of(context).pop();
                    directorProvider.fetchData();
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
                  directorProvider.deleteDirector(state.id as int);
                },
                negActionTitle: "No");
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is DirectorLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is DirectorLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is DirectorLoadedState) ||
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
                              showAddDirectorDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Director",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'No directors available',
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
          } else if (state is DirectorLoadedState) {
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
                              showAddDirectorDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Director",
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
                            DataColumn(label: Text("First Name")),
                            DataColumn(label: Text("Last Name")),
                            DataColumn(label: Text("BirthDate")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: List.generate(
                            state.directors?.length ?? 0,
                                (index) => directorDataRow(
                              state.directors![index],
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
                'Could Not Load The Directors Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  DataRow directorDataRow(Director director, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(director.firstName!.toString())),
        DataCell(Text(director.lastName!.toString())),
        DataCell(
          Text(DateFormat('yyyy-MM-dd').format(director.birthDate!)),
        ),
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
                value: "Delete",
                child: Container(
                  color: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text("Delete",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == "Update") {
                showEditDirectorDialog(context, director);
              } else if (value == "Delete") {
                directorProvider.onDeleteDirectorPress(
                    "Are You Sure You Want To Delete This Director?",
                    director.id!);
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

  void showEditDirectorDialog(BuildContext context, Director director) {
    TextEditingController firstNameControllerUpdate =
    TextEditingController(text: director.firstName);
    TextEditingController lastNameControllerUpdate =
    TextEditingController(text: director.lastName);
    TextEditingController birthDateControllerUpdate =
    TextEditingController(text: DateFormat('yyyy-MM-dd').format(director.birthDate!).toString());

    String initialDirectorFirstName = director.firstName!;
    String initialDirectorLastName = director.lastName!;
    String initialDirectorBirthDate = DateFormat('yyyy-MM-dd').format(director.birthDate!).toString();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Edit Director",
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
                          TextFormField(
                            controller: firstNameControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure first name is not empty field";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: lastNameControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure last name is not empty field";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: birthDateControllerUpdate,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Birth Date",
                              labelStyle: TextStyle(fontSize: 20),
                              suffixIcon: Icon(Icons.calendar_today),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                DateTime.parse(initialDirectorBirthDate),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                birthDateControllerUpdate.text =
                                pickedDate.toIso8601String().split('T')[0];
                              }
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
                if (initialDirectorFirstName != firstNameControllerUpdate.text ||
                    initialDirectorLastName != lastNameControllerUpdate.text ||
                    initialDirectorBirthDate != birthDateControllerUpdate.text) {
                  if(_formKey.currentState!.validate()) {
                    var request = DirectorUpdateRequest(
                        firstName: firstNameControllerUpdate.text,
                        lastName: lastNameControllerUpdate.text,
                        birthDate:
                        DateTime.tryParse(birthDateControllerUpdate.text));

                    await directorProvider.updateDirector(
                        director.id!, request);

                    firstNameControllerUpdate.clear();
                    lastNameControllerUpdate.clear();
                    birthDateControllerUpdate.clear();
                  }
                } else {
                  directorProvider.directorUpdatedScreenError(
                      "You must change at least one input field to update the director");
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

  void showAddDirectorDialog(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController birthDateController = TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Add Director",
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
                      TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: "First Name",
                            labelStyle: TextStyle(fontSize: 20),
                            floatingLabelStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
              validator: (value) {
              if (value == null || value.isEmpty) {
              return "First name mustn't be empty";
              }
              return null;
              },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            labelStyle: TextStyle(fontSize: 20),
                            floatingLabelStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
              validator: (value) {
              if (value == null || value.isEmpty) {
              return "Last name mustn't be empty";
              }
              return null;
              },
                        ),
                        SizedBox(height: 20),
              TextFormField(
                          controller: birthDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Birth Date",
                            labelStyle: TextStyle(fontSize: 20),
                            suffixIcon: Icon(Icons.calendar_today),
                            floatingLabelStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
              validator: (value) {
              if (value == null || value.isEmpty) {
              return "Birth date mustn't be empty";
              }
              return null;
              },
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              birthDateController.text =
                              pickedDate.toIso8601String().split('T')[0];
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              );
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
                  var request = DirectorInsertRequest(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      birthDate: DateTime.tryParse(birthDateController.text));

                  await directorProvider.insertDirector(request);

                  firstNameController.clear();
                  lastNameController.clear();
                  birthDateController.clear();
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
}
