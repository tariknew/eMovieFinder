import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/movie/movie_favourite_insert_request.dart';
import '../../../models/entities/moviefavourite.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/providers/constant_colors.dart';
import '../moviescreen/movie_screen_view_model.dart';
import '../userscreen/user_screen_view_model.dart';
import 'movie_favourite_screen_view_model.dart';

class MovieFavouriteScreen extends StatefulWidget {
  const MovieFavouriteScreen({Key? key}) : super(key: key);

  @override
  State<MovieFavouriteScreen> createState() => _MovieFavouriteScreenState();
}

class _MovieFavouriteScreenState extends State<MovieFavouriteScreen> {
  late MovieFavouriteController movieFavouriteProvider;

  @override
  void initState() {
    super.initState();
    movieFavouriteProvider = MovieFavouriteController();
    movieFavouriteProvider.fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchMovies();
      await fetchUsers();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchMovies() async {
    final response = await MovieController().fetchMovies();

    if (response != null) {
      movieFavouriteProvider.movies = response;
      setState(() {});
    }
  }

  Future<void> fetchUsers() async {
    final response = await UserController().fetchUsers();

    if (response != null) {
      movieFavouriteProvider.users = response;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieFavouriteController>(
      create: (context) => movieFavouriteProvider,
      child: BlocConsumer<MovieFavouriteController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            MyDialogUtils.showSuccessDialog(
              context: context,
              message: state.message,
              posActionTitle: "Ok",
            );
          } else if (state is ShowErrorMessageState) {
            MyDialogUtils.showErrorDialog(
              context: context,
              message: state.message,
              posActionTitle: "Try Again",
            );
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState &&
                  current is MovieFavouriteLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is MovieFavouriteLoadedState &&
                  current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is MovieFavouriteLoadedState) ||
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
                              showAddMovieFavouriteDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Favourite Movie",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'No movie favourites available',
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
          } else if (state is MovieFavouriteLoadedState) {
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
                              showAddMovieFavouriteDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Favourite Movie",
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
                            DataColumn(label: Text("Movie")),
                            DataColumn(label: Text("User")),
                          ],
                          rows: List.generate(
                            state.movieFavourites?.length ?? 0,
                                (index) => favouriteDataRow(
                              state.movieFavourites![index],
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
                'Could Not Load The Movie Favourites Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  DataRow favouriteDataRow(
      MovieFavourite movieFavourite, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(movieFavourite.movie!.title ?? "No Movie Title")),
        DataCell(
            Text(movieFavourite.user!.identityUser?.userName ?? "No UserName"))
      ],
    );
  }

  void showAddMovieFavouriteDialog(BuildContext context) {
    String? selectedMovie;
    String? selectedUser;

    dynamic selectedMovieId;
    dynamic selectedUserId;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Add Favourite Movie",
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
                        FormField<dynamic>(
                          validator: (value) {
                            if (value == null) {
                              return "Please select a movie";
                            }
                            return null;
                          },
                          builder: (FormFieldState<dynamic> state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Movie",
                                  style: TextStyle(fontSize: 16),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<dynamic>(
                                    isExpanded: true,
                                    value: selectedMovieId,
                                    hint: Text("Select Movie"),
                                    items: (movieFavouriteProvider.movies?.resultList ?? [])
                                        .map((movie) => DropdownMenuItem<dynamic>(
                                      value: movie.id,
                                      child: Text(
                                        movie.title!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (dynamic newValue) {
                                      state.didChange(newValue);
                                      setState(() {
                                        selectedMovieId = newValue;
                                        selectedMovie = movieFavouriteProvider.movies?.resultList
                                            .firstWhere((movie) => movie.id == selectedMovieId)
                                            .title;
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
                              return "Please select a user";
                            }
                            return null;
                          },
                          builder: (FormFieldState<dynamic> state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User",
                                  style: TextStyle(fontSize: 16),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<dynamic>(
                                    isExpanded: true,
                                    value: selectedUserId,
                                    hint: Text("Select User"),
                                    items: (movieFavouriteProvider.users?.resultList ?? [])
                                        .map((user) => DropdownMenuItem<dynamic>(
                                      value: user.id,
                                      child: Text(
                                        user.identityUser!.userName!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (dynamic newValue) {
                                      state.didChange(newValue);
                                      setState(() {
                                        selectedUserId = newValue;
                                        selectedUser = movieFavouriteProvider.users?.resultList
                                            .firstWhere((user) => user.id == selectedUserId)
                                            .identityUser!.userName;
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
                        )
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
                  var request = MovieFavouriteInsertRequest(
                      userId: selectedUserId, movieId: selectedMovieId);

                  await movieFavouriteProvider.insertMovieFavourite(request);

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
