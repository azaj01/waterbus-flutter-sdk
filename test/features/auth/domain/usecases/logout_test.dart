// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/usecases/logout.dart';
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'login_with_social_test.mocks.dart';

void main() {
  late LogOut usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LogOut(mockAuthRepository);
  });

  test('should call logOut method from the repository', () async {
    // Arrange
    when(mockAuthRepository.logOut())
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, const Right(true));
    verify(mockAuthRepository.logOut());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return a failure when logOut method from the repository fails',
      () async {
    // Arrange
    when(mockAuthRepository.logOut())
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Left(ServerFailure()));
    verify(mockAuthRepository.logOut());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
