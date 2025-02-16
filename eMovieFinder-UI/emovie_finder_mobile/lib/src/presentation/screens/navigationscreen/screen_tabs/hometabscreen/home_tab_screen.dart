import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/navigation_screen_view_model.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/hometabscreen/home_tab_screen_view_model.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/hometabscreen/widgets/myplaceholder.dart';
import '../../../../../style/theme/theme.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../basewidgets/movielist.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/hometabscreen/widgets/similar_movies.dart';
import '../moviedetailtabscreen/movie_detail_tab_screen.dart';

class HomeTabScreen extends StatefulWidget {
  static const String routeName = 'hometabscreen';
  static const String path = '/hometabscreen';

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late HomeTabScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeTabScreenViewModel();
    viewModel.homeScreenViewModel =
        Provider.of<NavigationScreenViewModel>(context, listen: false);
    viewModel.fetchData(isRefreshing: false);
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.provider = null;
    viewModel.homeScreenViewModel = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeTabScreenViewModel>(
      create: (context) => viewModel,
      child: BlocConsumer<HomeTabScreenViewModel, BaseState>(
        listener: (context, state) {
          if (state is MovieDetailsAction) {
            viewModel.homeScreenViewModel?.setSelectedIndex(9);
            context.pushNamed(MovieDetailTabScreen.routeName,
                extra: state.movie);
          }
        },
        buildWhen: (previous, current) {
          if (previous is LoadingState && current is MoviesLoadedState) {
            return true;
          } else if (previous is LoadingState &&
              current is ShowErrorMessageState) {
            return true;
          } else if (previous is ShowErrorMessageState &&
              current is LoadingState) {
            return true;
          } else if (previous is RefreshState && current is MoviesLoadedState) {
            return true;
          } else if (previous is RefreshState &&
              current is ShowErrorMessageState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return MyPlaceHolder();
          } else if (state is MoviesLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                await viewModel.fetchData(isRefreshing: true);
              },
              color: MyTheme.gold,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  if (state.recommendMovieItems != null &&
                      state.recommendMovieItems!.isNotEmpty)
                    SimilarMovies(
                      movies: state.recommendMovieItems,
                      goToDetailsScreen: viewModel.goToDetailsScreen,
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('No recommended movies',
                          style: Theme.of(context).textTheme.displayMedium),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (state.actionMovies!.isNotEmpty)
                    MovieList(
                      movies: state.actionMovies!,
                      type: "Action Movies",
                      goToDetailsScreen: viewModel.goToDetailsScreen,
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No action movies',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  if (state.crimeMovies!.isNotEmpty)
                    MovieList(
                      movies: state.crimeMovies!,
                      type: "Crime Movies",
                      goToDetailsScreen: viewModel.goToDetailsScreen,
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No crime movies',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  if (state.comedyMovies!.isNotEmpty)
                    MovieList(
                      movies: state.comedyMovies!,
                      type: "Comedy Movies",
                      goToDetailsScreen: viewModel.goToDetailsScreen,
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No comedy movies',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                ],
              )),
            );
          } else if (state is ShowErrorMessageState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                    onPressed: () {
                      viewModel.fetchData(isRefreshing: false);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(MyTheme.gold),
                    ),
                    child: const Text("Try Again"))
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
