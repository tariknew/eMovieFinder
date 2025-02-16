abstract class BaseState {}

class HideDialog extends BaseState {}

class LoadingState extends BaseState {}

class EmptyListState extends BaseState{}

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

class ShowQuestionMessageState extends BaseState{
  String message;
  int? id;
  ShowQuestionMessageState(this.message, {this.id});
}

class InputWaiting extends BaseState {}




