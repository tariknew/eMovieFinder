import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/country/country_insert_request.dart';
import '../../../models/dtos/requests/country/country_update_request.dart';
import '../../../models/entities/country.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/providers/constant_colors.dart';
import '../countryscreen/country_screen_view_model.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  late CountryController countryProvider;

  @override
  void initState() {
    super.initState();
    countryProvider = CountryController();
    countryProvider.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CountryController>(
      create: (context) => countryProvider,
      child: BlocConsumer<CountryController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            if (state.message == "Country has been updated successfully") {
              MyDialogUtils.showSuccessDialog(
                  context: context,
                  message: state.message,
                  posActionTitle: "Ok",
                  posAction: () {
                    Navigator.of(context).pop();
                    countryProvider.fetchData();
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
                  countryProvider.deleteCountry(state.id as int);
                },
                negActionTitle: "No");
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is CountryLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is CountryLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is CountryLoadedState) ||
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
                              showAddCountryDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Country",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'No countries available',
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
          } else if (state is CountryLoadedState) {
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
                              showAddCountryDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Country",
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
                            DataColumn(label: Text("Country Name")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: List.generate(
                            state.countries?.length ?? 0,
                                (index) =>
                                countryDataRow(
                                  state.countries![index],
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
                'Could Not Load The Countries Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  DataRow countryDataRow(Country country, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(country.countryName!.toString())),
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
                showEditCountryDialog(context, country);
              } else if (value == "Delete") {
                countryProvider.onDeleteCountryPress(
                    "Are You Sure You Want To Delete This Country?",
                    country.id!);
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

  void showEditCountryDialog(BuildContext context, Country country) {
    TextEditingController countryNameControllerUpdate =
    TextEditingController(text: country.countryName);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String initialCountryName = country.countryName!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Edit Country",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                  key: _formKey,
              child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: countryNameControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "Country Name",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure country name is not empty field";
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
                if(initialCountryName != countryNameControllerUpdate.text) {
                  if (_formKey.currentState!.validate()) {
                    var request = CountryUpdateRequest(
                        countryName: countryNameControllerUpdate.text
                    );

                    await countryProvider.updateCountry(country.id!, request);

                    countryNameControllerUpdate.clear();
                  }
                } else {
                  countryProvider.countryUpdatedScreenError("You must change at least one input field to update the country");
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

  void showAddCountryDialog(BuildContext context) {
    TextEditingController countryNameController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Add Country",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: countryNameController,
                          decoration: InputDecoration(
                            labelText: "Country Name",
                            labelStyle: TextStyle(fontSize: 20),
                            floatingLabelStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Country name mustn't be empty";
                            }
                            return null;
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
                  var request = CountryInsertRequest(
                      countryName: countryNameController.text
                  );

                  await countryProvider.insertCountry(request);

                  countryNameController.clear();
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
