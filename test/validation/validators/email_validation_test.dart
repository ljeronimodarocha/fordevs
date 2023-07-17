import 'package:ForDev/utils/i18n/strings.dart';
import 'package:test/test.dart';

import 'package:ForDev/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), '');
  });

  test('Should return null if email is null', () {
    expect(sut.validate(""), "");
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('rodrigo.manguinho@gmail.com'), "");
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('rodrigo.manguinho'), S.msgInvalidField);
  });
}
