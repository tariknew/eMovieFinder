class BaseValidator {

  // validate on the email form
  String? emailValidation(String input) {
    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
    r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(input)) {
      return "Please Enter A Valid Email";
    }
    return null;
  }

  // validate the password is not less than 8 chars
  String? passwordValidation(String input) {
    if (input.length < 8) {
      return "The Password Must be At Least 8 Characters Long";
    }
    return null;
  }

  // validate on the username if it is not empty and doesn't contain ant spacial characters
  String? usernameValidation(String username){
    if (username.length > 10) {
      return "Username Mustn't Exceed 10 Characters";
    }else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(username)){
      return "Username Mustn't Have Special Characters";
    }else {
      return null;
    }
  }
}

