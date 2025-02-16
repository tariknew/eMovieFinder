// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      creationDate: json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      createdById: (json['createdById'] as num?)?.toInt(),
      modifiedById: (json['modifiedById'] as num?)?.toInt(),
      formattedCreationDate: json['formattedCreationDate'] as String?,
      formattedModifiedDate: json['formattedModifiedDate'] as String?,
      id: (json['id'] as num?)?.toInt(),
      cartId: (json['cartId'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      finalMoviePrice: json['finalMoviePrice'],
      formattedFinalMoviePrice: json['formattedFinalMoviePrice'] as String?,
      movie: json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
      'id': instance.id,
      'cartId': instance.cartId,
      'movieId': instance.movieId,
      'finalMoviePrice': instance.finalMoviePrice,
      'formattedFinalMoviePrice': instance.formattedFinalMoviePrice,
      'movie': instance.movie,
    };
