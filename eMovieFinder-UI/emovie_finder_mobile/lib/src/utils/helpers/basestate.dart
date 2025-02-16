abstract class BaseState {}

class LoadingState extends BaseState {}

class HideDialog extends BaseState {}

class ShowLoadingState extends BaseState {
  String message ;
  ShowLoadingState(this.message);
}

class ShowErrorMessageState extends BaseState {
  String message;
  ShowErrorMessageState(this.message);
}

class ShowSuccessMessageState extends BaseState {
  String message;
  ShowSuccessMessageState(this.message);
}

class MovieDetailsAction extends BaseState {
  num movie;
  MovieDetailsAction(this.movie);
}

class ShowQuestionMessageState extends BaseState{
  String message;
  int? id;
  ShowQuestionMessageState(this.message, {this.id});
}




