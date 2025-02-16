// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moviecategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCategory _$MovieCategoryFromJson(Map<String, dynamic> json) =>
    MovieCategory(
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
      movieId: (json['movieId'] as num?)?.toInt(),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieCategoryToJson(MovieCategory instance) =>
    <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
      'id': instance.id,
      'movieId': instance.movieId,
      'categoryId': instance.categoryId,
      'category': instance.category,
    };
