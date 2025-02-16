class UserConfirmEmailRequest {
  final String Email;
  final String ConfirmationCode;

  UserConfirmEmailRequest({required this.Email, required this.ConfirmationCode});
}