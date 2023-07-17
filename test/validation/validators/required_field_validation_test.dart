import 'package:ForDev/utils/i18n/strings.dart';
import 'package:test/test.dart';

import 'package:ForDev/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), '');
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), S.msgRequiredField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(""), S.msgRequiredField);
  });
}
