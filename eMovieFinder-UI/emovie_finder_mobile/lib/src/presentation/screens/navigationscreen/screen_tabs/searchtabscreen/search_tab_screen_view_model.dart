import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/utilities/page_result_object.dart';
import '../../../../../models/searchobjects/movie_search_object.dart';
import '../../../../../models/entities/movie.dart';
import '../../../../../models/entities/category.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/order_by_enum.dart';
import '../../../../../utils/providers/app_config_provider.dart';
import '../../../../../utils/providers/base_provider.dart';
import '../../navigation_screen_view_model.dart';

class SearchTabScreenViewModel extends Cubit<BaseState>{
  final BaseProvider _baseProvider = BaseProvider();

  SearchTabScreenViewModel() : super(EmptyListState());

  PageResultObject<dynamic>? categories;

  NavigationScreenViewModel? homeScreenViewModel;

  AppConfigProvider? provider;

  Future<void> getSearchResults(MovieSearchObject request)async {
    emit(LoadingState());
    try {
      var searchRequest = MovieSearchObject(
          title: request.title,
          categoryId: request.categoryId,
          priceGTE: request.priceGTE,
          priceLTE: request.priceLTE,
          isAdministratorPanel: false,
          orderBy: request.orderBy,
          isDescending: request.isDescending
      );

      var response = await getMovies(searchRequest);

      if(response?.count == 0) {
        emit(EmptyListState());
      }
      else if (response == null) {
        emit(ShowErrorMessageState("Couldn't Load The Movies"));
      } else {
        emit(MoviesLoadedState(response));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Movies"));
    }
  }

  Future<double?> getLatestMoviePrice()async {
    try {
      var searchRequest = MovieSearchObject(
          isAdministratorPanel: false,
          orderBy: OrderBy.moviePrice.value,
          isDescending: true
      );

      var response = await getMovies(searchRequest);

      if (response == null) {
        emit(ShowErrorMessageState("Couldn't Load The Latest Movie Price"));

        return null;
      } else {
        final latestMoviePrice = response.resultList.first.price;

        return latestMoviePrice;
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Latest Movie Price"));

      return null;
    }
  }

  Future<PageResultObject<dynamic>?> getMovies(MovieSearchObject searchRequest)async{
    try {
      String query = '/Movie';

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        query: query,
        fromJson: (json) => Movie.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<PageResultObject<dynamic>?> fetchCategories()async{
    try {
      String query = '/Category';

      var response = await _baseProvider.get(
        query: query,
        fromJson: (json) => Category.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  void goToDetailsScreen(num movie){
    emit(MovieDetailsAction(movie));
  }

  void onPressBackAction(){
    emit(BackAction());
  }
}

class EmptyListState extends BaseState{}

class BackAction extends BaseState{}

class MoviesLoadedState extends BaseState {
  PageResultObject<dynamic>? movies ;
  MoviesLoadedState(this.movies);
}