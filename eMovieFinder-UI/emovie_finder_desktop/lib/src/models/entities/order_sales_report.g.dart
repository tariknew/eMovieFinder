// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_sales_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSalesReport _$OrderSalesReportFromJson(Map<String, dynamic> json) =>
    OrderSalesReport(
      totalOrders: (json['totalOrders'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderSalesReportToJson(OrderSalesReport instance) =>
    <String, dynamic>{
      'totalOrders': instance.totalOrders,
    };
