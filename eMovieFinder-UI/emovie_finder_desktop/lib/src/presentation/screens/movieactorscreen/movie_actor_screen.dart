import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/movie/movie_actor_update_request.dart';
import '../../../models/entities/movieactor.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/providers/constant_colors.dart';
import 'movie_actor_screen_view_model.dart';

class MovieActorScreen extends StatefulWidget {
  const MovieActorScreen({Key? key}) : super(key: key);

  @override
  State<MovieActorScreen> createState() => _MovieActorScreenState();
}

class _MovieActorScreenState extends State<MovieActorScreen> {
  late MovieActorController movieActorProvider;

  @override
  void initState() {
    super.initState();
    movieActorProvider = MovieActorController();
    movieActorProvider.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieActorController>(
      create: (context) => movieActorProvider,
      child: BlocConsumer<MovieActorController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            if (state.message == "Movie actor has been updated successfully") {
              MyDialogUtils.showSuccessDialog(
                  context: context,
                  message: state.message,
                  posActionTitle: "Ok",
                  posAction: () {
                    Navigator.of(context).pop();
                    movieActorProvider.fetchData();
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
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is MovieActorLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is MovieActorLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is MovieActorLoadedState) ||
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
                    const Center(
                      child: Text(
                        'No movie actors available',
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
          } else if (state is MovieActorLoadedState) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        child: DataTable(
                          columnSpacing: 16,
                          columns: [
                            DataColumn(label: Text("Movie")),
                            DataColumn(label: Text("Actor")),
                            DataColumn(label: Text("Character Name")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: List.generate(
                            state.movieActors?.length ?? 0,
                            (index) => movieActorDataRow(
                              state.movieActors![index],
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
                'Could Not Load The Movie Actors Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  DataRow movieActorDataRow(MovieActor movieActor, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(movieActor.movieTitle ?? "No Movie Title")),
        DataCell(Text(movieActor.actor!.formattedActorRealName ?? "No Actor Name")),
        DataCell(Text(movieActor.characterName ?? "No Character Name")),
        DataCell(
          DropdownButton<String>(
            hint: const Text(
              "Actions",
              style: TextStyle(fontSize: 14),
            ),
            items: [
              DropdownMenuItem(
                value: "Update Character Name",
                child: Container(
                  color: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text("Update Character Name",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == "Update Character Name") {
                showEditMovieActorDialog(context, movieActor);
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

  void showEditMovieActorDialog(BuildContext context, MovieActor movieActor) {
    TextEditingController characterNameControllerUpdate =
        TextEditingController(text: movieActor.characterName);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            "Edit Movie Actor",
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
                            controller: characterNameControllerUpdate,
                            decoration: InputDecoration(
                              labelText: "Character Name",
                              labelStyle: TextStyle(fontSize: 20),
                              floatingLabelStyle: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Make sure character name is not empty field";
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
                if(movieActor.characterName != characterNameControllerUpdate.text) {
                  if (_formKey.currentState!.validate()) {
                    var request = MovieActorUpdateRequest(
                        movieId: movieActor.movieId,
                        actorId: movieActor.actorId,
                        characterName: characterNameControllerUpdate.text);

                    await movieActorProvider.updateMovieActor(
                        movieActor.id!, request);

                    characterNameControllerUpdate.clear();
                  }
                } else {
                  movieActorProvider.movieActorUpdatedScreenError("You must change at least one input field to update the movie actor");
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
