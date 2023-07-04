import 'package:ForDev/validation/protocols/protocols.dart';
import 'package:ForDev/validation/validators/validators.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;

  void mockValidation1(String error) {
    when(() => validation1.validate("any_value")).thenReturn(error);
  }

  void mockValidation2(String error) {
    when(() => validation2.validate("any_value")).thenReturn(error);
  }

  void mockValidation3(String error) {
    when(() => validation3.validate("any_value")).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(() => validation1.field).thenReturn('other_field');
    when(() => validation1.validate("other_field")).thenReturn("");
    when(() => validation1.validate("")).thenReturn("");

    validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn('any_field');
    when(() => validation2.validate("any_field")).thenReturn("");

    validation3 = FieldValidationSpy();
    when(() => validation3.field).thenReturn('any_field');
    when(() => validation3.validate("any_field")).thenReturn("");

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    mockValidation1('');
    mockValidation2('');
    mockValidation3('');
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, "");
  });

  test('Should return the first error', () {
    mockValidation1('error_1');
    mockValidation2('error_2');
    mockValidation3('error_3');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'error_2');
  });
}
