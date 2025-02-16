import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../models/dtos/requests/movie/movie_insert_request.dart';
import '../../../models/dtos/requests/movie/movie_update_request.dart';
import '../../../models/entities/movie.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/helpers/image_helper.dart';
import '../../../utils/providers/constant_colors.dart';
import '../actorscreen/actor_screen_view_model.dart';
import '../categoryscreen/category_screen_view_model.dart';
import '../countryscreen/country_screen_view_model.dart';
import '../directorscreen/director_screen_view_model.dart';
import '../mainscreen/menu_view_model.dart';
import 'movie_screen_view_model.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late MovieController movieProvider;

  @override
  void initState() {
    super.initState();
    movieProvider = MovieController();
    movieProvider.fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchActors();
      await fetchCategories();
      await fetchCountries();
      await fetchDirectors();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchCategories() async {
    final response = await CategoryController().fetchCategories();

    if (response != null) {
      movieProvider.categories = response;
      setState(() {});
    }
  }

  Future<void> fetchActors() async {
    final response = await ActorController().fetchActors();

    if (response != null) {
      movieProvider.actors = response;
      setState(() {});
    }
  }

  Future<void> fetchCountries() async {
    final response = await CountryController().fetchCountries();

    if (response != null) {
      movieProvider.countries = response;
      setState(() {});
    }
  }

  Future<void> fetchDirectors() async {
    final response = await DirectorController().fetchDirectors();

    if (response != null) {
      movieProvider.directors = response;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieController>(
      create: (context) => movieProvider,
      child: BlocConsumer<MovieController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            if (state.message == "Movie has been updated successfully") {
              MyDialogUtils.showSuccessDialog(
                  context: context,
                  message: state.message,
                  posActionTitle: "Ok",
                  posAction: () {
                    Navigator.of(context).pop();
                    movieProvider.fetchData();
                  });
            } else if (state.message ==
                "Movie has been inserted successfully, we are redicting you to page to add actors character names") {
              MyDialogUtils.showSuccessDialog(
                context: context,
                message: state.message,
                posActionTitle: "Ok",
                posAction: () {
                  context.read<SideMenuController>().onChangeSelectedMenu(7);
                },
              );
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
                  movieProvider.deleteMovie(state.id as int);
                },
                negActionTitle: "No");
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is MovieLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is MovieLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is MovieLoadedState) ||
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
                              showAddMovieDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Movie",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'No movies available',
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
          } else if (state is MovieLoadedState) {
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
                              showAddMovieDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Movie",
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
                          columnSpacing: 11,
                          columns: [
                            DataColumn(label: Text("Title")),
                            DataColumn(label: Text("Image")),
                            DataColumn(label: Text("Duration")),
                            DataColumn(label: Text("Director")),
                            DataColumn(label: Text("Country")),
                            DataColumn(label: Text("YouTube Link")),
                            DataColumn(label: Text("Price")),
                            DataColumn(label: Text("Movie State")),
                            DataColumn(label: Text("Discount")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: List.generate(
                            state.movies?.length ?? 0,
                                (index) => movieDataRow(
                              state.movies![index],
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
                'Could Not Load The Movies Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  DataRow movieDataRow(Movie movie, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            movie.title != null && movie.title!.length > 5
                ? '${movie.title!.substring(0, 5)}...'
                : (movie.title ?? "No Title"),
          ),
        ),
        DataCell(
          movie.image != null
              ? Image.memory(
            base64Decode(movie.image),
            width: 40,
            height: 40,
          )
              : Image.asset(
            'assets/images/empty.png',
            width: 40,
            height: 40,
          ),
        ),
        DataCell(Text(movie.formattedDuration ?? "No Duration")),
        DataCell(
          Text(
            movie.directorName != null && movie.directorName!.length > 5
                ? '${movie.directorName!.substring(0, 5)}...'
                : (movie.directorName ?? "No Director Name"),
          ),
        ),
        DataCell(Text(movie.country?.countryName ?? "No Country Name")),
        DataCell(
          InkWell(
            child: Text(
              "YouTube Link",
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
            onTap: () async {
              final trailerLink = 'https://www.youtube.com/watch?v=${movie.trailerLink}';
              if (await canLaunch(trailerLink.toString())) {
                await launch(trailerLink.toString());
              }
            },
          ),
        ),
        DataCell(Text(movie.formattedPrice ?? "No Price")),
        DataCell(
          Text(
            movie.formattedMovieState ?? "No Movie State",
            style: TextStyle(
              color: (movie.formattedMovieState == "Discounted" ||
                  movie.formattedMovieState == "Draft")
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        ),
        DataCell(
          Text(
            movie.formattedDiscount == "No Discount"
                ? "No Discount"
                : movie.formattedDiscount!,
            style: TextStyle(
              color: movie.formattedDiscount == "No Discount"
                  ? Colors.red
                  : Colors.white,
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
                showEditMovieDialog(context, movie);
              } else if (value == "Delete") {
                movieProvider.onDeleteMoviePress(
                    "Are You Sure You Want To Delete This Movie?", movie.id!);
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

  void showAddMovieDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController releaseDateController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    TextEditingController trailerLinkController = TextEditingController();
    TextEditingController storyLineController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    dynamic selectedDirectorId;
    dynamic selectedCountryId;
    dynamic selectedMovieState;
    dynamic selectedMovieStateValue;
    String? selectedDirector;
    String? selectedCountry;
    String? errorMessage;
    String currentImage = '';

    final controller1 = MultiSelectController<String>();
    final controller2 = MultiSelectController<String>();

    List<Map<String, dynamic>> movieStates = [
      {"name": "Draft", "value": 0},
      {"name": "Published", "value": 1},
      {"name": "Discounted", "value": 2},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Add Movie",
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
                            controller: titleController,
                            decoration: InputDecoration(
                                labelText: "Movie Title",
                                labelStyle: TextStyle(fontSize: 20),
                                floatingLabelStyle: TextStyle(
                                  fontSize: 25,
                                ),
                                errorText: errorMessage
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Movie title mustn't be empty";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: releaseDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Release Date",
                              labelStyle: TextStyle(fontSize: 20),
                              suffixIcon: Icon(Icons.calendar_today),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Release date mustn't be empty";
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
                                releaseDateController.text =
                                pickedDate.toIso8601String().split('T')[0];
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              int? pickedDuration = await showDurationPicker(
                                context,
                                currentDuration:
                                int.tryParse(durationController.text) ?? 0,
                              );
                              if (pickedDuration != null) {
                                setState(() {
                                  durationController.text =
                                      pickedDuration.toString();
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: durationController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Duration",
                                  labelStyle: TextStyle(fontSize: 20),
                                  floatingLabelStyle: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Duration mustn't be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          FormField<dynamic>(
                            validator: (value) {
                              if (value == null) {
                                return "Please select a director";
                              }
                              return null;
                            },
                            builder: (FormFieldState<dynamic> state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Director",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2<dynamic>(
                                      isExpanded: true,
                                      value: selectedDirectorId,
                                      hint: Text("Select Director"),
                                      items: (movieProvider.directors?.resultList ?? [])
                                          .map((director) => DropdownMenuItem<dynamic>(
                                        value: director.id,
                                        child: Text(
                                          director.formattedDirectorRealName!,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ))
                                          .toList(),
                                      onChanged: (dynamic newValue) {
                                        state.didChange(newValue);
                                        setState(() {
                                          selectedDirectorId = newValue;
                                          selectedDirector = movieProvider.directors?.resultList
                                              .firstWhere((director) => director.id == selectedDirectorId)
                                              .formattedDirectorRealName;
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
                                      items: (movieProvider.countries?.resultList ?? [])
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
                                          selectedCountry = movieProvider.countries?.resultList
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
                          Text(
                            "Categories",
                            style: TextStyle(fontSize: 16),
                          ),
                          MultiDropdown<String>(
                            items: movieProvider.categories!.resultList
                                .map((category) {
                              return DropdownItem<String>(
                                label: category.categoryName!,
                                value: category.id.toString(),
                              );
                            }).toList(),
                            controller: controller1,
                            enabled: true,
                            searchEnabled: false,
                            chipDecoration: const ChipDecoration(
                              backgroundColor: Colors.red,
                              wrap: true,
                              runSpacing: 2,
                              spacing: 10,
                            ),
                            fieldDecoration: FieldDecoration(
                              hintText: 'Select Categories',
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(Icons.category,
                                  color: Colors.white),
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
                                  'Select categories from the list',
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
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Actors",
                            style: TextStyle(fontSize: 16),
                          ),
                          MultiDropdown<String>(
                            items:
                            movieProvider.actors!.resultList.map((actor) {
                              return DropdownItem<String>(
                                label: actor.formattedActorRealName!,
                                value: actor.id.toString(),
                              );
                            }).toList(),
                            controller: controller2,
                            enabled: true,
                            searchEnabled: false,
                            chipDecoration: const ChipDecoration(
                              backgroundColor: Colors.red,
                              wrap: true,
                              runSpacing: 2,
                              spacing: 10,
                            ),
                            fieldDecoration: FieldDecoration(
                              hintText: 'Select Actors',
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
                                  'Select actors from the list',
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
                                return 'Please select a actor';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Price",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: priceController,
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: "Enter Price",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(fontSize: 25),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Price mustn't be empty";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                double priceValue = double.tryParse(value) ?? 0;
                                if (priceValue < 0) {
                                  priceController.text = '0';
                                } else {
                                  priceController.text =
                                      priceValue.toStringAsFixed(2);
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Discount (%)",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Enter Discount",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(fontSize: 25),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Discount mustn't be empty";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                int discountValue = int.tryParse(value) ?? 0;
                                if (discountValue < 0) {
                                  discountController.text = '0';
                                } else if (discountValue > 100) {
                                  discountController.text = '100';
                                } else {
                                  discountController.text =
                                      discountValue.toString();
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: trailerLinkController,
                            decoration: InputDecoration(
                              labelText: "YouTube Video Link Identifier",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "YouTube video link mustn't be empty";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: storyLineController,
                            decoration: InputDecoration(
                              labelText: "Story Line",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(fontSize: 25),
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Story line mustn't be empty";
                              }
                              return null;
                            },
                            maxLines: 6,
                          ),
                          SizedBox(height: 20),
                          FormField<dynamic>(
                            validator: (value) {
                              if (value == null) {
                                return "Please select the movie state";
                              }
                              return null;
                            },
                            builder: (FormFieldState<dynamic> state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Movie State",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2<dynamic>(
                                      isExpanded: true,
                                      value: selectedMovieState,
                                      hint: Text(
                                        "Select the movie state",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      items: movieStates.map<DropdownMenuItem<dynamic>>(
                                            (movieState) {
                                          return DropdownMenuItem<dynamic>(
                                            value: movieState["name"],
                                            child: Text(
                                              movieState["name"],
                                              style: const TextStyle(fontSize: 14, color: Colors.white),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (dynamic newValue) {
                                        state.didChange(newValue);
                                        setState(() {
                                          selectedMovieState = newValue;
                                          selectedMovieStateValue = movieStates.firstWhere(
                                                  (state) => state["name"] == newValue)["value"];
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
                  List<int> selectedCategoryIds = controller1.selectedItems
                      .map((item) =>
                      int.parse((item as DropdownItem<String>).value))
                      .toList();

                  List<int> selectedActorsIds = controller2.selectedItems
                      .map((item) =>
                      int.parse((item as DropdownItem<String>).value))
                      .toList();

                  var request = MovieInsertRequest(
                      title: titleController.text,
                      releaseDate:
                      DateTime.tryParse(releaseDateController.text),
                      duration: durationController.text,
                      directorId: selectedDirectorId,
                      categories: selectedCategoryIds,
                      actors: selectedActorsIds,
                      countryId: selectedCountryId,
                      trailerLink: trailerLinkController.text,
                      imagePlainText: currentImage,
                      storyLine: storyLineController.text,
                      price: priceController.text,
                      movieState: selectedMovieStateValue,
                      discount: discountController.text);

                  await movieProvider.insertMovie(request);

                  titleController.clear();
                  releaseDateController.clear();
                  durationController.clear();
                  trailerLinkController.clear();
                  storyLineController.clear();
                  priceController.clear();
                  discountController.clear();
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

  void showEditMovieDialog(BuildContext context, Movie movie) {
    dynamic currentImage = movie.image ?? "";

    TextEditingController titleController = TextEditingController(text: movie.title);

    String formattedDate = movie.formattedReleaseDate ?? 'Jan 1, 1900';

    DateTime parsedDate = DateFormat('MMM dd, yyyy').parse(formattedDate);

    String formattedDateForController = DateFormat('yyyy-MM-dd').format(parsedDate);

    TextEditingController releaseDateController = TextEditingController(text: formattedDateForController);

    TextEditingController durationController = TextEditingController(text: movie.duration.toString());
    TextEditingController trailerLinkController = TextEditingController(text: movie.trailerLink);
    TextEditingController storyLineController = TextEditingController(text: movie.storyLine);
    TextEditingController priceController = TextEditingController(text: movie.price! % 1 == 0 ? movie.price!.toInt().toString() : movie.price.toString());
    TextEditingController discountController = TextEditingController(
      text: (movie.discount == null)
          ? '0'
          : (movie.discount % 1 == 0
          ? movie.discount.toInt().toString()
          : movie.discount.toString()),
    );
    TextEditingController imageController = TextEditingController(text: currentImage);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    dynamic selectedDirectorId = movie.directorId;
    dynamic selectedCountryId = movie.countryId;
    String? selectedDirector;
    String? selectedCountry;
    dynamic selectedMovieStateValue;

    final controller1 = MultiSelectController<String>();
    final controller2 = MultiSelectController<String>();

    List<Map<String, dynamic>> movieStates = [
      {"name": "Draft", "value": 0},
      {"name": "Published", "value": 1},
      {"name": "Discounted", "value": 2},
    ];

    dynamic selectedMovieState = movieStates.firstWhere(
            (state) => state['value'] == movie.movieState,
        orElse: () => {"value": movie.movieState}
    )['name'];

    final List<String> selectedCategoryIds = movie.movieCategories!
        .map((category) => category.categoryId.toString())
        .toSet()
        .toList();

    final List<String> selectedActorsIds = movie.movieActors!
        .map((actor) => actor.actorId.toString())
        .toSet()
        .toList();

    final dropdownItems = movieProvider.categories!.resultList.map((category) {
      bool isSelected = selectedCategoryIds.contains(category.id.toString());

      return DropdownItem<String>(
        label: category.categoryName!,
        value: category.id.toString(),
        selected: isSelected,
      );
    }).toList();

    final dropdownItems1 = movieProvider.actors!.resultList.map((actor) {
      bool isSelected = selectedActorsIds.contains(actor.id.toString());

      return DropdownItem<String>(
        label: actor.formattedActorRealName!,
        value: actor.id.toString(),
        selected: isSelected,
      );
    }).toList();

    controller1.setItems(dropdownItems);
    controller2.setItems(dropdownItems1);

    controller1.selectWhere((item) {
      bool isSelected = selectedCategoryIds.contains(item.value);
      return isSelected;
    });

    controller2.selectWhere((item) {
      bool isSelected = selectedActorsIds.contains(item.value);
      return isSelected;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Update Movie",
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
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(thickness: 1, color: Colors.grey),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: "Movie Title",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure movie title is not empty field";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: releaseDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Release Date",
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
                                    formattedDateForController),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                releaseDateController.text =
                                pickedDate.toIso8601String().split('T')[0];
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              int? pickedDuration = await showDurationPicker(
                                context,
                                currentDuration:
                                int.tryParse(durationController.text) ?? 0,
                              );
                              if (pickedDuration != null) {
                                setState(() {
                                  durationController.text =
                                      pickedDuration.toString();
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                controller: durationController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Duration",
                                  labelStyle: TextStyle(fontSize: 20),
                                  floatingLabelStyle: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Director",
                            style: TextStyle(fontSize: 16),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<dynamic>(
                              isExpanded: true,
                              value: selectedDirectorId,
                              hint: Text("Select Director"),
                              items: (movieProvider.directors?.resultList ?? [])
                                  .map((director) => DropdownMenuItem<dynamic>(
                                value:
                                director.id,
                                child: Text(
                                  director.formattedDirectorRealName!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                                  .toList(),
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  selectedDirectorId = newValue;
                                  selectedDirector = movieProvider.directors?.resultList
                                      .firstWhere((director) => director.id == selectedDirectorId)
                                      .formattedDirectorRealName;
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
                          SizedBox(height: 20),
                          Text(
                            "Country",
                            style: TextStyle(fontSize: 16),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<dynamic>(
                              isExpanded: true,
                              value: selectedCountryId,
                              hint: Text("Select Country"),
                              items: (movieProvider.countries?.resultList ?? [])
                                  .map((country) => DropdownMenuItem<dynamic>(
                                value: country.id,
                                child: Text(
                                  country.countryName!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                                  .toList(),
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  selectedCountryId = newValue;
                                  selectedCountry = movieProvider.countries?.resultList
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
                          SizedBox(height: 20),
                          Text(
                            "Categories",
                            style: TextStyle(fontSize: 16),
                          ),
                          MultiDropdown<String>(
                            items: dropdownItems,
                            controller: controller1,
                            enabled: true,
                            searchEnabled: false,
                            chipDecoration: const ChipDecoration(
                              backgroundColor: Colors.red,
                              wrap: true,
                              runSpacing: 2,
                              spacing: 10,
                            ),
                            fieldDecoration: FieldDecoration(
                              hintText: 'Select Categories',
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(Icons.category,
                                  color: Colors.white),
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
                                  'Select categories from the list',
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
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Actors",
                            style: TextStyle(fontSize: 16),
                          ),
                          MultiDropdown<String>(
                            items: dropdownItems1,
                            controller: controller2,
                            enabled: true,
                            searchEnabled: false,
                            chipDecoration: const ChipDecoration(
                              backgroundColor: Colors.red,
                              wrap: true,
                              runSpacing: 2,
                              spacing: 10,
                            ),
                            fieldDecoration: FieldDecoration(
                              hintText: 'Select Actors',
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
                                  'Select actors from the list',
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
                                return 'Please select a actor';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Price",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: priceController,
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: "Enter Price",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(fontSize: 25),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure price is not empty field";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                double priceValue = double.tryParse(value) ?? 0;
                                if (priceValue < 0) {
                                  priceController.text = '0';
                                } else {
                                  priceController.text =
                                      priceValue.toStringAsFixed(2);
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Discount (%)",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Enter Discount",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(fontSize: 25),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure discount is not empty field";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                int discountValue = int.tryParse(value) ?? 0;
                                if (discountValue < 0) {
                                  discountController.text = '0';
                                } else if (discountValue > 100) {
                                  discountController.text = '100';
                                } else {
                                  discountController.text =
                                      discountValue.toString();
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: trailerLinkController,
                            decoration: InputDecoration(
                              labelText: "YouTube Video Link Identifier",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure youtube video link is not empty field";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: storyLineController,
                            decoration: InputDecoration(
                              labelText: "Story Line",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(fontSize: 25),
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure story line is not empty field";
                              }
                              return null;
                            },
                            maxLines: 6,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Movie State",
                            style: TextStyle(fontSize: 16),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<dynamic>(
                              isExpanded: true,
                              value: selectedMovieState,
                              hint: Text("Select the movie state",
                                  style: TextStyle(color: Colors.white)),
                              items: movieStates.map<DropdownMenuItem<dynamic>>(
                                      (movieStates) {
                                    return DropdownMenuItem<dynamic>(
                                      value: movieStates["name"],
                                      child: Text(
                                        movieStates["name"],
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  selectedMovieState = newValue;
                                  selectedMovieStateValue = movieStates.firstWhere(
                                          (state) => state["name"] == newValue
                                  )["value"];
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
                List<int> selectedCategoryIds = controller1.selectedItems
                    .map((item) =>
                    int.parse((item as DropdownItem<String>).value))
                    .toList();

                List<int> selectedActorsIds = controller2.selectedItems
                    .map((item) =>
                    int.parse((item as DropdownItem<String>).value))
                    .toList();

                if(_formKey.currentState!.validate()) {
                  var request = MovieUpdateRequest(
                      title: titleController.text.isNotEmpty
                          ? titleController.text
                          : "",
                      releaseDate: releaseDateController.text.isNotEmpty
                          ? DateTime.tryParse(releaseDateController.text)
                          : null,
                      duration: durationController.text.isNotEmpty
                          ? durationController.text
                          : null,
                      directorId: selectedDirectorId != null
                          ? selectedDirectorId
                          : null,
                      categories: selectedCategoryIds.isNotEmpty
                          ? selectedCategoryIds
                          : [],
                      actors:
                      selectedActorsIds.isNotEmpty ? selectedActorsIds : [],
                      countryId:
                      selectedCountryId != null ? selectedCountryId : null,
                      trailerLink: trailerLinkController.text.isNotEmpty
                          ? trailerLinkController.text
                          : "",
                      imagePlainText:
                      currentImage.isNotEmpty ? currentImage : "",
                      storyLine: storyLineController.text.isNotEmpty
                          ? storyLineController.text
                          : "",
                      price: priceController.text.isNotEmpty
                          ? priceController.text
                          : null,
                      movieState: selectedMovieStateValue ??
                          movie.movieState,
                      discount: discountController.text.isNotEmpty
                          ? discountController.text
                          : null,
                      averageRating: null);

                  await movieProvider.updateMovie(movie.id!, request);

                  titleController.clear();
                  releaseDateController.clear();
                  durationController.clear();
                  trailerLinkController.clear();
                  storyLineController.clear();
                  priceController.clear();
                  discountController.clear();
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

  Future<int?> showDurationPicker(BuildContext context,
      {required int currentDuration}) async {
    int selectedMinutes = currentDuration;
    return showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: secondaryColor,
              title: Text("Select Duration"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Duration in minutes: $selectedMinutes"),
                  Slider(
                    value: selectedMinutes.toDouble(),
                    min: 0,
                    max: 500,
                    divisions: 500,
                    label: "$selectedMinutes min",
                    onChanged: (value) {
                      setState(() {
                        selectedMinutes = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedMinutes);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
