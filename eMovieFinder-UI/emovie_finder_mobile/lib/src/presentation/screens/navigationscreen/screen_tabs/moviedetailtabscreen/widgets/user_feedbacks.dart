import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../../../models/entities/moviereview.dart';
import '../../../../../../style/theme/theme.dart';
import '../../../../../../utils/helpers/basestate.dart';
import '../../moviedetailtabscreen/movie_detail_tab_screen_view_model.dart';
import 'package:emovie_finder_mobile/src/utils/providers/app_config_provider.dart';

class UserFeedBacksWidget extends StatefulWidget {
  List<MovieReview>? feedbacks;

  UserFeedBacksWidget(this.feedbacks);

  @override
  _UserFeedBacksWidgetState createState() => _UserFeedBacksWidgetState();
}

class _UserFeedBacksWidgetState extends State<UserFeedBacksWidget> {
  String? currentIdentityUserId;

  @override
  void initState() {
    super.initState();
    _fetchIdentityUserId();
  }

  Future<void> _fetchIdentityUserId() async {
    var token = await AppConfigProvider().getValueFromStorage("token");
    final identityUserId = AppConfigProvider().getIdentityUserIdFromToken(token);
    setState(() {
      currentIdentityUserId = identityUserId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = BlocProvider.of<MovieDetailTabScreenViewModel>(context);

    return BlocListener<MovieDetailTabScreenViewModel, BaseState>(
      listener: (context, state) {
        if (state is DataLoadedState) {
          setState(() {
            widget.feedbacks = state.movieReviews;
          });
        }
      },
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "FeedBacks & Reviews",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          widget.feedbacks!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text(
                        "The movie has no reviews",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              : CarouselSlider(
                  items: widget.feedbacks!.map((e) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: MyTheme.blackFour,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: e.user?.image != null
                                    ? MemoryImage(base64Decode(e.user!.image))
                                    : const AssetImage(
                                            'assets/images/avatar.png')
                                        as ImageProvider,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  e.user!.username!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: MyTheme.gray,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Text(
                                  e.formattedCreationDate ?? "No date",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              e.comment!,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RatingBar.builder(
                                initialRating:
                                    double.parse(e.rating!.toString()),
                                minRating: 1,
                                ignoreGestures: true,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 15,
                                onRatingUpdate: (rate) {},
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          if (currentIdentityUserId ==
                              e.user?.identityUserId.toString())
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  viewModel.onDeleteReviewPress(
                                      "Are You Sure You Want To Delete This Review?",
                                      e.id!);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  minimumSize: const Size(80, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                label: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 220,
                    viewportFraction: 0.85,
                    disableCenter: true,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    enlargeFactor: 0.32,
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    animateToClosest: true,
                  ),
                ),
        ],
      ),
    );
  }
}
