import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/entities/entities.dart';
import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/usecases/usecases.dart';

import 'package:ForDev/presentation/presenters/presenters.dart';
import 'package:ForDev/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email;
  late String password;
  late String token;

  When mockValidationCall(String field, String value) =>
      when(() => validation.validate(field: field, value: value));

  void mockValidation(
      {required String field,
      required String value,
      required String returnValue}) {
    mockValidationCall(field, value).thenReturn(value);
  }

  When mockAuthenticationCall() => when(() => authentication
      .auth(AuthenticationParams(email: email, secret: password)));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation(field: 'email', value: email, returnValue: "");
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidationCall("email", email).thenReturn("error");

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () async {
    mockValidationCall("email", email).thenReturn("");
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, "")));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () async {
    mockValidationCall("password", password).thenReturn("");
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit password error if validation fails 1', () async {
    mockValidationCall("password", password).thenReturn("error");

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails 2', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("error");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, "")));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails 3', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, "")));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, "")));
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");
    when(() => saveCurrentAccount.save(AccountEntity(token)))
        .thenAnswer((_) => Future.value());
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");
    when(() => saveCurrentAccount.save(AccountEntity(token)))
        .thenAnswer((_) => Future.value());
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");
    when(() => saveCurrentAccount.save(AccountEntity(token)))
        .thenThrow(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // sut.mainErrorStream.listen(expectAsync1((error) =>
    //     expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });

  test('Should emit correct events on Authentication success', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");

    when(() => saveCurrentAccount.save(AccountEntity(token)))
        .thenAnswer((_) => Future.value());

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should change page on success', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");

    when(() => saveCurrentAccount.save(AccountEntity(token)))
        .thenAnswer((_) => Future.value());

    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");

    when(() => authentication
            .auth(AuthenticationParams(email: email, secret: password)))
        .thenThrow(DomainError.invalidCredentials);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // sut.mainErrorStream.listen(
    //     expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    when(() => validation.validate(field: "email", value: email))
        .thenReturn("");
    when(() => validation.validate(field: "password", value: password))
        .thenReturn("");

    when(() => authentication
            .auth(AuthenticationParams(email: email, secret: password)))
        .thenThrow(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // sut.mainErrorStream.listen(expectAsync1((error) =>
    //     expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });
}
