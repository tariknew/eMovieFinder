import '../../../models/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/category/category_insert_request.dart';
import '../../../models/dtos/requests/category/category_update_request.dart';
import '../../../models/searchobjects/category_search_object.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/order_by_enum.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/base_provider.dart';

class CategoryController extends Cubit<BaseState> {
  final BaseProvider<Category> _baseProvider;

  CategoryController()
      : _baseProvider = BaseProvider<Category>('/Category'),
        super(InputWaiting());

  var categories;

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchCategories();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else {
        categories = response?.resultList;
      }

      if (categories == null) {
        return null;
      } else {
        emit(CategoryLoadedState(categories));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Categories Data"));
    }
  }

  Future<PageResultObject<Category>?> fetchCategories() async {
    try {
      var searchRequest = CategorySearchObject(
          orderBy: OrderBy.lastAddedCategories.value, isDescending: true);

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => Category.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  void sortCategoriesByCreationDate() {
    List<Category> categoriesList = List<Category>.from(categories);
    categoriesList.sort((a, b) => b.creationDate!.compareTo(a.creationDate!));
    categories = categoriesList;
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      var response = await _baseProvider.delete(id: categoryId);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "The category has been successfully deleted"));

          categories.removeWhere((category) => category.id == categoryId);

          sortCategoriesByCreationDate();

          if (categories.isEmpty) {
            emit(EmptyListState());
          } else {
            emit(CategoryLoadedState(categories));
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

  Future<void> insertCategory(CategoryInsertRequest request) async {
    try {
      var response =
          await _baseProvider.insert(request: request, isQueryable: false);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Category has been inserted successfully"));

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

  Future<void> updateCategory(
      int categoryId, CategoryUpdateRequest request) async {
    try {
      var response = await _baseProvider.update(
          id: categoryId, request: request, isSpecificMethod: true);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Category has been updated successfully"));
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  void categoryUpdatedScreenError(String message) {
    emit(ShowErrorMessageState(message));
  }

  void categoryInsertScreenError() {
    emit(ShowErrorMessageState("Please fill in all fields"));
  }

  void onDeleteCategoryPress(String message, int categoryId) {
    emit(ShowQuestionMessageState(message, id: categoryId));
  }
}

class CategoryLoadedState extends BaseState {
  List<Category>? categories;

  CategoryLoadedState(this.categories);
}
