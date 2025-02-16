import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../../../style/theme/theme.dart';
import '../../../../../basewidgets/movieposter.dart';

class SimilarMovies extends StatefulWidget {
  List<dynamic>? movies;
  Function goToDetailsScreen ;
  SimilarMovies({required this.movies , required this.goToDetailsScreen});
  @override
  State<SimilarMovies> createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  int currentMovieIndex = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    dynamic imageBytes = base64Decode(widget.movies![currentMovieIndex].image);
    return Stack(
        children: [
          Image.asset('assets/images/loading.jpg',),
          // image to show in the background it the same image of the poster
          if (widget.movies?.isNotEmpty ?? false)
            Image.memory(
              imageBytes,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/error.png'),
              ),
            ),
          // gradient layer above the image
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: double.infinity,//MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        MyTheme.backGroundColor.withOpacity(1),
                        MyTheme.backGroundColor.withOpacity(0.5),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                  )
              ),
            ),
          ),
          // the poster list (the slider)
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/availablenow.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                CarouselSlider(
                  items: widget.movies?.map((movie) => MoviePoster(movie: movie , goToDetailsScreen: widget.goToDetailsScreen,)).toList(),
                  options: CarouselOptions(
                    height:300,
                    viewportFraction: 0.5,
                    initialPage: 0,
                    autoPlayInterval: const Duration(seconds: 1),
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    enlargeFactor: 0.32,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentMovieIndex = index;
                      });
                    },
                  ),
                ),
                Image.asset(
                  'assets/images/watchnow.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ],
            ),
          )
        ]
    );
  }
}