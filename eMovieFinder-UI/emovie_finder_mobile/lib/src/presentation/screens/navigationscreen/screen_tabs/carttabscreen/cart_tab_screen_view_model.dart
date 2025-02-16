import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/dtos/requests/cart/cart_delete_request.dart';
import '../../../../../models/entities/cart.dart';
import '../../../../../models/entities/cartitem.dart';
import '../../../../../models/searchobjects/cart_search_object.dart';
import '../../../../../models/utilities/page_result_object.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/order_by_enum.dart';
import '../../../../../utils/helpers/userexception.dart';
import '../../../../../utils/providers/app_config_provider.dart';
import '../../../../../utils/providers/base_provider.dart';
import '../../navigation_screen_view_model.dart';

class CartTabScreenViewModel extends Cubit<BaseState> {
  final BaseProvider<Cart> _baseProvider;

  NavigationScreenViewModel? homeScreenViewModel;

  CartTabScreenViewModel()
      : _baseProvider = BaseProvider<Cart>('/Cart'),
        super(InputWaiting());

  var cart;
  var cartTotalPrice;
  var cartItem;

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchCartItems();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else if (response == null) {
        emit(ShowErrorMessageState("Couldn't Load The Cart Data"));
      } else {
        final cartItems = response.resultList
            .expand((result) => result.cartItems ?? [])
            .map((item) {
          return item as CartItem;
        }).toList();

        cartItem = cartItems;

        cart = response.resultList.first;
        cartTotalPrice = cart.formattedCartTotalPrice.toString();

        emit(DataLoadedState(cart, cartItem));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Cart Data"));
    }
  }

  Future<PageResultObject<Cart>?> fetchCartItems() async {
    try {
      var userId = await AppConfigProvider().getValueFromStorage("userId");

      var searchRequest = CartSearchObject(
          userId: int.parse(userId),
          isCartItemIncluded: true,
          orderBy: OrderBy.cartTotalPrice.value,
          isDescending: true);

      var response = await _baseProvider.get(
          searchRequest: searchRequest,
          fromJson: (json) => Cart.fromJson(json)
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<void> removeMovieFromCart(int movieId) async {
    emit(LoadingState());
    try {
      var deleteRequest = CartDeleteRequest(
        cartId: cart.id,
        movieId: movieId,
      );

      String query = '/DeleteMovieFromCart'
          '?CartId=${deleteRequest.cartId}&MovieId=${deleteRequest.movieId}';

      var response = await _baseProvider.update(
          query: query,
          isSpecificMethod: true
      );

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          cartItem.removeWhere((item) => item.movie.id == movieId);

          cartTotalPrice = data[0]['formattedCartTotalPrice'].toString();

          emit(ShowSuccessMessageState(
              "The movie has been successfully removed from the cart"));

          if (cartItem.isEmpty) {
            emit(EmptyListState());
          } else {
            emit(DataLoadedState(cart, cartItem));
          }
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future<void> removeAllFromCart() async {
    try {
      var userId = await AppConfigProvider().getValueFromStorage("userId");

      String query = '/DeleteAllFromCart?userId=$userId';

      var response = await _baseProvider.delete(
        query: query,
        isSpecificMethod: true
      );

      if (response?.statusCode! != 299) {
        var data = response?.data;

        String errorMessage = UserException.extractExceptionMessage(data);
        emit(ShowErrorMessageState(errorMessage));
        }
      } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  void onPressBackAction() {
    emit(BackAction());
  }

  void onRemoveMovieFromCartPress(String message, movieId) {
    emit(ShowQuestionMessageState(message, id: movieId));
  }
}

class InputWaiting extends BaseState {}

class EmptyListState extends BaseState {}

class BackAction extends BaseState {}

class DataLoadedState extends BaseState {
  Cart cart;
  List<dynamic>? cartItem;

  DataLoadedState(this.cart, this.cartItem);
}
