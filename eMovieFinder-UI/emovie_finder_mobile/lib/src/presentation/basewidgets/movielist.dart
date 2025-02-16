import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'movieposter.dart';

class MovieList extends StatelessWidget {
  List<dynamic>? movies;
  String type;
  Function goToDetailsScreen ;
  MovieList({required this.movies , required this.type , required this.goToDetailsScreen});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // the title of the genre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 10),
            child: Text(
                type,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.displayMedium
            ),
          ),
          // the movies
          CarouselSlider(
            items: movies?.map((movie) => MoviePoster(movie: movie , goToDetailsScreen: goToDetailsScreen)).toList(),
            options: CarouselOptions(
              height: 220,
              viewportFraction: 0.32,
              disableCenter: true,
              initialPage: 1,
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
              autoPlay: false,
              enlargeFactor: 0.32,
              scrollDirection: Axis.horizontal,
              reverse: true,
              animateToClosest: true,
            ),
          )
        ],
      ),
    );
  }
}
