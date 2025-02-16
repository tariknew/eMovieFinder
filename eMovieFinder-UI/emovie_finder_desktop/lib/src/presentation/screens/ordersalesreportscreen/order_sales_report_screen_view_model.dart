import 'package:emovie_finder_desktop/src/models/entities/order_sales_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/order/order_sales_report_insert_request.dart';
import '../../../models/entities/movie.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/providers/base_provider.dart';

class OrderController extends Cubit<BaseState> {
  final BaseProvider<OrderSalesReport> _baseProvider;

  PageResultObject<Movie>? movies;

  OrderController()
      : _baseProvider = BaseProvider<OrderSalesReport>('/Order/GetOrderSalesReport'),
        super(InputWaiting());

  Future<OrderSalesReport?> getOrderSalesReport(OrderSalesReportInsertRequest searchRequest) async {
    try {
      var response = await _baseProvider.getOrderSalesReport(
        searchRequest: searchRequest,
        fromJson: (json) => OrderSalesReport.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  void orderScreenError() {
    emit(ShowErrorMessageState("Please choose a movie"));
  }

  void orderScreenSuccessful(String message) {
    emit(ShowSuccessMessageState(message));
  }
}

