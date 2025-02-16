import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../models/dtos/requests/moviereview/movie_review_insert_request.dart';
import '../../../../../models/entities/movieactor.dart';
import '../../../../../style/theme/theme.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/dialog.dart';
import '../../../../../utils/providers/app_config_provider.dart';
import '../../navigation_screen_view_model.dart';
import '../moviedetailtabscreen/widgets/user_feedbacks.dart';
import 'movie_detail_tab_screen_view_model.dart';

class MovieDetailTabScreen extends StatefulWidget {
  num? movieId;

  MovieDetailTabScreen({required this.movieId, Key? key}) : super(key: key);
  static const String routeName = 'moviedetailtabscreen';
  static const String path = '/moviedetailtabscreen';

  @override
  State<MovieDetailTabScreen> createState() => _MovieDetailTabScreenState();
}

class _MovieDetailTabScreenState extends State<MovieDetailTabScreen> {
  dynamic userRole;
  String? token;

  late MovieDetailTabScreenViewModel viewModel;

  @override
  void initState() {
    viewModel = MovieDetailTabScreenViewModel();
    viewModel.homeScreenViewModel =
        Provider.of<NavigationScreenViewModel>(context, listen: false);
    viewModel.loadMovieData(widget.movieId!);
    viewModel.isMovieInFavourites(widget.movieId as int);
    viewModel.isMovieAddedToCart(widget.movieId as int);
    _loadUserRole();
    super.initState();
  }

  Future<void> _loadUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final rolesString = prefs.getString("roles");

