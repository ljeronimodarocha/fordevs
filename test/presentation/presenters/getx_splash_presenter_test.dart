import 'package:ForDev/domain/entities/entities.dart';
import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:ForDev/presentation/presenters/presenters.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late GetxSplashPresenter sut;
  late LoadCurrentAccountSpy loadCurrentAccount;

  When mockLoadCurrentAccountCall() => when(() => loadCurrentAccount.load());

  void mockLoadCurrentAccount({AccountEntity? account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    when(() => loadCurrentAccount.load())
        .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on error', () async {
    mockLoadCurrentAccountError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount(durationInSeconds: 0);
  });
}
