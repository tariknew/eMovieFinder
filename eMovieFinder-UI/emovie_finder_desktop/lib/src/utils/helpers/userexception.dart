class UserException {
  static String extractExceptionMessage(Map<String, dynamic> data) {
    String errorMessage = '';

      if (data['errors'] != null && data['errors']['USERERROR'] != null) {
        errorMessage = data['errors']['USERERROR'].join(", ");
      } else if (data['errors'] != null && data['errors']['ERROR'] != null) {
        errorMessage = data['errors']['ERROR'].join(", ");
      }

    return errorMessage;
  }
}