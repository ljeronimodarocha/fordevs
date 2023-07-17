abstract class SignUpPresenter {
  Stream<String> get nameErrorStream;
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<String> get passwordConfirmationErrorStream;
  Stream<String> get mainErrorStream;
  Stream<String> get navigateToStream;

  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String password);
  Future<void> signUp();
}
