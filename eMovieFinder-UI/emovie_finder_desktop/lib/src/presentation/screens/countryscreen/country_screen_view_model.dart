import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/country/country_insert_request.dart';
import '../../../models/dtos/requests/country/country_update_request.dart';
import '../../../models/entities/country.dart';
import '../../../models/searchobjects/country_search_object.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/order_by_enum.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/base_provider.dart';

class CountryController extends Cubit<BaseState> {
  final BaseProvider<Country> _baseProvider;

  CountryController()
      : _baseProvider = BaseProvider<Country>('/Country'),
        super(InputWaiting());

  var countries;

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchCountries();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else {
        countries = response?.resultList;
      }

      if (countries == null) {
        return null;
      } else {
        emit(CountryLoadedState(countries));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Countries Data"));
    }
  }

  Future<PageResultObject<Country>?> fetchCountries() async {
    try {
      var searchRequest = CountrySearchObject(
          orderBy: OrderBy.lastAddedCountries.value, isDescending: true);

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => Country.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  void sortCountriesByCreationDate() {
    List<Country> countriesList = List<Country>.from(countries);
    countriesList.sort((a, b) => b.creationDate!.compareTo(a.creationDate!));
    countries = countriesList;
  }

  Future<void> deleteCountry(int countryId) async {
    try {
      var response = await _baseProvider.delete(id: countryId);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "The country has been successfully deleted"));

          countries.removeWhere((country) => country.id == countryId);

          sortCountriesByCreationDate();

          if (countries.isEmpty) {
            emit(EmptyListState());
          } else {
            emit(CountryLoadedState(countries));
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

  Future<void> insertCountry(CountryInsertRequest request) async {
    try {
      var response =
          await _baseProvider.insert(request: request, isQueryable: false);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Country has been inserted successfully"));

          fetchData();
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future<void> updateCountry(
      int countryId, CountryUpdateRequest request) async {
    try {
      var response = await _baseProvider.update(
          id: countryId, request: request, isSpecificMethod: true);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(
              ShowSuccessMessageState("Country has been updated successfully"));
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  void countryUpdatedScreenError(String message) {
    emit(ShowErrorMessageState(message));
  }

  void countryInsertScreenError() {
    emit(ShowErrorMessageState("Please fill in all fields"));
  }

  void onDeleteCountryPress(String message, int countryId) {
    emit(ShowQuestionMessageState(message, id: countryId));
  }
}

class CountryLoadedState extends BaseState {
  List<Country>? countries;

  CountryLoadedState(this.countries);
}
