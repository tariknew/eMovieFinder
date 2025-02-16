import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/entities/order.dart';
import '../../../../../models/searchobjects/order_search_object.dart';
import '../../../../../models/utilities/page_result_object.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/order_by_enum.dart';
import '../../../../../utils/providers/app_config_provider.dart';
import '../../../../../utils/providers/base_provider.dart';

class OrderHistoryTabScreenViewModel extends Cubit<BaseState> {
  final BaseProvider<Order> _baseProvider;

  OrderHistoryTabScreenViewModel()
      : _baseProvider = BaseProvider<Order>('/Order'),
        super(InputWaiting());

  var orders;

  void onPressBackAction() {
    emit(BackAction());
  }

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchOrders();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else if (response == null) {
        emit(ShowErrorMessageState("Couldn't Load The Orders Data"));
      } else {
        orders = response.resultList;

        emit(DataLoadedState(orders));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Orders Data"));
    }
  }

  Future<PageResultObject<Order>?> fetchOrders() async {
    try {
      var userId = await AppConfigProvider().getValueFromStorage("userId");

      var searchRequest = OrderSearchObject(
        userId: int.parse(userId),
        isOrderMovieIncluded: true,
        orderBy: OrderBy.lastAddedOrders.value,
        isDescending: true
      );

      var response = await _baseProvider.get(
          searchRequest: searchRequest,
          fromJson: (json) => Order.fromJson(json));

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }
}

class InputWaiting extends BaseState {}

class EmptyListState extends BaseState {}

class BackAction extends BaseState {}

class DataLoadedState extends BaseState {
  List<Order>? orders;

  DataLoadedState(this.orders);
}
