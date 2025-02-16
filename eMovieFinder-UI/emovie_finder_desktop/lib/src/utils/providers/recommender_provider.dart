import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/base_state.dart';
import '../helpers/dialog.dart';
import '../helpers/userexception.dart';
import 'base_provider.dart';

class RecommenderController extends Cubit<BaseState> {
  final BaseProvider _baseProvider;

  RecommenderController()
      : _baseProvider = BaseProvider('/Recommender/TrainFavouriteMoviesModel'),
        super(InputWaiting());

  Future<void> trainFavouriteMoviesModel(BuildContext context) async {
    try {
      var response =
      await _baseProvider.insert(isQueryable: false, isSpecificMethod: true);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          MyDialogUtils.showSuccessDialog(
            context: context,
            message: "The model has been successfully trained",
            posActionTitle: "Ok",
          );
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);

          MyDialogUtils.showErrorDialog(
            context: context,
            message: errorMessage,
            posActionTitle: "Try Again",
          );
        }
      }
    } catch (e) {
      MyDialogUtils.showErrorDialog(
        context: context,
        message: e.toString().split('Exception: ').last,
        posActionTitle: "Try Again",
      );
    }
  }
}
