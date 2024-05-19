// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/meetings/usecases/index.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late GetInfoMeeting getInfoMeeting;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    getInfoMeeting = GetInfoMeeting(mockRepository);
  });

  const testMeetingCode = 123;
  const getMeetingParams = GetMeetingParams(code: testMeetingCode);
  const testMeeting = Meeting(title: 'Test Meeting');

  test('should have correct props', () {
    // Arrange
    const param1 = GetMeetingParams(code: 1);
    const param2 = GetMeetingParams(code: 2);

    // Act & Assert
    expect(param1.props, [param1.code]);
    expect(param2.props, [param2.code]);
    expect(param1.props, isNot(equals(param2.props)));
  });

  test('should call getInfoMeeting on the repository with the given parameters',
      () async {
    // Arrange
    when(mockRepository.getInfoMeeting(getMeetingParams))
        .thenAnswer((_) async => const Right(testMeeting));

    // Act
    final result = await getInfoMeeting(getMeetingParams);

    // Assert
    expect(result, const Right(testMeeting));
    verify(mockRepository.getInfoMeeting(getMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });
}
