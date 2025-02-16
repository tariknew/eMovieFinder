// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordermovie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderMovie _$OrderMovieFromJson(Map<String, dynamic> json) => OrderMovie(
      id: (json['id'] as num?)?.toInt(),
      orderId: (json['orderId'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      formattedFinalMoviePrice: json['formattedFinalMoviePrice'] as String?,
      formattedMovieTitle: json['formattedMovieTitle'] as String?,
      movie: json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderMovieToJson(OrderMovie instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'movieId': instance.movieId,
      'formattedFinalMoviePrice': instance.formattedFinalMoviePrice,
      'formattedMovieTitle': instance.formattedMovieTitle,
      'movie': instance.movie,
    };
