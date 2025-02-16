// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_sales_report_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSalesReportInsertRequest _$OrderSalesReportInsertRequestFromJson(
        Map<String, dynamic> json) =>
    OrderSalesReportInsertRequest(
      movieId: (json['movieId'] as num).toInt(),
      year: (json['year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderSalesReportInsertRequestToJson(
        OrderSalesReportInsertRequest instance) =>
    <String, dynamic>{
      'movieId': instance.movieId,
      'year': instance.year,
      'month': instance.month,
    };
