part of 'exceptions.dart';

enum MeetingException {
  roomNotFound("Room Not Found"),
  userNotFound('User not found'),
  notAllowedToUpdateRoom('User not allowed to update rooom'),
  wrongPassword('Wrong password!'),
  notAllowToJoinDirectly('User not allow to join directly'),
  notExistsParticipant('Not exists participant'),
  notExistsCCU('Not exists CCU'),
  isAlreadyInRoom('User already in room'),
  hostNotFound('Host not found'),
  notAllowToAddUser('You not allow to add user'),
  hasNotJoinedMeeting('User not joined meeting'),
  memberNotFound('Member Not Found'),
  participantNotFound('Participant Not Found'),
  onlyAllowHostStartRecord('Only allow host start record'),
  onlyAllowHostStopRecord('Only allow host stop record'),
  notAllowedToLeaveTheRoom(
    'Host not allowed to leave the room. You can archive chats if the room no longer active.',
  ),
  onlyHostPermitedToArchivedTheRoom('Only Host permited to archived the room.'),
  ;

  const MeetingException(this.message);

  final String message;

  Failure get meetingFailure => switch (this) {
        MeetingException.roomNotFound => RoomNotFound(),
        MeetingException.userNotFound => UserNotFound(),
        MeetingException.notAllowedToUpdateRoom => NotAllowedToUpdateRoom(),
        MeetingException.wrongPassword => WrongPassword(),
        MeetingException.notAllowToJoinDirectly => NotAllowToJoinDirectly(),
        MeetingException.notExistsParticipant => NotExistsParticipant(),
        MeetingException.notExistsCCU => NotExistsCCU(),
        MeetingException.isAlreadyInRoom => IsAlreadyInRoom(),
        MeetingException.hostNotFound => HostNotFound(),
        MeetingException.notAllowToAddUser => NotAllowToAddUser(),
        MeetingException.hasNotJoinedMeeting => HasNotJoinedMeeting(),
        MeetingException.memberNotFound => MemberNotFound(),
        MeetingException.participantNotFound => ParticipantNotFound(),
        MeetingException.onlyAllowHostStartRecord => OnlyAllowHostStartRecord(),
        MeetingException.onlyAllowHostStopRecord => OnlyAllowHostStopRecord(),
        MeetingException.notAllowedToLeaveTheRoom => NotAllowedToLeaveTheRoom(),
        MeetingException.onlyHostPermitedToArchivedTheRoom =>
          OnlyHostPermitedToArchivedTheRoom(),
      };
}

extension MeetingExceptionX on String {
  Failure get meetingException {
    final int index = MeetingException.values
        .indexWhere((exception) => exception.message == this);

    if (index == -1) return ServerFailure();

    return MeetingException.values[index].meetingFailure;
  }
}
