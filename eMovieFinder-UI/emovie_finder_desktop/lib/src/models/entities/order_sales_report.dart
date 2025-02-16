import 'package:json_annotation/json_annotation.dart';

part 'order_sales_report.g.dart';

@JsonSerializable()
class OrderSalesReport {
  final int? totalOrders;

  OrderSalesReport({
    this.totalOrders
  });

  factory OrderSalesReport.fromJson(Map<String, dynamic> json) => _$OrderSalesReportFromJson(json);
  Map<String, dynamic> toJson() => _$OrderSalesReportToJson(this);
}