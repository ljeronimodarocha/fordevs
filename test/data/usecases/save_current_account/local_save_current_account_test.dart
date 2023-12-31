import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/entities/entities.dart';

import 'package:ForDev/data/cache/cache.dart';
import 'package:ForDev/data/usecases/usecases.dart';

class SaveSecureCacheStorageSpy extends Mock
    implements SaveSecureCacheStorage {}

void main() {
  late LocalSaveCurrentAccount sut;
  late SaveSecureCacheStorageSpy saveSecureCacheStorage;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
    when(() => saveSecureCacheStorage.saveSecure(
        key: 'token', value: account.token)).thenAnswer((_) => Future.value());
  });

  void mockError() {
    when(() => saveSecureCacheStorage.saveSecure(
        key: 'token', value: account.token)).thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(() =>
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
