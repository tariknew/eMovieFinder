import 'package:json_annotation/json_annotation.dart';

part 'order_sales_report_insert_request.g.dart';

@JsonSerializable()
class OrderSalesReportInsertRequest {
  final int movieId;
  final int? year;
  final int? month;

  OrderSalesReportInsertRequest({
    required this.movieId,
    this.year,
    this.month
  });

  factory OrderSalesReportInsertRequest.fromJson(Map<String, dynamic> json) => _$OrderSalesReportInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OrderSalesReportInsertRequestToJson(this);
}