    if (rolesString != null && rolesString.isNotEmpty) {
      userRole = rolesString
          .substring(1, rolesString.length - 1)
          .split(',')
          .map((role) => role.trim())
          .toList();

      setState(() {});
    }
  }

  bool isRole() {
    if (userRole is List<String>) {
      return userRole.any((role) => role == "Customer" || role == "Administrator");
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.commentController.dispose();
    viewModel.provider = null;
    viewModel.homeScreenViewModel = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieDetailTabScreenViewModel>(
      create: (context) => viewModel,
      child: BlocConsumer<MovieDetailTabScreenViewModel, BaseState>(
        listener: (context, state) {
          if (state is BackAction) {
            context.pop(context);
          } else if (state is MovieDetailsAction) {
            viewModel.homeScreenViewModel!.setSelectedIndex(9);
            context.pushNamed(MovieDetailTabScreen.routeName,
                extra: state.movie);
          } else if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowLoadingState) {
            MyDialogUtils.showLoadingDialog(context, state.message);
          } else if (state is ShowSuccessMessageState) {
            if (state.message == "Review has been created successfully") {
              MyDialogUtils.showSuccessMessage(
                context: context,
                message: state.message,
                posActionTitle: "Ok",
                posAction: () {
                  viewModel.clearFields();
                },
              );
            } else if (state.message ==
                "Review has been deleted successfully") {
              MyDialogUtils.showSuccessMessage(
                context: context,
                message: state.message,
                posActionTitle: "Ok",
              );
            } else {
              MyDialogUtils.showSuccessMessage(
                context: context,
                message: state.message,
                posActionTitle: "Ok",
              );
            }
          } else if (state is ShowErrorMessageState) {
            MyDialogUtils.showFailMessage(
                context: context,
                message: state.message,
                posActionTitle: "Try Again");
          } else if (state is ShowQuestionMessageState) {
            if (state.message ==
                "Are You Sure You Want To Perform This Action?") {
              MyDialogUtils.showQuestionMessage(
                  context: context,
                  message: state.message,
                  posActionTitle: "Yes",
                  posAction: () async {
                    if (viewModel.isMovieInCart) {
                      viewModel.removeMovieFromCart(widget.movieId as int);
                    } else {
                      viewModel.addMovieToCart(widget.movieId as int);
                    }
                  },
                  negativeActionTitle: "No");
            } else if (state.message ==
                "Are You Sure You Want To Add Or Remove This Movie From Favourites?") {
              MyDialogUtils.showQuestionMessage(
                  context: context,
                  message: state.message,
                  posActionTitle: "Yes",
                  posAction: () async {
                    viewModel.addOrRemoveFavouriteMovie(widget.movieId as int);
                  },
                  negativeActionTitle: "No");
            } else {
              MyDialogUtils.showQuestionMessage(
                  context: context,
                  message: state.message,
                  posActionTitle: "Yes",
                  posAction: () async {
                    await viewModel.deleteReview(state.id as int);
                  },
                  negativeActionTitle: "No");
            }
          } else if (state is RatingUpdatedState) {
            viewModel.userRating = state.userRating;
          }
        },
        buildWhen: (previous, current) {
          if (current is DataLoadedState && previous is LoadingState) {
            return true;
          } else if (current is DataLoadedState &&
              previous is ShowSuccessMessageState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: MyTheme.gold,
              ),
            );
          } else if (state is DataLoadedState) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.memory(
                            base64Decode(state.movie.image),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/images/error.png'),
                          ),
                          Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          MyTheme.backGroundColor.withOpacity(
                                              0.3),
                                          MyTheme.backGroundColor.withOpacity(
                                              0.1),
                                          MyTheme.backGroundColor.withOpacity(
                                              0.7),
                                          MyTheme.backGroundColor.withOpacity(
                                              1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter)),
                              )),
                          SizedBox(
                            height: 132,
                            child: InkWell(
                              onTap: () async {
                                final trailerUrl =
                                    'https://www.youtube.com/watch?v=${state
                                    .movie.trailerLink}';
                                var url = Uri.parse(trailerUrl);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                }
                              },
                              child: Center(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: MyTheme.gold,
                                  ),
                                  child: const Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.movie.title!,
                                          textAlign: TextAlign.center,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .displayLarge!
                                              .copyWith(fontSize: 30),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                        state.movie.formattedReleaseDate!,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headlineSmall),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.onAddOrRemoveMovieFromCartPress(
                                "Are You Sure You Want To Perform This Action?");
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  viewModel.isMovieInCart
                                      ? "Remove from Cart"
                                      : "Add to Cart",
                                  style:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .displayMedium,
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  viewModel.isMovieInCart
                                      ? Icons.remove_shopping_cart
                                      : Icons.add_shopping_cart,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            info(state.movie.formattedFinalMoviePrice!,
                                EvaIcons.pricetags),
                            const SizedBox(
                              width: 10,
                            ),
                            info("${state.movie.formattedDuration}",
                                LineIcons.hourglassHalf),
                            const SizedBox(
                              width: 10,
                            ),
                            info(viewModel.averageRating.toString(),
                                EvaIcons.star),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      title("Discount"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MyTheme.blackFour,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              state.movie.formattedDiscount!,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                fontSize: 16,
                                color: state.movie.formattedDiscount ==
                                    "No Discount"
                                    ? Colors.red
                                    : Colors.yellow,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      title("Director"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MyTheme.blackFour,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              state.movie.directorName ?? "No director",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      title("Categories"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: state.movie.categoriesNames == null ||
                            state.movie.categoriesNames!.isEmpty
                            ? Center(
                          child: Text(
                            'No categories available',
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,),
                          ),
                        ) :
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                          itemBuilder: (context, index) =>
                              Container(
                                decoration: BoxDecoration(
                                  color: MyTheme.blackFour,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    state.movie.categoriesNames!
                                        .split(', ')[index]
                                        .trim(),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontSize: 16),
                                  ),
                                ),
                              ),
                          itemCount:
                          state.movie.categoriesNames!.split(', ').length,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      title("Main actors"),
                      state.movie.movieActors == null ||
                          state.movie.movieActors!.isEmpty
                          ? Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Text(
                              "The movie has no actors",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            Container(
                              decoration: BoxDecoration(
                                color: MyTheme.blackOne,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                children: [
                                  state.movie.movieActors![index].actor
                                      ?.image ==
                                      null
                                      ? ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/images/user.png',
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      child: Image.memory(
                                        base64Decode(state
                                            .movie
                                            .movieActors![index]
                                            .actor
                                            ?.image),
                                        width: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                            stackTrace) =>
                                            Image.asset(
                                                'assets/images/user.png'),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Full name: ${state.movie
                                                .movieActors![index].actor
                                                ?.firstName ?? 'Unknown'} ${state.movie
                                                .movieActors![index].actor
                                                ?.lastName ?? 'Unknown'}",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .displaySmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "Character name: ${state.movie
                                                .movieActors![index]
                                                .characterName ?? 'Unknown'}",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .displaySmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyTheme.gold,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                _showActorBiographyDialog(
                                                    context,
                                                    state.movie
                                                        .movieActors![index]),
                                            child: Text("See More Info",
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                        itemCount: state.movie.movieActors!.length,
                      ),
                      title("Movie summary"),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          state.movie.storyLine!,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                              fontWeight: FontWeight.w400, wordSpacing: 1),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      UserFeedBacksWidget(state.movieReviews!),
                      const SizedBox(
                        width: 20,
                      ),
                      (viewModel.userHasSubmittedReview == false && isRole())
                          ? Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Your Rating",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBar.builder(
                                  initialRating:
                                  double.parse(viewModel.userRating),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 35,
                                  unratedColor: MyTheme.gray,
                                  onRatingUpdate: (rate) {
                                    viewModel.updateUserRating(rate);
                                  },
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  itemBuilder: (context, _) =>
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller:
                                    viewModel.commentController,
                                    cursorColor: MyTheme.gray,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                      hintText: "Enter Your Opinion",
                                      fillColor: MyTheme.blackFour,
                                      filled: true,
                                      hintStyle: TextStyle(
                                        fontSize: 18,
                                        color:
                                        MyTheme.gray.withOpacity(0.7),
                                      ),
                                      contentPadding:
                                      const EdgeInsets.all(20),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      focusedErrorBorder:
                                      OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      hoverColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            var userId =
                                            await AppConfigProvider()
                                                .getValueFromStorage(
                                                "userId");

                                            final comment = viewModel
                                                .commentController.text;
                                            final rating =
                                                viewModel.userRating;

                                            final request =
                                            MovieReviewInsertRequest(
                                                rating: double.parse(
                                                    rating),
                                                comment: comment,
                                                userId:
                                                int.parse(userId),
                                                movieId: widget
                                                    .movieId as int);

                                            await viewModel
                                                .insertReview(request);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                MyTheme.gold),
                                            shape:
                                            MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                10.0),
                                            child: Text(
                                              "Submit a Review",
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                          : Container(),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                viewModel.onPressBackAction();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 28,
                              )),
                          IconButton(
                              onPressed: () {
                                viewModel.onAddOrRemoveMovieFromFavouritesPress(
                                    "Are You Sure You Want To Add Or Remove This Movie From Favourites?");
                              },
                              icon: Icon(
                                Icons.bookmark_add,
                                color: viewModel.isMovieFavourite
                                    ? MyTheme.gold
                                    : Colors.white,
                                size: 30,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                      viewModel.setStateToLoading();
                      viewModel.loadMovieData(widget.movieId!);
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

  Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        text,
        style: Theme
            .of(context)
            .textTheme
            .displayLarge,
      ),
    );
  }

  Widget info(String title, IconData icon) {
    return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: MyTheme.blackOne),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                icon,
                color: MyTheme.gold,
                size: 30,
              ),
              Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
            ],
          ),
        ));
  }

  void _showActorBiographyDialog(BuildContext context, MovieActor movieActor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.blackOne,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    EvaIcons.calendar,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Birth Date: ${movieActor.actor!.formattedActorBirthDate ?? 'Unknown'}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    EvaIcons.pin,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Birth Place: ${movieActor.actor!
                        .formattedActorBirthPlace ?? "No birthplace"}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey, height: 1, thickness: 1),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(
                    EvaIcons.person,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Short biography",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieActor.actor!.biography ?? 'Unknown',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      final imdbUrl =
                          'https://www.imdb.com/name/${movieActor.actor!
                          .imDbLink!}';
                      launchUrl(Uri.parse(imdbUrl));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          EvaIcons.externalLink,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text("View actor on IMDb"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
