abstract class Resource {
  String get msgInvalidCredentials;
  String get msgInvalidField;
  String get msgRequiredField;
  String get msgUnexpectedError;

  String get addAccount;
  String get name;
  String get email;
  String get enter;
  String get login;
  String get password;
  String get confirmPassword;
  String get wait;

  Map<String, String> toJson() => {
        'msgInvalidCredentials': msgInvalidCredentials,
        'msgInvalidField': msgInvalidField,
        'msgRequiredField': msgRequiredField,
        'msgUnexpectedError': msgUnexpectedError,
        'addAccount': addAccount,
        'name': name,
        'email': email,
        'enter': enter,
        'login': login,
        'password': password,
        'confirmPassword': confirmPassword,
        'wait': wait,
      };
}
