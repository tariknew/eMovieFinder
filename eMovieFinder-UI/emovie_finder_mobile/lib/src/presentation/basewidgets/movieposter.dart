import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../style/theme/theme.dart';

class MoviePoster extends StatelessWidget {
  dynamic movie;
  Function goToDetailsScreen;
  MoviePoster({required this.movie, required this.goToDetailsScreen});

  @override
  Widget build(BuildContext context) {
    // Show the image and handle the waiting state and error state
    return InkWell(
      onTap: () {
        goToDetailsScreen(movie.id);
      },
      child: Stack(
        children: [
          FutureBuilder<bool>(
            future: _loadImage(movie.image),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/images/loading.jpg'),
                );
              } else if (snapshot.hasError || movie.image == null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/images/error.png'),
                );
              } else {
                dynamic imageBytes;
                try {
                  imageBytes = base64Decode(movie.image);
                } catch (e) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/images/error.png'),
                  );
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(imageBytes),
                );
              }
            },
          ),
          Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: MyTheme.backGroundColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        movie.formattedAverageRating!,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(width: 5,),
                      const Icon(
                        EvaIcons.star,
                        color: MyTheme.gold,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future<bool> _loadImage(dynamic imageData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return imageData != null;
  }
}