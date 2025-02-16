import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/profiletabscreen/profile_tab_screen_view_model.dart';
import '../../../../../style/theme/theme.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/dialog.dart';
import '../../../../basewidgets/movieposter.dart';
import '../../../welcomescreen/welcome_screen.dart';
import '../../navigation_screen_view_model.dart';
import '../editprofiletabscreen/edit_profile_tab_screen.dart';
import '../moviedetailtabscreen/movie_detail_tab_screen.dart';
import '../orderhistorytabscreen/order_history_tab_screen.dart';

class ProfileTabScreen extends StatefulWidget {
  static const String routeName = 'profiletabscreen';
  static const String path = '/profiletabscreen';

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late ProfileTabScreenViewModel viewModel;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    viewModel = ProfileTabScreenViewModel();
    viewModel.homeScreenViewModel =
        Provider.of<NavigationScreenViewModel>(context, listen: false);
    viewModel.getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.homeScreenViewModel = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileTabScreenViewModel>(
      create: (context) => viewModel,
      child: BlocConsumer<ProfileTabScreenViewModel, BaseState>(
        listener: (context, state) {
          if (state is MovieDetailsAction) {
            viewModel.homeScreenViewModel!.setSelectedIndex(9);
            context.pushNamed(MovieDetailTabScreen.routeName,
                extra: state.movie);
          } else if (state is ShowQuestionMessageState) {
            MyDialogUtils.showQuestionMessage(
                context: context,
                message: state.message,
                posActionTitle: "Yes",
                posAction: viewModel.signOut,
                negativeActionTitle: "No");
          } else if (state is SignOutAction) {
            context.goNamed(WelcomeScreen.routeName);
          } else if (state is EditProfileAction) {
            GoRouter.of(context)
                .pushNamed(EditProfileTabScreen.routeName, extra: state.user);
            viewModel.homeScreenViewModel!.setSelectedIndex(9);
          } else if (state is OrdersHistoryAction) {
            GoRouter.of(context).pushNamed(OrderHistoryTabScreen.routeName);
            viewModel.homeScreenViewModel!.setSelectedIndex(9);
          } else if (state is BackAction) {
            context.pop(context);
          }
        },
        buildWhen: (previous, current) {
          if (previous is LoadingState && current is DataLoadedState) {
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
                      viewModel.getUserData();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(MyTheme.gold),
                    ),
                    child: const Text("Try Again"))
              ],
            );
          } else if (state is DataLoadedState) {
            return DefaultTabController(
              length: 1,
              initialIndex: 0,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                      toolbarHeight: 250,
                      backgroundColor: MyTheme.blackThree,
                      title: Container(
                        height: 250,
                        child: Column(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    viewModel.onPressBackAction();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 116,
                                        height: 113,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: viewModel.userImage != null
                                              ? Image.memory(
                                                  base64Decode(
                                                      viewModel.userImage),
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  "assets/images/avatar.png",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      Text(
                                        viewModel.userName!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              state.favouriteMovies!.length
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                            ),
                                            Text(
                                              "Favourites",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "0",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                            ),
                                            Text(
                                              "Cart",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            )
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      viewModel
                                          .goToEditProfileScreen(state.user);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              MyTheme.gold),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Edit",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      viewModel.goToOrdersHistoryScreen();
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Orders",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      viewModel.onSignOutPress(
                                          "Are You Sure You Want To Sign Out");
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Exit",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pinned: true,
                      floating: true,
                      leading: Container(),
                      leadingWidth: 0,
                      forceElevated: innerBoxIsScrolled,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(90),
                        child: TabBar(
                          indicatorColor: MyTheme.gold,
                          tabs: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    EvaIcons.list,
                                    color: MyTheme.gold,
                                  ),
                                  Text(
                                    "Favourites List",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
                body: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: TabBarView(
                      children: [
                        state.favouriteMovies!.isEmpty
                            ? Center(
                                child: Image.asset(
                                  "assets/images/empty.png",
                                  width: 100,
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                // physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.65),
                                itemBuilder: (context, index) => MoviePoster(
                                  movie: state.favouriteMovies![index],
                                  goToDetailsScreen:
                                      viewModel.goToDetailsScreen,
                                ),
                                itemCount: state.favouriteMovies?.length,
                              ),
                      ],
                    ))
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
