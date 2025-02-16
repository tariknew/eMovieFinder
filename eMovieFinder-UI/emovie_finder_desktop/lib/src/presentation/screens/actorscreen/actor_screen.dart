import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/dtos/requests/actor/actor_insert_request.dart';
import '../../../models/dtos/requests/actor/actor_update_request.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/helpers/image_helper.dart';
import '../../../utils/providers/constant_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'actor_screen_view_model.dart';
import '../../../models/entities/actor.dart';
import '../countryscreen/country_screen_view_model.dart';

class ActorScreen extends StatefulWidget {
  const ActorScreen({Key? key}) : super(key: key);

  @override
  State<ActorScreen> createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  late ActorController actorProvider;

  @override
  void initState() {
    super.initState();
    actorProvider = ActorController();
    actorProvider.fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCountries();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchCountries() async {
    final response = await CountryController().fetchCountries();

    if (response != null) {
      actorProvider.countries = response;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActorController>(
      create: (context) => actorProvider,
      child: BlocConsumer<ActorController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            if (state.message == "Actor has been updated successfully") {
              MyDialogUtils.showSuccessDialog(
                  context: context,
                  message: state.message,
                  posActionTitle: "Ok",
                  posAction: () {
                    Navigator.of(context).pop();
                    actorProvider.fetchData();
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
                  actorProvider.deleteActor(state.id as int);
                },
                negActionTitle: "No");
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is ActorLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is ActorLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is ActorLoadedState) ||
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
                              showAddActorDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Actor",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'No actors available',
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
          } else if (state is ActorLoadedState) {
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
                              showAddActorDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Actor",
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
                            DataColumn(label: Text("First Name")),
                            DataColumn(label: Text("Last Name")),
                            DataColumn(label: Text("Birth Date")),
                            DataColumn(label: Text("Country")),
                            DataColumn(label: Text("IMDB Link")),
                            DataColumn(
                              label: Center(
                                child: Text("Biography"),
                              ),
                            ),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: List.generate(
                            state.actors?.length ?? 0,
                            (index) => actorDataRow(
                              state.actors![index],
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
                'Could Not Load The Actors Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  DataRow actorDataRow(Actor actor, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          actor.image != null
              ? Image.memory(
            base64Decode(actor.image),
            width: 40,
            height: 40,
          )
              : Image.asset(
            'assets/images/user.png',
            width: 40,
            height: 40,
          ),
        ),
        DataCell(Text(actor.firstName!)),
        DataCell(Text(actor.lastName!)),
        DataCell(Text(actor.formattedActorBirthDate!)),
        DataCell(Text(actor.formattedActorBirthPlace ?? "No birthplace")),
        DataCell(
          InkWell(
            child: Text(
              "IMDB",
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
            onTap: () async {
              final imDbUrl = 'https://www.imdb.com/name/${actor.imDbLink}';
              if (await canLaunch(imDbUrl.toString())) {
                await launch(imDbUrl.toString());
              }
            },
          ),
        ),
        DataCell(
          Center(
            child: Text(
              (actor.biography ?? 'No Biography').length > 28
                  ? '${(actor.biography ?? 'No Biography').substring(0, 28)}...'
                  : (actor.biography ?? 'No Biography'),
              textAlign: TextAlign.center,
            ),
          ),
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
                showEditActorDialog(context, actor);
              } else if (value == "Delete") {
                actorProvider.onDeleteActorPress(
                    "Are You Sure You Want To Delete This Actor?", actor.id!);
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

  void showEditActorDialog(BuildContext context, Actor actor) {
    dynamic currentImage = actor.image ?? "";

    TextEditingController firstNameControllerUpdate =
        TextEditingController(text: actor.firstName);
    TextEditingController lastNameControllerUpdate =
        TextEditingController(text: actor.lastName);
    TextEditingController birthDateControllerUpdate =
        TextEditingController(text: actor.formattedActorBirthDate);
    TextEditingController imdbLinkControllerUpdate =
        TextEditingController(text: actor.imDbLink);
    TextEditingController biographyControllerUpdate =
        TextEditingController(text: actor.biography);
    TextEditingController imageControllerUpdate =
        TextEditingController(text: currentImage);

    String initialFirstName = actor.firstName!;
    String initialLastName = actor.lastName!;
    String initialBirthDate = actor.formattedActorBirthDate!;
    String initialImdbLink = actor.imDbLink!;
    String initialBiography = actor.biography!;
    String initialImage = currentImage;
    int? initialSelectedCountry = actor.countryId;

    String? selectedCountry = actor.formattedActorBirthPlace;
    dynamic selectedCountryId = actor.countryId;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Edit Actor",
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
                          TextFormField(
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
                                initialDate: DateTime.parse(
                                    actor.formattedActorBirthDate!),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                birthDateControllerUpdate.text =
                                    pickedDate.toIso8601String().split('T')[0];
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          FormField<dynamic>(
                            builder: (FormFieldState<dynamic> state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Country",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2<dynamic>(
                                      isExpanded: true,
                                      value: selectedCountryId,
                                      hint: Text("Select Country"),
                                      items: (actorProvider.countries?.resultList ?? [])
                                          .map((country) => DropdownMenuItem<dynamic>(
                                        value: country.id,
                                        child: Text(
                                          country.countryName!,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ))
                                          .toList(),
                                      onChanged: (dynamic newValue) {
                                        state.didChange(newValue);
                                        setState(() {
                                          selectedCountryId = newValue;
                                          selectedCountry = actorProvider.countries?.resultList
                                              .firstWhere((country) => country.id == selectedCountryId)
                                              .countryName;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
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
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: imdbLinkControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "IMDB Identifier",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure IMDB identifier is not empty field";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: biographyControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "Biography",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(fontSize: 25),
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure biography is not empty field";
                              }
                              return null;
                            },
                            maxLines: 6,
                          )
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
                if(initialFirstName != firstNameControllerUpdate.text
                || initialLastName != lastNameControllerUpdate.text
                || initialImage != imageControllerUpdate.text
                || initialBirthDate != birthDateControllerUpdate.text
                || initialSelectedCountry != selectedCountryId
                || initialImdbLink != imdbLinkControllerUpdate.text
                || initialBiography != biographyControllerUpdate.text
                ) {
                  if (_formKey.currentState!.validate()) {
                    var request = ActorUpdateRequest(
                        firstName: firstNameControllerUpdate.text.isNotEmpty
                            ? firstNameControllerUpdate.text
                            : "",
                        lastName: lastNameControllerUpdate.text.isNotEmpty
                            ? lastNameControllerUpdate.text
                            : "",
                        imagePlainText: imageControllerUpdate.text.isNotEmpty
                            ? imageControllerUpdate.text
                            : "",
                        birthDate: birthDateControllerUpdate.text.isNotEmpty
                            ? DateTime.tryParse(birthDateControllerUpdate.text)
                            : null,
                        countryId:
                        selectedCountryId != null || selectedCountryId != 0
                            ? selectedCountryId
                            : null,
                        imDbLink: imdbLinkControllerUpdate.text.isNotEmpty
                            ? imdbLinkControllerUpdate.text
                            : "",
                        biography: biographyControllerUpdate.text.isNotEmpty
                            ? biographyControllerUpdate.text
                            : "");
                    await actorProvider.updateActor(actor.id!, request);

                    firstNameControllerUpdate.clear();
                    lastNameControllerUpdate.clear();
                    imageControllerUpdate.clear();
                    birthDateControllerUpdate.clear();
                    imdbLinkControllerUpdate.clear();
                    biographyControllerUpdate.clear();
                  }
                } else {
                  actorProvider.actorUpdatedScreenError();
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

  void showAddActorDialog(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController birthDateController = TextEditingController();
    TextEditingController imdbLinkController = TextEditingController();
    TextEditingController biographyController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    String? selectedCountry;
    String currentImage = '';
    dynamic selectedCountryId;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Add Actor",
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
                        SizedBox(height: 20),
                        FormField<dynamic>(
                          validator: (value) {
                            if (value == null) {
                              return "Please select a country";
                            }
                            return null;
                          },
                          builder: (FormFieldState<dynamic> state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Country",
                                  style: TextStyle(fontSize: 16),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<dynamic>(
                                    isExpanded: true,
                                    value: selectedCountryId,
                                    hint: Text("Select Country"),
                                    items: (actorProvider.countries?.resultList ?? [])
                                        .map((country) => DropdownMenuItem<dynamic>(
                                      value: country.id,
                                      child: Text(
                                        country.countryName!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (dynamic newValue) {
                                      state.didChange(newValue);
                                      setState(() {
                                        selectedCountryId = newValue;
                                        selectedCountry = actorProvider.countries?.resultList
                                            .firstWhere((country) => country.id == selectedCountryId)
                                            .countryName;
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
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
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      state.errorText!,
                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: imdbLinkController,
                          decoration: InputDecoration(
                            labelText: "IMDB Identifier",
                            labelStyle: TextStyle(fontSize: 20),
                            floatingLabelStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "IMDB identifier mustn't be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: biographyController,
                          decoration: InputDecoration(
                            labelText: "Biography",
                            labelStyle: TextStyle(fontSize: 20),
                            floatingLabelStyle: TextStyle(fontSize: 25),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Biography mustn't be empty";
                            }
                            return null;
                          },
                          maxLines: 6,
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
                  var request = ActorInsertRequest(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    imagePlainText: currentImage,
                    birthDate: DateTime.tryParse(birthDateController.text),
                    countryId: selectedCountryId,
                    imDbLink: imdbLinkController.text,
                    biography: biographyController.text,
                  );

                  await actorProvider.insertActor(request);

                  firstNameController.clear();
                  lastNameController.clear();
                  birthDateController.clear();
                  imdbLinkController.clear();
                  biographyController.clear();
                  imageController.clear();
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
